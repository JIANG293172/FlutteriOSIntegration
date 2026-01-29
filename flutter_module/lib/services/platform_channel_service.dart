import 'package:flutter/services.dart';

/// 平台通道服务 - 处理与iOS的通信
class PlatformChannelService {
  static const String _channelName = 'com.changan.carcontrol/channel';
  static final MethodChannel _channel = MethodChannel(_channelName);

  /// 初始化平台通道处理程序
  static void setupMethodCallHandler({
    required Function(int battery) onBatteryUpdate,
  }) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "updateBattery":
          final int battery = call.arguments['battery'] as int;
          onBatteryUpdate(battery);
          return "电量已更新为：$battery%";
        default:
          throw PlatformException(
            code: "METHOD_NOT_FOUND",
            message: "方法未实现",
          );
      }
    });
  }

  /// 调用iOS方法示例
  static Future<dynamic> invokeIosMethod(String method, [dynamic arguments]) async {
    try {
      final result = await _channel.invokeMethod(method, arguments);
      return result;
    } catch (e) {
      return null;
    }
  }
}
