import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 新增

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

  // 新增：定义MethodChannel
  final MethodChannel _channel = const MethodChannel('com.changan.carcontrol/channel');

  @override
  Widget build(BuildContext context) {
    // 新增：初始化监听
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
      appBar: AppBar(title: const Text('Flutter Module 车控页面')),
      body: const Center(
        child: Text('这是嵌入iOS工程的Flutter页面', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}