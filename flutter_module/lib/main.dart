import 'package:flutter/material.dart';
import 'views/pages/module_home_page.dart';

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
