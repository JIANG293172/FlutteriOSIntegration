import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/car_control_viewmodel.dart';
import '../../services/router_service.dart';
import 'car_control_page.dart';
import 'login_page.dart';

/// 模块首页 - 初始化ViewModel和平台通道
class ModuleHomePage extends StatefulWidget {
  const ModuleHomePage({super.key});

  @override
  State<ModuleHomePage> createState() => _ModuleHomePageState();
}

class _ModuleHomePageState extends State<ModuleHomePage> {
  @override
  void initState() {
    super.initState();
    // 应用启动完成后，调用iOS的getDeviceInfo方法
    _getDeviceInfo();
  }

  /// 调用iOS的getDeviceInfo方法获取设备信息
  Future<void> _getDeviceInfo() async {
    try {
      print('开始调用iOS的getDeviceInfo方法...');
      final result = await RouterService.invoke('getDeviceInfo');
      print('获取设备信息成功: $result');

      // 可以在这里处理获取到的设备信息
      if (result is Map<String, dynamic>) {
        final deviceName = result['deviceName'] ?? '未知设备';
        final systemVersion = result['systemVersion'] ?? '未知版本';
        print('设备名称: $deviceName');
        print('系统版本: $systemVersion');
      }
    } catch (e) {
      print('调用getDeviceInfo失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarControlViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Module 车控页面'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                // 跳转到登录页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ).then((result) {
                  // 处理登录结果
                  if (result != null && result is Map<String, dynamic>) {
                    bool success = result['success'] ?? false;
                    if (success) {
                      print('登录成功');
                      // 可以在这里更新UI或执行其他登录成功后的操作
                    }
                  }
                });
              },
              tooltip: '登录',
            ),
          ],
        ),
        body: const CarControlPage(),
      ),
    );
  }
}
