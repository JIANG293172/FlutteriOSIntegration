import 'dart:convert';
import '../services/qy_network_manager.dart';

/// 车辆信息 Model
class QYCarModel {
  final String carId;
  final String carName;
  final String vin;
  final String confName;
  final bool caCar;
  final List<String> devices;
  final String currentDeviceType;
  final Map<String, dynamic> funCode;

  QYCarModel({
    required this.carId,
    required this.carName,
    required this.vin,
    required this.confName,
    required this.caCar,
    required this.devices,
    required this.currentDeviceType,
    required this.funCode,
  });

  factory QYCarModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parsedFunCode = {};
    if (json['funCode'] != null) {
      try {
        parsedFunCode = jsonDecode(json['funCode']);
      } catch (e) {
        parsedFunCode = {};
      }
    }

    return QYCarModel(
      carId: json['carId']?.toString() ?? '',
      carName: json['carName'] ?? '',
      vin: json['vin'] ?? '',
      confName: json['confName'] ?? '',
      caCar: json['caCar'] ?? false,
      devices: List<String>.from(json['devices'] ?? []),
      currentDeviceType: json['currentDeviceType'] ?? '',
      funCode: parsedFunCode,
    );
  }
}

/// 车辆状态数据 Model (对应 /app2/api/car/data)
class QYCarStatusModel {
  final double rightRearWindowDegree;
  final double airConditioningSetTemperature;
  final int acChargeGunConnectionState;
  final int frontDefrosterSwitch;
  final int leftRearDoorrWindow;
  final int leftFrontDoorStatus;
  final int passengerDoorLock;
  final int hood;
  final int trunk;
  final int socDsp;
  final int chargeStatus;
  final double totalOdometer;
  final String vin;
  final double environmentalTemp;

  QYCarStatusModel({
    required this.rightRearWindowDegree,
    required this.airConditioningSetTemperature,
    required this.acChargeGunConnectionState,
    required this.frontDefrosterSwitch,
    required this.leftRearDoorrWindow,
    required this.leftFrontDoorStatus,
    required this.passengerDoorLock,
    required this.hood,
    required this.trunk,
    required this.socDsp,
    required this.chargeStatus,
    required this.totalOdometer,
    required this.vin,
    required this.environmentalTemp,
  });

  factory QYCarStatusModel.fromJson(Map<String, dynamic> json) {
    return QYCarStatusModel(
      rightRearWindowDegree: (json['rightRearWindowDegree'] as num?)?.toDouble() ?? 0.0,
      airConditioningSetTemperature: (json['airConditioningSetTemperature'] as num?)?.toDouble() ?? 0.0,
      acChargeGunConnectionState: json['acChargeGunConnectionState'] ?? 0,
      frontDefrosterSwitch: json['frontDefrosterSwitch'] ?? 0,
      leftRearDoorrWindow: json['leftRearDoorrWindow'] ?? 0,
      leftFrontDoorStatus: json['leftFrontDoorStatus'] ?? 0,
      passengerDoorLock: json['passengerDoorLock'] ?? 0,
      hood: json['hood'] ?? 0,
      trunk: json['trunk'] ?? 0,
      socDsp: json['socDsp'] ?? 0,
      chargeStatus: json['chargeStatus'] ?? 0,
      totalOdometer: (json['totalOdometer'] as num?)?.toDouble() ?? 0.0,
      vin: json['vin'] ?? '',
      environmentalTemp: (json['environmentalTemp'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// 封装的网络请求类
class QYCarApiService {
  static const String baseUrl = "https://pre-m.iov.changan.com.cn";
  static const String brandCode = "OX";
  static const String token = "rH81PymvQOQPR78ZaCag5qFD8M1sulio";
  static const String type = "0";

  /// 获取车辆列表
  static Future<List<QYCarModel>> fetchCarList() async {
    var request = QYAPIRequest("/app2/api/v2/user/cars-by-brand-code");
    request.instanceHost = baseUrl;

    var params = {
      "brandCode": brandCode,
      "token": token,
      "type": type,
    };

    final response = await QYNetworkManager.shared.request(request, params: params);
    if (response.success && response.data is List) {
      return (response.data as List).map((e) => QYCarModel.fromJson(e)).toList();
    }
    return [];
  }

  /// 获取车辆详细状态
  static Future<QYCarStatusModel?> fetchCarData(String carId) async {
    var request = QYAPIRequest("/app2/api/car/data");
    request.instanceHost = baseUrl;

    var params = {
      "carId": carId,
      "keys": "*",
      "token": token,
    };

    final response = await QYNetworkManager.shared.request(request, params: params);
    if (response.success && response.data != null) {
      return QYCarStatusModel.fromJson(response.data);
    }
    return null;
  }
}
