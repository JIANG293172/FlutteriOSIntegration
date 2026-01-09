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
        flutterEngine.run()
        // 打开Flutter页面
        let flutterVC = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterVC.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(flutterVC, animated: true)
    }
    
}
