import 'package:flutter/material.dart';

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
