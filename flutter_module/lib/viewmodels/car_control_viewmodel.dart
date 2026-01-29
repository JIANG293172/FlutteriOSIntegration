import 'package:flutter/foundation.dart';
import '../models/car_model.dart';
import '../models/status_model.dart';
import '../services/platform_channel_service.dart';
import '../services/qy_car_api_service.dart';

/// 车控业务逻辑ViewModel - 管理车辆数据和状态
class CarControlViewModel extends ChangeNotifier {
  // 车辆数据
  late CarModel _carModel;
  late StatusModel _statusModel;

  // QY 业务数据
  List<QYCarModel> _carList = [];
  QYCarModel? _selectedCar;
  QYCarStatusModel? _qyStatusModel;
  bool _isLoading = false;

  // Getter
  CarModel get carModel => _carModel;
  StatusModel get statusModel => _statusModel;
  List<QYCarModel> get carList => _carList;
  QYCarModel? get selectedCar => _selectedCar;
  QYCarStatusModel? get qyStatusModel => _qyStatusModel;
  bool get isLoading => _isLoading;

  CarControlViewModel() {
    _initializeData();
    _setupPlatformChannel();
    // 启动时自动获取车辆列表
    fetchCarList();
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

  /// 获取车辆列表
  Future<void> fetchCarList() async {
    _isLoading = true;
    notifyListeners();

    try {
      _carList = await QYCarApiService.fetchCarList();
      if (_carList.isNotEmpty) {
        // 默认选中第一辆车
        await selectCar(_carList.first);
      }
    } catch (e) {
      debugPrint('获取车辆列表失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 选中并切换车辆
  Future<void> selectCar(QYCarModel car) async {
    _selectedCar = car;
    notifyListeners();

    // 切换车辆后，立即请求该车辆的状态数据
    await fetchCarStatus(car.carId);
  }

  /// 获取车辆详细状态
  Future<void> fetchCarStatus(String carId) async {
    try {
      final status = await QYCarApiService.fetchCarData(carId);
      if (status != null) {
        _qyStatusModel = status;
        // 同步更新旧的 UI 模型数据
        _syncToLegacyModels(status);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('获取车辆状态失败: $e');
    }
  }

  /// 将新的业务数据同步到原有的 UI 模型中，确保现有 UI 正常显示
  void _syncToLegacyModels(QYCarStatusModel qyStatus) {
    // 同步 CarModel
    _carModel = _carModel.copyWith(
      battery: qyStatus.socDsp,
      status: qyStatus.chargeStatus == 3 ? "正在充电" : "正常",
      lockStatus: qyStatus.passengerDoorLock == 1 ? "已解锁" : "已锁车",
    );

    // 同步 StatusModel
    _statusModel = _statusModel.copyWith(
      targetTemperature: qyStatus.airConditioningSetTemperature,
      climateDefog: qyStatus.frontDefrosterSwitch == 1,
      doorLockStatus: qyStatus.passengerDoorLock == 1 ? "已解锁" : "已锁",
      windowStatus: qyStatus.leftRearDoorrWindow == 1 ? "已打开" : "已关闭",
      trunkStatus: qyStatus.trunk == 1 ? "已打开" : "已关闭",
      chargeProgress: qyStatus.socDsp / 100.0,
    );
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
