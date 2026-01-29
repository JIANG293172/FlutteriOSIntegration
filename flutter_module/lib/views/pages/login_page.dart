import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../services/qy_network_manager.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 表单控制器
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _imageCodeController = TextEditingController();
  final _smsCodeController = TextEditingController();

  // 状态
  bool _isLoading = false;
  bool _isGettingCode = false;
  int _countdown = 0;
  String _graphicsKey = '';
  String _imageCodeUrl = ''; // 图形验证码图片URL
  String _message = '';

  // 倒计时定时器
  late Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    // 初始化时获取图形验证码
    _requestImageCode();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _imageCodeController.dispose();
    _smsCodeController.dispose();
    _cancelCountdownTimer();
    super.dispose();
  }

  /// 获取图形验证码
  void _requestImageCode() {
    setState(() {
      _isLoading = true;
    });

    // 构建请求参数
    var phone = _phoneController.text;
    var param = {"phone": strToECB(phone)};

    // 构建请求
    var request = QYAPIRequest("/user/getGraphics");

    // 发送请求
    QYNetworkManager.shared
        .request(request, params: param)
        .then((response) {
          setState(() {
            _isLoading = false;
          });

          if (response.success && response.data != null) {
            if (response.data is Map<String, dynamic>) {
              var data = response.data as Map<String, dynamic>;
              _graphicsKey = data["graphicsKey"] as String? ?? "";
              var imageStr = data["graphicsValue"] as String? ?? "";
              if (imageStr.isNotEmpty) {
                // 将Base64字符串转换为图片URL
                _imageCodeUrl = "data:image/png;base64,$imageStr";
              }
            }
          } else {
            setState(() {
              _message = response.message;
            });
          }
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
            _message = "网络异常，请稍后再试";
          });
        });
  }

  /// 获取短信验证码
  void _getSmsCode() {
    // 验证手机号
    final phone = _phoneController.text;
    if (phone.length != 11) {
      setState(() {
        _message = '请输入正确的手机号';
      });
      return;
    }

    // 验证图形验证码
    final imageCode = _imageCodeController.text;
    if (imageCode.isEmpty) {
      setState(() {
        _message = '请输入图形验证码';
      });
      return;
    }

    if (_isGettingCode) {
      setState(() {
        _message = '正在获取验证码请等等';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 构建请求参数
    var param = {
      "phone": strToECB(phone),
      "channel": "ios-app登陆",
      "graphicsKey": _graphicsKey,
      "imgCode": imageCode,
      "isApp": 1,
    };

    // 构建请求
    var request = QYAPIRequest("/user/getDynamicPass");

    // 发送请求
    QYNetworkManager.shared
        .request(request, params: param)
        .then((response) {
          setState(() {
            _isLoading = false;
            _message = response.message;
          });

          if (response.success) {
            // 开始倒计时
            setState(() {
              _isGettingCode = true;
            });
            _startCountdown();
          } else {
            // 重新获取图形验证码
            _requestImageCode();
          }
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
            _message = "网络异常，请稍后再试";
          });
        });
  }

  /// 开始倒计时
  void _startCountdown() {
    setState(() {
      _countdown = 60;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _isGettingCode = false;
          _cancelCountdownTimer();
        }
      });
    });
  }

  /// 取消倒计时定时器
  void _cancelCountdownTimer() {
    if (_countdownTimer.isActive) {
      _countdownTimer.cancel();
    }
  }

  /// 处理登录
  void _handleLogin() {
    // 验证手机号
    final phone = _phoneController.text;
    if (phone.length != 11) {
      setState(() {
        _message = '手机号不合法';
      });
      return;
    }

    // 验证短信验证码
    final smsCode = _smsCodeController.text;
    if (smsCode.isEmpty) {
      setState(() {
        _message = '请输入验证码';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 构建请求参数
    var param = {
      "phone": strToECB(phone),
      "dynamicPassword": smsCode,
      "rid": "", // 实际项目中应该从设备信息中获取
      "lastProvince": "",
      "lastCity": "",
      "graphicsKey": _graphicsKey,
      "isApp": 1,
      "imgCode": _imageCodeController.text,
    };

    // 构建请求
    var request = QYAPIRequest("/user/login");

    // 发送请求
    QYNetworkManager.shared
        .request(request, params: param)
        .then((response) {
          setState(() {
            _isLoading = false;
          });

          if (response.success && response.data != null) {
            if (response.data is Map<String, dynamic>) {
              var data = response.data as Map<String, dynamic>;
              var token = data["token"] as String? ?? "";
              if (token.isNotEmpty) {
                // 保存token
                QYApiConfig.shared.logIn(token);

                // 登录成功，返回上一页
                Navigator.pop(context, {'phone': phone, 'success': true});
                return;
              }
            }
          }

          // 登录失败
          setState(() {
            _message = response.message ?? '登录失败';
          });
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
            _message = "网络异常，请稍后再试";
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('用户登录'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 标题
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    '欢迎登录',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 错误信息
                if (_message.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      _message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // 手机号输入框
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: '手机号',
                    hintText: '请输入11位手机号',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入手机号';
                    }
                    if (value.length != 11) {
                      return '请输入正确的手机号';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 图形验证码
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _imageCodeController,
                        decoration: const InputDecoration(
                          labelText: '图形验证码',
                          hintText: '请输入图形验证码',
                          prefixIcon: Icon(Icons.image),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入图形验证码';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 图形验证码图片
                    GestureDetector(
                      onTap: _requestImageCode,
                      child: Container(
                        width: 100,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _imageCodeUrl.isNotEmpty
                            ? Image.network(_imageCodeUrl, fit: BoxFit.cover)
                            : const Center(child: Text('获取验证码')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 短信验证码
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _smsCodeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '短信验证码',
                          hintText: '请输入短信验证码',
                          prefixIcon: Icon(Icons.sms),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入短信验证码';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 获取验证码按钮
                    ElevatedButton(
                      onPressed: _isGettingCode ? null : _getSmsCode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      child: Text(
                        _countdown > 0 ? '${_countdown}s后获取' : '获取验证码',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 登录按钮
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('登录'),
                ),
                const SizedBox(height: 20),

                // 注册链接
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('还没有账号？'),
                    TextButton(
                      onPressed: () {
                        // 这里可以跳转到注册页面
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('注册功能开发中')),
                        );
                      },
                      child: const Text('立即注册'),
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

/// AES-ECB加密
String strToECB(String text) {
  if (text.isEmpty) return "";
  // 实际项目中应该实现AES-ECB加密
  // 这里只是返回Base64编码的字符串作为示例
  var bytes = utf8.encode(text);
  return base64.encode(bytes);
}
