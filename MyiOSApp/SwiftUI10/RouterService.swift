import Foundation
import Flutter

/// 通用路由服务 - 处理iOS与Flutter的通信
class RouterService {
    static let shared = RouterService()
    private let channelName = "com.changan.router/channel"
    private var methodChannel: FlutterMethodChannel?
    private var flutterEngine: FlutterEngine?
    private var handlers: [String: (Dictionary<String, Any>) -> Any] = [:]
    private var eventHandlers: [String: (Any) -> Void] = [:]

    /// 初始化路由服务
    /// - Parameter engine: Flutter引擎实例
    func setup(with engine: FlutterEngine) {
        self.flutterEngine = engine
        self.methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: engine.binaryMessenger)
        self.methodChannel?.setMethodCallHandler(handleMethodCall)
        print("RouterService setup completed")
    }

    /// 注册路由处理器
    /// - Parameters:
    ///   - route: 路由名称
    ///   - handler: 处理函数，接收参数并返回结果
    func registerHandler(route: String, handler: @escaping (Dictionary<String, Any>) -> Any) {
        handlers[route] = handler
        print("RouterService registered handler for route: \(route)")
    }
5
    /// 注册事件处理器
    /// - Parameters:
    ///   - event: 事件名称
    ///   - handler: 处理函数，接收事件数据
    func registerEventHandler(event: String, handler: @escaping (Any) -> Void) {
        eventHandlers[event] = handler
        print("RouterService registered event handler for event: \(event)")
    }

    /// 调用Flutter方法
    /// - Parameters:
    ///   - route: 路由名称
    ///   - params: 参数字典
    ///   - completion: 完成回调，返回结果或错误
    func invokeFlutter(route: String, params: Dictionary<String, Any> = [:], completion: @escaping (Any?, Error?) -> Void) {
        guard let methodChannel = methodChannel else {
            completion(nil, NSError(domain: "RouterService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Method channel not initialized"]))
            return
        }

        let request: [String: Any] = [
            "route": route,
            "params": params
        ]

        methodChannel.invokeMethod("invokeFlutter", arguments: request) { result, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(result, nil)
            }
        }
    }

    /// 处理Flutter调用
    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "invoke":
            handleInvoke(call: call, result: result)
        case "sendEvent":
            handleSendEvent(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// 处理Flutter调用原生方法
    private func handleInvoke(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let route = args["route"] as? String,
              let params = args["params"] as? Dictionary<String, Any> else {
            result([
                "success": false,
                "error": "Invalid arguments"
            ])
            return
        }

        if let handler = handlers[route] {
            do {
                let response = handler(params)
                result([
                    "success": true,
                    "data": response
                ])
            } catch {
                result([
                    "success": false,
                    "error": error.localizedDescription
                ])
            }
        } else {
            result([
                "success": false,
                "error": "Route not registered: \(route)"
            ])
        }
    }

    /// 处理Flutter发送事件
    private func handleSendEvent(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let event = args["event"] as? String,
              let data = args["data"] else {
            result(false)
            return
        }

        if let handler = eventHandlers[event] {
            handler(data)
            result(true)
        } else {
            print("RouterService: Event handler not found for event: \(event)")
            result(false)
        }
    }

    /// 发送事件到Flutter
    /// - Parameters:
    ///   - event: 事件名称
    ///   - data: 事件数据
    func sendEvent(event: String, data: Any) {
        guard let methodChannel = methodChannel else {
            print("RouterService: Method channel not initialized")
            return
        }

        let eventData: [String: Any] = [
            "event": event,
            "data": data
        ]

        methodChannel.invokeMethod("onEvent", arguments: eventData) { result, error in
            if let error = error {
                print("RouterService: Failed to send event: \(error)")
            }
        }
    }
}
