import 'package:flutter/material.dart';
import '../shared/action_item.dart';

/// 快捷操作网格Widget
class QuickActionsGrid extends StatelessWidget {
  final VoidCallback? onUnlock;
  final VoidCallback? onLock;
  final VoidCallback? onAirCondition;
  final VoidCallback? onLights;
  final VoidCallback? onFuelDoor;
  final VoidCallback? onLocate;

  const QuickActionsGrid({
    this.onUnlock,
    this.onLock,
    this.onAirCondition,
    this.onLights,
    this.onFuelDoor,
    this.onLocate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      (ActionItem(icon: Icons.lock_open, label: '解锁'), onUnlock),
      (ActionItem(icon: Icons.lock, label: '锁车'), onLock),
      (ActionItem(icon: Icons.ac_unit, label: '空调'), onAirCondition),
      (ActionItem(icon: Icons.lightbulb, label: '灯光'), onLights),
      (ActionItem(icon: Icons.local_gas_station, label: '油箱'), onFuelDoor),
      (ActionItem(icon: Icons.location_on, label: '定位'), onLocate),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions
          .map((action) => SizedBox(
                width: (MediaQuery.of(context).size.width - 16 * 2 - 12 * 2) / 3,
                child: _ActionTile(
                  item: action.$1,
                  onPressed: action.$2,
                ),
              ))
          .toList(),
    );
  }
}

/// 操作卡片Widget
class _ActionTile extends StatelessWidget {
  final ActionItem item;
  final VoidCallback? onPressed;

  const _ActionTile({required this.item, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            Icon(item.icon, color: Colors.blueGrey),
            const SizedBox(height: 8),
            Text(item.label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
