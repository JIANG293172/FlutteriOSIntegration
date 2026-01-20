import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyModuleApp());

class MyModuleApp extends StatelessWidget {
  const MyModuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Module',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ModuleHomePage(),
    );
  }
}

class ModuleHomePage extends StatelessWidget {
  const ModuleHomePage({super.key});

  final MethodChannel _channel = const MethodChannel('com.changan.carcontrol/channel');

  @override
  Widget build(BuildContext context) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "updateBattery":
          final int battery = call.arguments['battery'] as int;
          return "电量已更新为：$battery%";
        default:
          throw PlatformException(code: "METHOD_NOT_FOUND", message: "方法未实现");
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Module 车控页面'),
        centerTitle: true,
      ),
      body: const CarControlPage(),
    );
  }
}

class CarControlPage extends StatelessWidget {
  const CarControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _HeaderCard(),
          const SizedBox(height: 16),
          _CarImageCard(),
          const SizedBox(height: 16),
          _StatusRow(),
          const SizedBox(height: 16),
          _SectionTitle(title: '快捷控制'),
          const SizedBox(height: 10),
          _QuickActionsGrid(),
          const SizedBox(height: 16),
          _SectionTitle(title: '空调'),
          const SizedBox(height: 10),
          _ClimateCard(),
          const SizedBox(height: 16),
          _SectionTitle(title: '座椅'),
          const SizedBox(height: 10),
          _SeatCard(),
          const SizedBox(height: 16),
          _SectionTitle(title: '安全'),
          const SizedBox(height: 10),
          _SecurityCard(),
          const SizedBox(height: 16),
          _SectionTitle(title: '充电'),
          const SizedBox(height: 10),
          _ChargeCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.9),
            colorScheme.primary.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.directions_car, color: Colors.blueAccent, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '我的车辆',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  '电量 78% · 续航 420km',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '已锁车',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarImageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: Icon(Icons.directions_car_filled, size: 72, color: Colors.black54),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatusItem(title: '车辆状态', value: '正常'),
        const SizedBox(width: 12),
        _StatusItem(title: '胎压', value: '2.4 bar'),
        const SizedBox(width: 12),
        _StatusItem(title: '门窗', value: '全关'),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatusItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(icon: Icons.lock_open, label: '解锁'),
      _ActionItem(icon: Icons.lock, label: '锁车'),
      _ActionItem(icon: Icons.ac_unit, label: '空调'),
      _ActionItem(icon: Icons.lightbulb, label: '灯光'),
      _ActionItem(icon: Icons.local_gas_station, label: '油箱'),
      _ActionItem(icon: Icons.location_on, label: '定位'),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions
          .map((item) => SizedBox(
                width: (MediaQuery.of(context).size.width - 16 * 2 - 12 * 2) / 3,
                child: _ActionTile(item: item),
              ))
          .toList(),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;

  const _ActionItem({required this.icon, required this.label});
}

class _ActionTile extends StatelessWidget {
  final _ActionItem item;

  const _ActionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _ClimateCard extends StatelessWidget {
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
                child: const Text('22℃'),
              ),
            ],
          ),
          Slider(
            value: 22,
            min: 16,
            max: 30,
            onChanged: (_) {},
          ),
          Row(
            children: [
              Expanded(
                child: _PillButton(
                  icon: Icons.air,
                  label: '自动',
                  active: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PillButton(
                  icon: Icons.waves,
                  label: '除雾',
                  active: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _PillButton({required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: active ? Colors.blueGrey : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? Colors.white : Colors.black54, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: active ? Colors.white : Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _SeatCard extends StatelessWidget {
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
              Switch(value: true, onChanged: (_) {}),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _SeatLevel(level: '驾驶位', active: true)),
              const SizedBox(width: 12),
              Expanded(child: _SeatLevel(level: '副驾位', active: false)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeatLevel extends StatelessWidget {
  final String level;
  final bool active;

  const _SeatLevel({required this.level, required this.active});

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

class _SecurityCard extends StatelessWidget {
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
          _SecurityRow(title: '车门', value: '已锁', icon: Icons.lock_outline),
          const SizedBox(height: 12),
          _SecurityRow(title: '车窗', value: '已关闭', icon: Icons.window),
          const SizedBox(height: 12),
          _SecurityRow(title: '后备箱', value: '已关闭', icon: Icons.inventory_2),
        ],
      ),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SecurityRow({required this.title, required this.value, required this.icon});

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

class _ChargeCard extends StatelessWidget {
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
              const Text('78%', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.78,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ChargeTile(title: '预计续航', value: '420km'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ChargeTile(title: '预计完成', value: '1小时20分'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChargeTile extends StatelessWidget {
  final String title;
  final String value;

  const _ChargeTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
