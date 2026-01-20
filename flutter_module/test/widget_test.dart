// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_module/main.dart';

void main() {
  testWidgets('Car control page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MyModuleApp());

    expect(find.text('Flutter Module 车控页面'), findsOneWidget);
    expect(find.text('车辆状态'), findsOneWidget);
    expect(find.text('快捷控制'), findsOneWidget);
  });
}
