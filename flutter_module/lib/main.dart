import 'package:flutter/material.dart';
import 'views/pages/module_home_page.dart';
import 'services/router_service.dart';

void main() {
  // 确保 WidgetsFlutterBinding 初始化
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化路由服务
  RouterService.initialize();
  // 注册示例路由处理器
  registerExampleHandlers();
  runApp(const MyModuleApp());
}

// 注册示例路由处理器
void registerExampleHandlers() {
  // 示例1: 显示通知
  RouterService.registerHandler('showNotification', (params) {
    final String message = params['message'] ?? '默认通知';
    print('显示通知: $message');
    // 这里可以集成Flutter的通知库来显示实际的通知
    return {'success': true, 'message': '通知已显示'};
  });

  // 示例2: 计算两个数的和
  RouterService.registerHandler('calculateSum', (params) {
    final int a = params['a'] ?? 0;
    final int b = params['b'] ?? 0;
    final int sum = a + b;
    return {'success': true, 'result': sum};
  });

  // 示例3: 获取当前时间
  RouterService.registerHandler('getCurrentTime', (params) {
    final now = DateTime.now();
    return {
      'success': true,
      'time': now.toIso8601String(),
      'timestamp': now.millisecondsSinceEpoch
    };
  });
}

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
