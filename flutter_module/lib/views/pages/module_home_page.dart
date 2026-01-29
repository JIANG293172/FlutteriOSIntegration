import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/car_control_viewmodel.dart';
import 'car_control_page.dart';

/// 模块首页 - 初始化ViewModel和平台通道
class ModuleHomePage extends StatelessWidget {
  const ModuleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarControlViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Module 车控页面'),
          centerTitle: true,
        ),
        body: const CarControlPage(),
      ),
    );
  }
}
