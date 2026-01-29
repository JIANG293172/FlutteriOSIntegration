/// 车辆功能状态模型
class StatusModel {
  // 空调状态
  final double targetTemperature;
  final bool climateAuto;
  final bool climateDefog;

  // 座椅状态
  final bool seatHeatingEnabled;
  final bool driverSeatHeating;
  final bool passengerSeatHeating;

  // 安全状态
  final String doorLockStatus;
  final String windowStatus;
  final String trunkStatus;

  // 充电状态
  final double chargeProgress;
  final int estimatedTime;

  StatusModel({
    // 空调
    required this.targetTemperature,
    required this.climateAuto,
    required this.climateDefog,
    // 座椅
    required this.seatHeatingEnabled,
    required this.driverSeatHeating,
    required this.passengerSeatHeating,
    // 安全
    required this.doorLockStatus,
    required this.windowStatus,
    required this.trunkStatus,
    // 充电
    required this.chargeProgress,
    required this.estimatedTime,
  });

  /// 默认状态
  factory StatusModel.initial() {
    return StatusModel(
      targetTemperature: 22,
      climateAuto: true,
      climateDefog: false,
      seatHeatingEnabled: true,
      driverSeatHeating: true,
      passengerSeatHeating: false,
      doorLockStatus: '已锁',
      windowStatus: '已关闭',
      trunkStatus: '已关闭',
      chargeProgress: 0.78,
      estimatedTime: 80, // 分钟
    );
  }

  /// 复制对象
  StatusModel copyWith({
    double? targetTemperature,
    bool? climateAuto,
    bool? climateDefog,
    bool? seatHeatingEnabled,
    bool? driverSeatHeating,
    bool? passengerSeatHeating,
    String? doorLockStatus,
    String? windowStatus,
    String? trunkStatus,
    double? chargeProgress,
    int? estimatedTime,
  }) {
    return StatusModel(
      targetTemperature: targetTemperature ?? this.targetTemperature,
      climateAuto: climateAuto ?? this.climateAuto,
      climateDefog: climateDefog ?? this.climateDefog,
      seatHeatingEnabled: seatHeatingEnabled ?? this.seatHeatingEnabled,
      driverSeatHeating: driverSeatHeating ?? this.driverSeatHeating,
      passengerSeatHeating: passengerSeatHeating ?? this.passengerSeatHeating,
      doorLockStatus: doorLockStatus ?? this.doorLockStatus,
      windowStatus: windowStatus ?? this.windowStatus,
      trunkStatus: trunkStatus ?? this.trunkStatus,
      chargeProgress: chargeProgress ?? this.chargeProgress,
      estimatedTime: estimatedTime ?? this.estimatedTime,
    );
  }
}
