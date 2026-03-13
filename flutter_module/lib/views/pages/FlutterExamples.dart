import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlutterExamplePage extends StatelessWidget {
  const FlutterExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Example'), centerTitle: true),

      body: const SafeArea(child: Center(child: Text('flutter example page'))),
    );
  }
}

class Example1_HelloWord extends StatelessWidget {
  const Example1_HelloWord({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hello workd',
      home: Scaffold(
        appBar: AppBar(title: const Text('hello example1')),
        body: const Center(child: Text('hello flutter example1')),
      ),
    );
  }
}

class Example2_TextWidget extends StatelessWidget {
  const Example2_TextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('文本样式样式')),
        body: const Center(
          child: Text(
            'Flutter 文本样式\n多行生成',
            textAlign: .center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: .bold,
              decoration: .underline,
              decorationColor: Colors.red,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class Example3_Container extends StatelessWidget {
  const Example3_Container({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('container example4 容器')),
        body: Center(
          child: Container(
            width: 200,
            height: 200,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(color: Colors.red, width: 3),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
            ),
            child: const Text('容器内容'),
          ),
        ),
      ),
    );
  }
}

class Example4_RowColumn extends StatelessWidget {
  const Example4_RowColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('row/column布局')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: .center,
              children: const [Text('左边'), Text('中间'), Text('右边')],
            ),
            const SizedBox(height: 20),
            Column(children: [Text('上'), Text('中'), Text('下')]),
          ],
        ),
      ),
    );
  }
}

class Example5_SizeBox_Spacer extends StatelessWidget {
  const Example5_SizeBox_Spacer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('间距控制')),
        body: Row(
          children: [
            const Text('文本1'),
            const SizedBox(width: 30),
            const Text('文本2'),
            const Spacer(),
            const Text('文本3'),
          ],
        ),
      ),
    );
  }
}

class Example6_Padding_Margin extends StatelessWidget {
  const Example6_Padding_Margin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('padding/margin')),

        body: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: Colors.lightBlue,
          child: const Text('内边距样式'),
        ),
      ),
    );
  }
}

class Example7_TextField extends StatefulWidget {
  const Example7_TextField({super.key});

  @override
  State<Example7_TextField> createState() => _Example_TextFieldState();
}

class _Example_TextFieldState extends State<Example7_TextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('输入框演示')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: '请输入内容',
                  labelText: '用户名',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                maxLength: 20,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(title: Text('请输入内容')),
                ),
                child: const Text('获取输入'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Example8_ElevatedButton extends StatelessWidget {
  const Example8_ElevatedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('按钮演示')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('普通按钮点击'))),
                child: const Text('ElevatedButton'),
              ),
              const SizedBox(height: 20),
              TextButton(onPressed: () {}, child: const Text('text button')),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {},
                child: const Text('outlinedbutton'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: null, child: const Text('禁用按钮')),
            ],
          ),
        ),
      ),
    );
  }
}

class Example9_Icon_Icons extends StatelessWidget {
  const Example9_Icon_Icons({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('图标样式')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.home, size: 40, color: Colors.red),
              SizedBox(height: 20),
              Icon(Icons.settings, size: 40, color: Colors.blue),
              SizedBox(height: 20),
              Icon(Icons.favorite, size: 40, color: Colors.pink),
              SizedBox(height: 20),
              Icon(Icons.add_circle, size: 40, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}

class Example10_Image extends StatelessWidget {
  const Example10_Image({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('图片加载')),
        body: Column(
          children: [
            Image.network(
              'https://flutter.dev/images/flutter-logo-sharing.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/flutter.png', width: 100, height: 100),
          ],
        ),
      ),
    );
  }
}

class Example11_Checkbox extends StatefulWidget {
  const Example11_Checkbox({super.key});

  @override
  State<Example11_Checkbox> createState() => _Example11_CheckboxState();
}

class _Example11_CheckboxState extends State<Example11_Checkbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('复选框示例')),
        body: Center(
          child: CheckboxListTile(
            title: const Text('同意协议'),
            value: _isChecked,
            onChanged: (value) => setState(() => _isChecked = value!),
            secondary: const Icon(Icons.check),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ),
    );
  }
}

class Example12_Radio extends StatefulWidget {
  const Example12_Radio({super.key});

  @override
  State<Example12_Radio> createState() => _Example12_RadioState();
}

class _Example12_RadioState extends State<Example12_Radio> {
  String _selectedValue = '男';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('单选框')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RadioListTile(
              title: const Text('男'),
              value: '男',
              groupValue: _selectedValue,
              onChanged: (value) => setState(() => _selectedValue = value!),
            ),
            RadioListTile(
              title: const Text('女'),
              value: '女',
              groupValue: _selectedValue,
              onChanged: (value) => setState(() => _selectedValue = value!),
            ),
            Text('选中 $_selectedValue'),
          ],
        ),
      ),
    );
  }
}

class Example13_Switch extends StatefulWidget {
  const Example13_Switch({super.key});

  @override
  State<Example13_Switch> createState() => _Example13_SwitchState();
}

class _Example13_SwitchState extends State<Example13_Switch> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('开关示例')),
        body: Center(
          child: SwitchListTile(
            title: const Text('开启通知'),
            value: _isOn,
            onChanged: (value) => setState(() => _isOn = value),
            secondary: const Icon(Icons.notifications),
          ),
        ),
      ),
    );
  }
}

class Example14_Slider extends StatefulWidget {
  const Example14_Slider({super.key});

  @override
  State<Example14_Slider> createState() => _Example14_SliderState();
}

class _Example14_SliderState extends State<Example14_Slider> {
  double _value = 0.5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('滑动条示例')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Slider(
                value: _value,
                onChanged: (value) => setState(() => _value = value),
                min: 0,
                max: 100,
                divisions: 10,
                label: '值: ${(_value * 100).round()}%',
              ),
              const SizedBox(height: 20),
              Text('当前值: ${(_value * 100).round()}%'),
            ],
          ),
        ),
      ),
    );
  }
}

class Example15_AlertDialog extends StatelessWidget {
  const Example15_AlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('对话框示例')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('提示'),
                  content: const Text('这是一个提示'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('确定'),
                    ),
                  ],
                );
              },
            ),
            child: const Text('显示对话框'),
          ),
        ),
      ),
    );
  }
}

class Example16_SnackBar extends StatelessWidget {
  const Example16_SnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('snackBar')),
      body: Center(
        child: Builder(
          builder: (ctx) => ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: const Text('操作成功'),
                  action: SnackBarAction(label: '撤销', onPressed: () {}),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('显示 snackBar'),
          ),
        ),
      ),
    );
  }
}

class Example17_BottomSheet extends StatelessWidget {
  const Example17_BottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('bottom sheet')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),

              builder: (context) => SizedBox(
                height: 200,
                child: Column(
                  children: [
                    ListTile(title: Text('选项1'), leading: Icon(Icons.edit)),
                    ListTile(title: Text('选项2'), leading: Icon(Icons.delete)),
                    ListTile(title: Text('选项3'), leading: Icon(Icons.share)),
                  ],
                ),
              ),
            ),
            child: const Text('显示底部弹窗'),
          ),
        ),
      ),
    );
  }
}

class Example18_ListView extends StatelessWidget {
  const Example18_ListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(20, (index) => '列表项 ${index + 1}');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ListView列表视图')),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(items[index]),
            leading: const Icon(Icons.list),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('点击了 ${items[index]}'))),
          ),
        ),
      ),
    );
  }
}

class Example19_GridView extends StatelessWidget {
  const Example19_GridView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(20, (index) => '网格项 ${index + 1}');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('GridView网格视图')),

        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(10),
          itemCount: items.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(10),
            child: Center(child: Text(items[index])),
          ),
        ),
      ),
    );
  }
}

class Example20_Stack extends StatelessWidget {
  const Example20_Stack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Stack层叠布局')),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(width: 200, height: 200, color: Colors.red),
              Container(width: 150, height: 150, color: Colors.green),
              Container(width: 100, height: 100, color: Colors.blue),
              const Text(
                '叠层文本',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Positioned(
                bottom: 10,
                right: 10,
                child: Icon(Icons.star, size: 30, color: Colors.yellow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Example21_StatefullWidget extends StatefulWidget {
  const Example21_StatefullWidget({super.key});

  @override
  State<Example21_StatefullWidget> createState() =>
      _Example21_StatefullWidgetState();
}

class _Example21_StatefullWidgetState extends State<Example21_StatefullWidget> {
  int _count = 0;

  void _increment() {
    setState(() => _count++);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('StatefulWidget示例')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('点击次数 $_count', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _increment, child: const Text('点击增加')),
            ],
          ),
        ),
      ),
    );
  }
}

class Example22_ValueNotifier extends StatefulWidget {
  const Example22_ValueNotifier({super.key});

  @override
  State<Example22_ValueNotifier> createState() =>
      _Example22_ValueNotifierState();
}

class _Example22_ValueNotifierState extends State<Example22_ValueNotifier> {
  final ValueNotifier<int> _count = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ValueNotifier示例')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: _count,
                builder: (context, value, child) =>
                    Text('点击次数 $value', style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _count.value++,
                child: const Text('点击增加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // 必须调用，通知 UI 更新
  }
}

class Example23_Provider extends StatelessWidget {
  const Example23_Provider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Counter(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Provider状态管理示例')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<Counter>(
                  builder: (context, counter, child) => Text(
                    '点击次数 ${counter.count}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<Counter>(
                  builder: (context, counter, child) => ElevatedButton(
                    onPressed: counter.increment,
                    child: const Text('点击增加'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CounterController extends GetxController {
  final RxInt count = 0.obs;
  void increment() => count.value++;
}

class Example24_GetX extends StatelessWidget {
  const Example24_GetX({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('GetX管理')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Text(
                  '点击次数: ${controller.count.value}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.increment,
                child: const Text('点击增加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountInhritedWidget extends InheritedWidget {
  final int count;
  final Function() increment;
  final Widget child;

  const CountInhritedWidget({
    super.key,
    required this.count,
    required this.increment,
    required this.child,
  }) : super(child: child);

  static CountInhritedWidget? of(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<CountInhritedWidget>();
    assert(widget != null, 'CountInhritedWidget not found in context');
    return widget;
  }

  @override
  bool updateShouldNotify(CountInhritedWidget oldWidget) {
    return count != oldWidget.count;
  }
}

class Example25_InheritedWidget extends StatefulWidget {
  const Example25_InheritedWidget({super.key});

  @override
  State<Example25_InheritedWidget> createState() =>
      _Example25_InheritedWidget();
}

class _Example25_InheritedWidget extends State<Example25_InheritedWidget> {
  int _count = 0;

  void _increment() {
    setState(() => _count++);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountInhritedWidget(
        count: _count,
        increment: _increment,
        child: Scaffold(
          appBar: AppBar(title: const Text('InheritedWidget示例')),
          body: const CountDisplay(),
          floatingActionButton: const IncrementButton(),
        ),
      ),
    );
  }
}

class CountDisplay extends StatelessWidget {
  const CountDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final widget = CountInhritedWidget.of(context);
    return Text(
      '点击次数: ${widget?.count ?? 0}',
      style: const TextStyle(fontSize: 20),
    );
  }
}

class IncrementButton extends StatelessWidget {
  const IncrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    final widget = CountInhritedWidget.of(context);
    return FloatingActionButton(
      onPressed: widget?.increment,
      child: const Icon(Icons.add),
    );
  }
}

class Example26_SetState_Async extends StatefulWidget {
  const Example26_SetState_Async({super.key});

  @override
  State<Example26_SetState_Async> createState() =>
      _Example26_SetState_AsyncState();
}

class _Example26_SetState_AsyncState extends State<Example26_SetState_Async> {
  String _status = '未开始';

  Future<void> _simulateAsyncOperation() async {
    setState(() {
      _status = '加载中...';
    });

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _status = '加载完成';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('异步更新状态示例')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simulateAsyncOperation,
                child: const Text('模拟异步操作'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Example27_Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void increment() {
    _count++;
    notifyListeners();
  }
}

class Example27_ThemeModel with ChangeNotifier {
  Color _color = Colors.white;
  Color get color => _color;

  void changeColor() {
    _color = _color == Colors.blue ? Colors.red : Colors.blue;
    notifyListeners();
  }
}

class Example27_MutiProvider extends StatelessWidget {
  const Example27_MutiProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Example27_Counter()),
        ChangeNotifierProvider(create: (_) => Example27_ThemeModel()),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('多Provider示例')),
          body: Builder(
            builder: (innerContext) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer2<Example27_Counter, Example27_ThemeModel>(
                    builder: (context, counter, theme, _) => Text(
                      '计数 ${counter.count}',
                      style: TextStyle(fontSize: 20, color: theme.color),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            innerContext.read<Example27_Counter>().increment(),
                        child: const Text('增加'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => innerContext
                            .read<Example27_ThemeModel>()
                            .changeColor(),
                        child: const Text('切换颜色'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Example29_StreamBuilder extends StatefulWidget {
  const Example29_StreamBuilder({super.key});

  @override
  State<Example29_StreamBuilder> createState() =>
      _Example29_StreamBuilderState();
}

class _Example29_StreamBuilderState extends State<Example29_StreamBuilder> {
  late Stream<int> _countStream;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _countStream = Stream.periodic(const Duration(seconds: 1), (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('BuilderState')),
        body: Center(
          child: StreamBuilder<int>(
            stream: _countStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('加载中...', style: TextStyle(fontSize: 20));
              } else if (snapshot.hasError) {
                return Text(
                  '错误: ${snapshot.error}',
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                );
              } else {
                return Text(
                  '数据流: ${snapshot.data}',
                  style: const TextStyle(fontSize: 20),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class Example30_FutureBuilder extends StatelessWidget {
  const Example30_FutureBuilder({super.key});

  Future<String> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return '数据加载完成';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('FutureBuilder示例')),
        body: Center(
          child: FutureBuilder<String>(
            future: _fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  '请求失败 ${snapshot.error}',
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                );
              } else {
                return Text(
                  '请求结果${snapshot.data}',
                  style: const TextStyle(fontSize: 20),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class Example31_GetX_Storage extends StatefulWidget {
  const Example31_GetX_Storage({super.key});

  @override
  State<Example31_GetX_Storage> createState() => _Example31_GetX_Storage();
}

class _Example31_GetX_Storage extends State<Example31_GetX_Storage> {
  final GetStorage _box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('GetStorage示例')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '存储值: ${_box.read('counter') ?? 0}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  int count = _box.read('counter') ?? 0;
                  _box.write('counter', count + 1);
                },
                child: const Text('增加存储值'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _box.remove('counter');
                  Get.forceAppUpdate();
                },
                child: const Text('清空存储'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Example32_UserModel with ChangeNotifier {
  String _name = 'Flutter';

  int _age = 18;

  String get name => _name;
  int get age => _age;

  void changeName(String name) {
    _name = name;
    notifyListeners();
  }

  void changAge(int age) {
    _age = age;
    notifyListeners();
  }
}

class Example32_Provider_Selector extends StatelessWidget {
  const Example32_Provider_Selector({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Example32_UserModel(),
      child: MaterialApp(
        home: Builder(
          builder: (innerContext) => Scaffold(
            appBar: AppBar(title: const Text('Example32_Provider')),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Selector<Example32_UserModel, String>(
                    selector: (context, model) => model.name,
                    builder: (context, name, _) =>
                        Text('姓名:$name', style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 20),
                  Selector<Example32_UserModel, int>(
                    selector: (context, model) => model.age,
                    builder: (context, age, _) =>
                        Text('年龄:$age', style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => innerContext
                        .read<Example32_UserModel>()
                        .changeName('Flutter Dev'),
                    child: const Text('修改姓名'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () =>
                        innerContext.read<Example32_UserModel>().changAge(30),
                    child: const Text('修改年龄'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterEvent>((event, emit) {
      switch (event) {
        case CounterEvent.increment:
          emit(state + 1);
          break;
        case CounterEvent.decrement:
          emit(state - 1);
          break;
      }
    });
  }
}

class Example33_Bloc extends StatelessWidget {
  const Example33_Bloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: Builder(
        builder: (innerContext) => Scaffold(
          appBar: AppBar(title: const Text('Bloc示例')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<CounterBloc, int>(
                  builder: (context, state) =>
                      Text('计数$state', style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => innerContext.read<CounterBloc>().add(
                        CounterEvent.decrement,
                      ),
                      child: const Text('--'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => innerContext.read<CounterBloc>().add(
                        CounterEvent.increment,
                      ),
                      child: const Text('++'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Example34_AnimatedBuilder extends StatefulWidget {
  const Example34_AnimatedBuilder({super.key});

  @override
  State<Example34_AnimatedBuilder> createState() =>
      _Example34_AnimatedBuilderState();
}

class _Example34_AnimatedBuilderState extends State<Example34_AnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example34_AnimatedBuilder')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Container(
                  width: _animation.value,
                  height: _animation.value,
                  color: Colors.blue,
                  child: child,
                ),
                child: const Center(
                  child: Text('动画容器', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_controller.status == AnimationStatus.completed) {
                    _controller.reverse();
                  } else {
                    _controller.forward();
                  }
                },
                child: const Text('播放,方向动画'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
