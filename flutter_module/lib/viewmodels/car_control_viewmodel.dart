import 'package:flutter/foundation.dart';
import '../models/car_model.dart';
import '../models/status_model.dart';
import '../services/platform_channel_service.dart';

/// 车控业务逻辑ViewModel - 管理车辆数据和状态
class CarControlViewModel extends ChangeNotifier {
  // 车辆数据
  late CarModel _carModel;
  late StatusModel _statusModel;

  // Getter
  CarModel get carModel => _carModel;
  StatusModel get statusModel => _statusModel;

  CarControlViewModel() {
    _initializeData();
    _setupPlatformChannel();
  }

  /// 初始化数据
  void _initializeData() {
    _carModel = CarModel(
      battery: 78,
      range: 420,
      status: '正常',
      lockStatus: '已锁车',
      tirePressure: 2.4,
      doorStatus: '全关',
    );
    _statusModel = StatusModel.initial();
  }

  /// 设置平台通道处理
  void _setupPlatformChannel() {
    PlatformChannelService.setupMethodCallHandler(
      onBatteryUpdate: (battery) {
        _updateBattery(battery);
      },
    );
  }

  /// 更新电量
  void _updateBattery(int battery) {
    _carModel = _carModel.copyWith(battery: battery);
    notifyListeners();
  }

  // =================== 空调控制 ===================

  /// 更新目标温度
  void updateTargetTemperature(double temperature) {
    _statusModel = _statusModel.copyWith(targetTemperature: temperature);
    notifyListeners();
  }

  /// 切换自动模式
  void toggleClimateAuto() {
    _statusModel = _statusModel.copyWith(climateAuto: !_statusModel.climateAuto);
    notifyListeners();
  }

  /// 切换除雾
  void toggleClimateDefog() {
    _statusModel = _statusModel.copyWith(climateDefog: !_statusModel.climateDefog);
    notifyListeners();
  }

  // =================== 座椅控制 ===================

  /// 切换座椅加热总开关
  void toggleSeatHeating() {
    _statusModel = _statusModel.copyWith(seatHeatingEnabled: !_statusModel.seatHeatingEnabled);
    notifyListeners();
  }

  /// 切换驾驶位加热
  void toggleDriverSeatHeating() {
    _statusModel = _statusModel.copyWith(driverSeatHeating: !_statusModel.driverSeatHeating);
    notifyListeners();
  }

  /// 切换副驾位加热
  void togglePassengerSeatHeating() {
    _statusModel = _statusModel.copyWith(passengerSeatHeating: !_statusModel.passengerSeatHeating);
    notifyListeners();
  }

  // =================== 快捷操作 ===================

  /// 解锁车辆
  void unlockCar() {
    _carModel = _carModel.copyWith(lockStatus: '已解锁');
    notifyListeners();
  }

  /// 锁车
  void lockCar() {
    _carModel = _carModel.copyWith(lockStatus: '已锁车');
    notifyListeners();
  }

  /// 打开空调
  void startAirCondition() {
    // TODO: 实现逻辑
  }

  /// 打开灯光
  void turnOnLights() {
    // TODO: 实现逻辑
  }

  /// 打开油箱盖
  void openFuelDoor() {
    // TODO: 实现逻辑
  }

  /// 定位车辆
  void locateCar() {
    // TODO: 实现逻辑
  }
}
