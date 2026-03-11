import 'package:flutter/material.dart';
import 'package:flutter_module/views/pages/FlutterExamples.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../viewmodels/car_control_viewmodel.dart';
import '../../services/router_service.dart';
import '../../services/qy_network_manager.dart';
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
    // 车辆列表和状态请求已经移至 CarControlViewModel 中自动执行
  }

  /// 发起车辆列表请求 (已废弃，逻辑已移至 ViewModel)
  Future<void> _fetchCarsByBrandCode() async {
    // 逻辑已移至 CarControlViewModel.fetchCarList()
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

  /// 打开百度官网
  Future<void> _openBaiduWebsite() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Example7_TextField()),
    ).then((result) {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarControlViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Module 车控页面'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.language),
            onPressed: _openBaiduWebsite,
            tooltip: '打开百度官网',
          ),
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
