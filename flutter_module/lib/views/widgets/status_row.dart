import 'package:flutter/material.dart';
import '../shared/status_item.dart';

/// 状态行Widget
class StatusRow extends StatelessWidget {
  final String vehicleStatus;
  final double tirePressure;
  final String doorStatus;

  const StatusRow({
    required this.vehicleStatus,
    required this.tirePressure,
    required this.doorStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatusItem(title: '车辆状态', value: vehicleStatus),
        const SizedBox(width: 12),
        StatusItem(title: '胎压', value: '$tirePressure bar'),
        const SizedBox(width: 12),
        StatusItem(title: '门窗', value: doorStatus),
      ],
    );
  }
}
