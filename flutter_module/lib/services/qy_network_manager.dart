import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

/// API响应模型
class QYAPIResponse {
  bool success = false; // 状态
  String message = ""; // 消息
  int code = -100; // 401:未登录 0
  int encr = 0; // 是否加密
  dynamic data; // 返回的数据
  int timestamp = 0; // 时间戳
  int status = 0;
  String deKey = "";
  dynamic originalData; //  接口返回的原数据  报错时有值

  QYAPIResponse(dynamic json, [String key = ""]) {
    deKey = key;
    if (json is Map<String, dynamic>) {
      message = json["msg"] as String? ?? "";
      code = json["code"] as int? ?? -100;
      success = code == 0;
      if (json["encr"] is bool) {
        encr = json["encr"] ? 1 : 0;
      } else if (json["encr"] is int) {
        encr = json["encr"];
      }
      if (encr == 1) {
        String dataStr = json["data"] as String? ?? "";
        try {
          var decoded = jsonDecode(dataStr);
          if (decoded is List) {
            data = decoded;
          } else if (decoded is Map) {
            data = decoded;
          } else {
            data = dataStr;
          }
        } catch (e) {
          data = dataStr;
        }
      } else {
        data = json["data"];
      }
      timestamp = json["timestamp"] as int? ?? 0;
      status = json["status"] as int? ?? 0;
      // 如果错误码不为空，也失败
      if (code != 0) {
        success = false;
        originalData = json;
      }
    } else {
      originalData = json;
    }
  }

  Map<String, dynamic> toDic() {
    return {
      "success": success,
      "message": message,
      "code": code,
      "encr": encr,
      "data": data,
      "timestamp": timestamp,
      "status": status,
    };
  }
}

/// API请求模型
class QYAPIRequest {
  static String host = "";
  String path = "/";
  Map<String, dynamic>? params;
  String? pathParam;
  Map<String, dynamic>? queryParams;
  String method = "post";
  String? fullUrlStr;

  QYAPIRequest(this.path, [this.params]);

  String get url {
    return fullUrl();
  }

  QYAPIRequest addQuery(Map<String, dynamic> query) {
    queryParams = query;
    return this;
  }

  QYAPIRequest setMethod(String method) {
    this.method = method;
    return this;
  }

  QYAPIRequest get get {
    method = "get";
    return this;
  }

  QYAPIRequest get post {
    method = "post";
    return this;
  }

  QYAPIRequest get put {
    method = "put";
    return this;
  }

  QYAPIRequest get delete {
    method = "delete";
    return this;
  }

  String fullUrl() {
    if (fullUrlStr != null) {
      return fullUrlStr!;
    }

    // 1.原始url
    var urlStr = host + path;
    // 不是以/ 打头的不处理
    if (!path.startsWith("/")) {
      urlStr = path;
    }

    // 2.添加路径参数
    if (pathParam != null) {
      urlStr += "/pathParam";
    }

    // 3. 添加query参数
    if (queryParams != null && queryParams!.isNotEmpty) {
      var queryString = queryParams!.entries
          .map((e) => "${e.key}=${Uri.encodeComponent(e.value.toString())}")
          .join("&");
      if (urlStr.contains("?")) {
        urlStr += "&$queryString";
      } else {
        urlStr += "?$queryString";
      }
    }

    fullUrlStr = urlStr;
    return urlStr;
  }
}

/// 网络管理器
class QYNetworkManager {
  static final QYNetworkManager shared = QYNetworkManager._private();
  String _kNetUUID = "";
  final Duration timeout = Duration(seconds: 30);
  late SharedPreferences _prefs;
  late DeviceInfoPlugin _deviceInfo;

  QYNetworkManager._private() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _deviceInfo = DeviceInfoPlugin();
    _kNetUUID = await _getUUID();
  }

  /// 发起请求
  Future<QYAPIResponse> request(
    QYAPIRequest request, {
    String method = "post",
    Map<String, dynamic>? params,
  }) async {
    try {
      // 处理URL
      var url = request.fullUrl();
      if (!url.startsWith("http")) {
        url = QYAPIRequest.host + url;
      }

      // 优先使用传入的 params，如果没有则使用 request.params
      var finalParams = handleParams(params ?? request.params);
      var headers = await handleHeader(finalParams);

      http.Response response;

      // 根据请求方法发起请求
      switch (method.toLowerCase()) {
        case "get":
          response = await http
              .get(Uri.parse(url), headers: headers)
              .timeout(timeout);
          break;
        case "put":
          response = await http
              .put(
                Uri.parse(url),
                headers: headers,
                body: jsonEncode(finalParams),
              )
              .timeout(timeout);
          break;
        case "delete":
          response = await http
              .delete(
                Uri.parse(url),
                headers: headers,
                body: jsonEncode(finalParams),
              )
              .timeout(timeout);
          break;
        default: // post
          response = await http
              .post(
                Uri.parse(url),
                headers: headers,
                body: jsonEncode(finalParams),
              )
              .timeout(timeout);
          break;
      }

      // 处理响应
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var result = QYAPIResponse(json);
        handleCodeError(result);
        return result;
      } else {
        return QYAPIResponse({
          "code": -100,
          "msg": "网络异常，状态码：${response.statusCode}",
        });
      }
    } catch (error) {
      print("Network error: $error");
      return QYAPIResponse({"code": -100, "msg": "网络异常，请稍后再试"});
    }
  }

  /// 处理错误码
  void handleCodeError(QYAPIResponse response) {
    if (!response.success) {
      switch (response.code) {
        case 0:
          break;
        case 401:
          // 未登录处理
          QYApiConfig.shared.logOut();
          break;
        case -100:
          break;
        case 20001:
          break;
        default:
          break;
      }
    }
  }

  /// 处理参数
  Map<String, dynamic> handleParams(Map<String, dynamic>? params) {
    var p = <String, dynamic>{};
    if (params != null) {
      p.addAll(params);
    }
    return p;
  }

  /// 处理头部
  Future<Map<String, String>> handleHeader(Map<String, dynamic>? params) async {
    var timeInterval = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = "$timeInterval";
    var jsonString = dicToSortJSON(params) ?? "{}";

    var sign = jsonString + timeStamp + "J5i6UkJi8voBEEyE1g5q";
    var md5Sign = md5.convert(utf8.encode(sign)).toString().toUpperCase();

    // 获取设备信息
    var deviceModel = await _getDeviceModel();
    var deviceSDK = await _getDeviceSDK();
    var operatorName = await _getOperatorName();

    return {
      "token": QYApiConfig.shared.userToken,
      "zh-sign": md5Sign,
      "os": Platform.isIOS ? "ios" : "android",
      "version": "1.0.0", // 实际项目中应该从配置中获取
      "timeStamp": timeStamp,
      "Content-Type": "application/json; charset=utf-8",
      "channel": "App Store",
      "uuid": strToECB(await _getUUID()),
      "brand": Platform.isIOS ? "苹果" : "Android",
      "model": deviceModel,
      "manuFacture": Platform.isIOS ? "苹果" : "Android",
      "operatorName": operatorName,
      "networkState": "4G", // 实际项目中应该检测网络状态
      "deviceSDK": deviceSDK,
      "X-VCS-User-Token": QYApiConfig.shared.userToken,
    };
  }

  /// 获取UUID
  Future<String> _getUUID() async {
    if (_kNetUUID.isNotEmpty) {
      return _kNetUUID;
    }

    // 从本地存储获取
    var uuid = _prefs.getString("os_uuid");
    if (uuid != null && uuid.isNotEmpty) {
      _kNetUUID = uuid;
      return uuid;
    }

    // 生成新的UUID
    _kNetUUID = _generateUUID();
    await _prefs.setString("os_uuid", _kNetUUID);
    return _kNetUUID;
  }

  /// 生成UUID
  String _generateUUID() {
    var random = Random();
    var uuid = "";
    for (var i = 0; i < 32; i++) {
      uuid += random.nextInt(16).toRadixString(16);
    }
    return uuid;
  }

  /// 获取设备型号
  Future<String> _getDeviceModel() async {
    if (Platform.isIOS) {
      var info = await _deviceInfo.iosInfo;
      return info.model ?? "iPhone";
    } else if (Platform.isAndroid) {
      var info = await _deviceInfo.androidInfo;
      return info.model ?? "Android";
    }
    return "Unknown";
  }

  /// 获取设备SDK版本
  Future<String> _getDeviceSDK() async {
    if (Platform.isIOS) {
      var info = await _deviceInfo.iosInfo;
      return info.systemVersion ?? "";
    } else if (Platform.isAndroid) {
      var info = await _deviceInfo.androidInfo;
      return info.version.release ?? "";
    }
    return "";
  }

  /// 获取运营商名称
  Future<String> _getOperatorName() async {
    // 实际项目中应该使用专门的插件获取运营商信息
    return "";
  }

  /// 将字典转换为排序后的JSON字符串
  String? dicToSortJSON(Map<String, dynamic>? dic) {
    if (dic == null) return "{}";
    try {
      // 对键进行排序
      var sortedKeys = dic.keys.toList()..sort();
      var sortedMap = <String, dynamic>{};
      for (var key in sortedKeys) {
        sortedMap[key] = dic[key];
      }
      return jsonEncode(sortedMap);
    } catch (e) {
      return "{}";
    }
  }
}

/// API配置
class QYApiConfig {
  static final QYApiConfig shared = QYApiConfig._private();
  String baseHost = "https://api.example.com";
  String userToken = "";

  QYApiConfig._private();

  /// 登录
  void logIn(String token) {
    userToken = token;
    // 实际项目中应该将token存储到本地
  }

  /// 登出
  void logOut() {
    userToken = "";
    // 实际项目中应该清除本地存储的token
  }
}

/// AES-ECB加密
String strToECB(String text) {
  if (text.isEmpty) return "";
  try {
    final key = encrypt.Key.fromUtf8('MtO3dAXMgF7zWiXE');
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(text);
    return encrypted.base64;
  } catch (e) {
    return "";
  }
}

/// 扩展方法
extension QYAPIRequestExtension on QYAPIRequest {
  Future<QYAPIResponse> send() async {
    return await QYNetworkManager.shared.request(this, method: method);
  }
}
