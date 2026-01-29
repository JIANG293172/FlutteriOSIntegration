# MVVM 架构重构说明

本项目已按 **MVVM (Model-View-ViewModel)** 架构完全重构，将原本单个 `main.dart` 文件中的所有类分拆到不同的模块中。

## 📁 项目结构

```
lib/
├── main.dart                          # 应用入口
├── models/
│   ├── car_model.dart                # 车辆数据模型
│   └── status_model.dart             # 车辆功能状态模型
├── viewmodels/
│   └── car_control_viewmodel.dart    # 车控业务逻辑（MVVM核心）
├── views/
│   ├── pages/
│   │   ├── module_home_page.dart     # 模块首页（ViewModel初始化）
│   │   └── car_control_page.dart     # 车控主页面
│   ├── widgets/
│   │   ├── header_card.dart
│   │   ├── car_image_card.dart
│   │   ├── status_row.dart
│   │   ├── quick_actions_grid.dart
│   │   ├── climate_card.dart
│   │   ├── seat_card.dart
│   │   ├── security_card.dart
│   │   └── charge_card.dart
│   └── shared/                       # 共享Widget
│       ├── section_title.dart
│       ├── status_item.dart
│       ├── action_item.dart
│       ├── pill_button.dart
│       ├── seat_level.dart
│       ├── security_row.dart
│       └── charge_tile.dart
└── services/
    └── platform_channel_service.dart # iOS平台通道服务
```

## 🏗️ MVVM 架构说明

### Model（模型层）
**位置：** `lib/models/`

- **CarModel** - 车辆基础数据
  - 电量、续航、车状、锁车状态等
  - 提供 `copyWith()` 方法支持不可变数据模式

- **StatusModel** - 车辆功能状态
  - 空调、座椅、安全、充电等状态
  - 提供 `initial()` 工厂方法初始化默认状态

### ViewModel（视图模型层）
**位置：** `lib/viewmodels/car_control_viewmodel.dart`

业务逻辑核心，继承 `ChangeNotifier`：
```dart
class CarControlViewModel extends ChangeNotifier {
  // 管理 Model 数据
  late CarModel _carModel;
  late StatusModel _statusModel;
  
  // 提供UI可访问的Getter
  CarModel get carModel => _carModel;
  StatusModel get statusModel => _statusModel;
  
  // 业务方法
  void updateTargetTemperature(double temp) { ... }
  void toggleSeatHeating() { ... }
  void unlockCar() { ... }
}
```

**职责：**
- ✅ 管理Model数据
- ✅ 实现业务逻辑
- ✅ 初始化平台通道服务
- ✅ 数据变化时调用 `notifyListeners()` 更新UI

### View（视图层）
**位置：** `lib/views/`

#### Pages（页面）
- **ModuleHomePage** - 初始化ViewModel并使用Provider
- **CarControlPage** - 主页面UI，通过Consumer监听ViewModel

#### Widgets（组件）
所有UI组件接收数据和回调，不持有状态：

```dart
// 示例：ClimateCard
class ClimateCard extends StatelessWidget {
  final double targetTemperature;
  final bool climateAuto;
  final ValueChanged<double>? onTemperatureChanged;
  final VoidCallback? onAutoPressed;
  
  @override
  Widget build(BuildContext context) {
    // 纯UI，数据从参数获取，交互通过回调传递
  }
}
```

#### Shared（共享组件）
可复用的小组件，如 `PillButton`、`StatusItem` 等

### Service（服务层）
**位置：** `lib/services/platform_channel_service.dart`

处理与原生iOS的通信：
- 初始化方法通道处理程序
- 提供方法调用接口

## 🔄 数据流

```
User Action
    ↓
View Widget 触发回调
    ↓
ViewModel 业务方法
    ↓
修改 Model 数据
    ↓
notifyListeners() 通知
    ↓
Consumer 重建 UI
    ↓
View 展示最新数据
```

## 📦 依赖

新增依赖：
```yaml
dependencies:
  provider: ^6.4.0  # MVVM状态管理
```

## 🚀 使用示例

### 在ViewModel中更新数据

```dart
// 服务类中的方法
void updateTargetTemperature(double temperature) {
  _statusModel = _statusModel.copyWith(targetTemperature: temperature);
  notifyListeners(); // 通知UI更新
}
```

### 在View中监听数据

```dart
Consumer<CarControlViewModel>(
  builder: (context, viewModel, _) {
    return ClimateCard(
      targetTemperature: viewModel.statusModel.targetTemperature,
      onTemperatureChanged: viewModel.updateTargetTemperature,
    );
  },
)
```

## ✨ 优势

- **关注点分离** - Model、ViewModel、View各司其职
- **可维护性** - 代码结构清晰，易于理解和修改
- **可测试性** - ViewModel可独立单元测试，无需UI框架
- **可复用性** - 组件无状态，可跨项目复用
- **扩展性** - 新增功能只需修改ViewModel和对应Widget

## 🔧 添加新功能

### 1. 在Model中定义数据
```dart
// 在 StatusModel 中添加字段
class StatusModel {
  final bool newFeature;
  // ...
}
```

### 2. 在ViewModel中实现逻辑
```dart
void toggleNewFeature() {
  _statusModel = _statusModel.copyWith(newFeature: !_statusModel.newFeature);
  notifyListeners();
}
```

### 3. 在View中使用
```dart
Consumer<CarControlViewModel>(
  builder: (context, viewModel, _) {
    return SomeWidget(
      onPressed: viewModel.toggleNewFeature,
    );
  },
)
```

## 📝 下一步

- 添加更多ViewModel方法实现具体功能（如解锁车、启动空调等）
- 集成与iOS的通信逻辑
- 添加单元测试
- 考虑添加错误处理和日志记录
