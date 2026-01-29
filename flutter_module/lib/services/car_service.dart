import 'package:flutter/material.dart';
import 'qy_network_manager.dart';

class CarService {
  static final CarService _instance = CarService._private();
  factory CarService() => _instance;
  CarService._private();

  /// 按品牌代码获取车辆列表
  Future<void> fetchCarsByBrandCode({
    required Function(dynamic) onSuccess,
    required Function(String) onFailure,
  }) async {
    print('--- 开始发起车辆列表请求 ---');

    // 1. 构建请求对象
    var request = QYAPIRequest("/app2/api/v2/user/cars-by-brand-code");
    // 设置特定的 Host
    request.instanceHost = "https://pre-m.iov.changan.com.cn";

    // 2. 准备业务参数
    var params = {
      "brandCode": "OX",
      "token": "rH81PymvQOQPR78ZaCag5qFD8M1sulio",
      "type": "0",
    };

    // 3. 发起请求
    try {
      var response = await QYNetworkManager.shared.request(request, params: params);
      if (response.success) {
        print('车辆列表请求成功: ${response.originalData}');
        onSuccess(response.data);
      } else {
        print('车辆列表请求失败: ${response.message}');
        onFailure(response.message);
      }
    } catch (error) {
      print('车辆列表请求异常: $error');
      onFailure('网络异常: $error');
    }
  }
}
