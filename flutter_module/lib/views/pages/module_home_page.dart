import 'package:flutter/material.dart';
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
    // 默认发起车辆列表请求
    _fetchCarsByBrandCode();
  }

  /// 发起车辆列表请求
  Future<void> _fetchCarsByBrandCode() async {
    print('--- 开始发起车辆列表请求 ---');

    // 1. 构建请求对象
    var request = QYAPIRequest("/app2/api/v2/user/cars-by-brand-code");
    // 设置特定的 Host
    request.instanceHost = "https://pre-m.iov.changan.com.cn";

    // 2. 准备业务参数
    var params = {
      "brandCode": "OX",
      "token": "rH81PymvQOQPR78ZaCag5qFD8M1sulio",
      "type": "0",
    };

    // 3. 发起请求
    // 注意：根据抓包数据，该接口使用 application/x-www-form-urlencoded
    QYNetworkManager.shared
        .request(request, params: params)
        .then((response) {
          if (response.success) {
            print('车辆列表请求成功: ${response.originalData}');
          } else {
            print('车辆列表请求失败: ${response.message}');
          }
        })
        .catchError((error) {
          print('车辆列表请求异常: $error');
        });
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
    final Uri url = Uri.parse('https://www.baidu.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('无法打开百度官网')));
      }
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
