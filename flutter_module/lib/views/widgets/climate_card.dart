import 'package:flutter/material.dart';
import '../shared/pill_button.dart';

/// 空调卡片Widget
class ClimateCard extends StatelessWidget {
  final double targetTemperature;
  final bool climateAuto;
  final bool climateDefog;
  final ValueChanged<double>? onTemperatureChanged;
  final VoidCallback? onAutoPressed;
  final VoidCallback? onDefogPressed;

  const ClimateCard({
    required this.targetTemperature,
    required this.climateAuto,
    required this.climateDefog,
    this.onTemperatureChanged,
    this.onAutoPressed,
    this.onDefogPressed,
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
              const Icon(Icons.thermostat, color: Colors.blueGrey),
              const SizedBox(width: 8),
              const Text('目标温度'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${targetTemperature.toInt()}℃'),
              ),
            ],
          ),
          Slider(
            value: targetTemperature,
            min: 16,
            max: 30,
            onChanged: onTemperatureChanged,
          ),
          Row(
            children: [
              Expanded(
                child: PillButton(
                  icon: Icons.air,
                  label: '自动',
                  active: climateAuto,
                  onPressed: onAutoPressed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PillButton(
                  icon: Icons.waves,
                  label: '除雾',
                  active: climateDefog,
                  onPressed: onDefogPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
