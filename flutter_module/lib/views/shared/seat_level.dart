import 'package:flutter/material.dart';

/// 座椅等级Widget
class SeatLevel extends StatelessWidget {
  final String level;
  final bool active;

  const SeatLevel({
    required this.level,
    required this.active,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: active ? Colors.blueGrey : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          level,
          style: TextStyle(color: active ? Colors.white : Colors.black54),
        ),
      ),
    );
  }
}
