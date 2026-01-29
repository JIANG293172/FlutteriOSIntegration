import 'package:flutter/material.dart';

/// 安全状态行Widget
class SecurityRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SecurityRow({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Text(title),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
