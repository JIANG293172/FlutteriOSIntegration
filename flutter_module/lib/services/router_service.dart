import 'package:flutter/services.dart';

/// 通用路由服务 - 处理Flutter与原生平台的通信
class RouterService {
  static const String _channelName = 'com.changan.router/channel';
  static final MethodChannel _channel = MethodChannel(_channelName);
  static final Map<String, Function(Map<String, dynamic> params)> _handlers = {};

  /// 初始化路由服务
  static void initialize() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  /// 注册路由处理器
  /// [route] 路由名称
  /// [handler] 处理函数，接收参数并返回结果
  static void registerHandler(String route, Function(Map<String, dynamic> params) handler) {
    _handlers[route] = handler;
  }

  /// 调用原生方法
  /// [route] 路由名称
  /// [params] 参数字典
  /// [timeout] 超时时间（毫秒），默认30秒
  static Future<dynamic> invoke(String route, [Map<String, dynamic>? params, int timeout = 30000]) async {
    try {
      final Map<String, dynamic> request = {
        'route': route,
        'params': params ?? {},
      };

      final result = await _channel.invokeMethod('invoke', request).timeout(
        Duration(milliseconds: timeout),
        onTimeout: () => throw TimeoutException('调用超时'),
      );

      return result;
    } catch (e) {
      print('RouterService.invoke error: $e');
      rethrow;
    }
  }

  /// 处理原生调用Flutter的方法
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      if (call.method == 'invokeFlutter') {
        final Map<String, dynamic> args = call.arguments;
        final String route = args['route'];
        final Map<String, dynamic> params = args['params'] ?? {};

        if (_handlers.containsKey(route)) {
          final result = await _handlers[route]!(params);
          return {
            'success': true,
            'data': result,
          };
        } else {
          return {
            'success': false,
            'error': '路由未注册: $route',
          };
        }
      } else {
        throw PlatformException(
          code: 'METHOD_NOT_FOUND',
          message: '方法未实现: ${call.method}',
        );
      }
    } catch (e) {
      print('RouterService._handleMethodCall error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// 发送事件到原生
  /// [event] 事件名称
  /// [data] 事件数据
  static Future<void> sendEvent(String event, [dynamic data]) async {
    try {
      final Map<String, dynamic> eventData = {
        'event': event,
        'data': data,
      };
      await _channel.invokeMethod('sendEvent', eventData);
    } catch (e) {
      print('RouterService.sendEvent error: $e');
    }
  }
}

/// 超时异常
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}
