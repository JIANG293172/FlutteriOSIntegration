//
//  ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

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
        
        // 设置RouterService
        RouterService.shared.setup(with: flutterEngine)
        
        // 注册示例路由处理器
        registerExampleHandlers()
        
        flutterEngine.run()
        
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
    }
    
}
