import 'package:flutter/material.dart';
import '../shared/security_row.dart';

/// 安全卡片Widget
class SecurityCard extends StatelessWidget {
  final String doorLockStatus;
  final String windowStatus;
  final String trunkStatus;

  const SecurityCard({
    required this.doorLockStatus,
    required this.windowStatus,
    required this.trunkStatus,
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
          SecurityRow(title: '车门', value: doorLockStatus, icon: Icons.lock_outline),
          const SizedBox(height: 12),
          SecurityRow(title: '车窗', value: windowStatus, icon: Icons.window),
          const SizedBox(height: 12),
          SecurityRow(title: '后备箱', value: trunkStatus, icon: Icons.inventory_2),
        ],
      ),
    );
  }
}
