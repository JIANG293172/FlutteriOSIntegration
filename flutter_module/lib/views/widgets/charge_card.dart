import 'package:flutter/material.dart';
import '../shared/charge_tile.dart';

/// 充电卡片Widget
class ChargeCard extends StatelessWidget {
  final int battery;
  final int range;
  final double chargeProgress;
  final int estimatedTime;

  const ChargeCard({
    required this.battery,
    required this.range,
    required this.chargeProgress,
    required this.estimatedTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.battery_charging_full, color: Colors.blueGrey),
              const SizedBox(width: 8),
              const Text('当前电量'),
              const Spacer(),
              Text('$battery%', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: chargeProgress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ChargeTile(title: '预计续航', value: '${range}km'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChargeTile(
                  title: '预计完成',
                  value: '${estimatedTime ~/ 60}小时${estimatedTime % 60}分',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
