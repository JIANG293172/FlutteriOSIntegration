//
//  ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2025/11/5.
//
//xcodebuild -workspace SwiftUI10.xcworkspace -scheme SwiftUI10 -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=18.6' build

import UIKit
// 现有iOS工程的ViewController中
import Flutter

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        openFlutterPage()
    }
    
    func openFlutterPage() {
        // 初始化Flutter引擎
        let flutterEngine = FlutterEngine(name: "MyFlutterEngine")
        
        // 先运行Flutter引擎（非常重要！）
        flutterEngine.run()
        
        // 然后再设置RouterService
        RouterService.shared.setup(with: flutterEngine)
        
        // 注册示例路由处理器
        registerExampleHandlers()
        
        // 打开Flutter页面
        let flutterVC = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterVC.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(flutterVC, animated: true)
    }
    
    // 注册示例路由处理器
    private func registerExampleHandlers() {
        // 示例1: 获取设备信息
        RouterService.shared.registerHandler(route: "getDeviceInfo") { params in
            return [
                "deviceName": UIDevice.current.name,
                "systemName": UIDevice.current.systemName,
                "systemVersion": UIDevice.current.systemVersion,
                "model": UIDevice.current.model
            ]
        }
        
        // 示例2: 保存数据
        RouterService.shared.registerHandler(route: "saveData") { params in
            if let key = params["key"] as? String,
               let value = params["value"] as? String {
                UserDefaults.standard.set(value, forKey: key)
                return ["success": true, "message": "数据保存成功"]
            }
            return ["success": false, "error": "参数错误"]
        }
        
        // 示例3: 获取数据
        RouterService.shared.registerHandler(route: "getData") { params in
            if let key = params["key"] as? String {
                let value = UserDefaults.standard.string(forKey: key)
                return ["success": true, "data": value ?? ""]
            }
            return ["success": false, "error": "参数错误"]
        }
        
        // 注册示例事件处理器
        RouterService.shared.registerEventHandler(event: "userLoggedIn") { data in
            print("收到用户登录事件: \(data)")
            // 处理用户登录逻辑
        }
        
        // 示例4: iOS调用Flutter示例
        // 这里我们添加一个方法来演示iOS如何调用Flutter
        performiOStoFlutterCalls()
    }
    
    // iOS调用Flutter的示例方法
    private func performiOStoFlutterCalls() {
        print("开始执行iOS调用Flutter的示例...")
        
        // 示例1: 调用Flutter的showNotification路由
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            print("=== 调用Flutter的showNotification ===")
            RouterService.shared.invokeFlutter(route: "showNotification", params: [
                "message": "Hello from iOS! 这是一条测试通知"
            ]) { result, error in
                if let error = error {
                    print("调用showNotification失败: \(error)")
                } else {
                    print("调用showNotification成功: \(result ?? "无返回结果")")
                }
            }
        }
        
        // 示例2: 调用Flutter的calculateSum路由
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            print("\n=== 调用Flutter的calculateSum ===")
            RouterService.shared.invokeFlutter(route: "calculateSum", params: [
                "a": 10,
                "b": 20
            ]) { result, error in
                if let error = error {
                    print("调用calculateSum失败: \(error)")
                } else {
                    print("调用calculateSum成功: \(result ?? "无返回结果")")
                }
            }
        }
        
        // 示例3: 调用Flutter的getCurrentTime路由
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            print("\n=== 调用Flutter的getCurrentTime ===")
            RouterService.shared.invokeFlutter(route: "getCurrentTime", params: [:]) { result, error in
                if let error = error {
                    print("调用getCurrentTime失败: \(error)")
                } else {
                    print("调用getCurrentTime成功: \(result ?? "无返回结果")")
                }
            }
        }
    }
    
}
