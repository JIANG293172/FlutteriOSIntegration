/// 车辆数据模型
class CarModel {
  final int battery;
  final int range;
  final String status;
  final String lockStatus;
  final double tirePressure;
  final String doorStatus;

  CarModel({
    required this.battery,
    required this.range,
    required this.status,
    required this.lockStatus,
    required this.tirePressure,
    required this.doorStatus,
  });

  /// 从JSON创建
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      battery: json['battery'] ?? 78,
      range: json['range'] ?? 420,
      status: json['status'] ?? '正常',
      lockStatus: json['lockStatus'] ?? '已锁车',
      tirePressure: json['tirePressure'] ?? 2.4,
      doorStatus: json['doorStatus'] ?? '全关',
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'battery': battery,
      'range': range,
      'status': status,
      'lockStatus': lockStatus,
      'tirePressure': tirePressure,
      'doorStatus': doorStatus,
    };
  }

  /// 复制对象
  CarModel copyWith({
    int? battery,
    int? range,
    String? status,
    String? lockStatus,
    double? tirePressure,
    String? doorStatus,
  }) {
    return CarModel(
      battery: battery ?? this.battery,
      range: range ?? this.range,
      status: status ?? this.status,
      lockStatus: lockStatus ?? this.lockStatus,
      tirePressure: tirePressure ?? this.tirePressure,
      doorStatus: doorStatus ?? this.doorStatus,
    );
  }
}
