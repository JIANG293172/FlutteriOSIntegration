import 'package:flutter/material.dart';
import '../shared/seat_level.dart';

/// 座椅卡片Widget
class SeatCard extends StatelessWidget {
  final bool seatHeatingEnabled;
  final bool driverSeatHeating;
  final bool passengerSeatHeating;
  final ValueChanged<bool>? onHeatingToggled;

  const SeatCard({
    required this.seatHeatingEnabled,
    required this.driverSeatHeating,
    required this.passengerSeatHeating,
    this.onHeatingToggled,
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
              const Icon(Icons.event_seat, color: Colors.blueGrey),
              const SizedBox(width: 8),
              const Text('座椅加热'),
              const Spacer(),
              Switch(value: seatHeatingEnabled, onChanged: onHeatingToggled),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SeatLevel(level: '驾驶位', active: driverSeatHeating),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SeatLevel(level: '副驾位', active: passengerSeatHeating),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
