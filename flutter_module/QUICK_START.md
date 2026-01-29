# 快速开始指南 - MVVM 架构

## 🚀 快速运行

### 第一次运行

```bash
# 进入Flutter模块目录
cd flutter_module

# 获取依赖
flutter pub get

# 构建iOS框架（必须，用于iOS集成）
flutter build ios --release

# 返回iOS项目目录安装Pod
cd ../MyiOSApp
pod install --repo-update

# 在Xcode中打开项目
open SwiftUI10.xcworkspace
```

### VS Code 中运行

1. **按 Ctrl+Shift+D** (Mac: Cmd+Shift+D) 打开运行和调试面板
2. 在顶部下拉菜单选择一个配置：
   - `flutter_module (iOS Simulator - iPhone 16 Pro)` → 模拟器
   - `flutter_module (iOS Physical Device - taojiang)` → 真机
3. **按 F5** 或点击绿色播放按钮

### 命令行运行

```bash
cd flutter_module

# 在模拟器上运行
flutter run -d 13CE82F4-3AE1-453B-94C6-EC3A9A231062

# 在真机上运行
flutter run -d 00008110-0001394A02F9801E
```

## 📂 文件导航

### 最常修改的文件

| 需求 | 文件位置 |
|------|--------|
| 修改UI布局 | `lib/views/pages/car_control_page.dart` |
| 修改数据模型 | `lib/models/*.dart` |
| 修改业务逻辑 | `lib/viewmodels/car_control_viewmodel.dart` |
| 修改单个UI组件 | `lib/views/widgets/*.dart` |
| 修改平台通道 | `lib/services/platform_channel_service.dart` |

## 🎨 添加新功能（示例）

### 场景：添加车灯控制功能

#### 步骤 1：在 Model 中添加字段

**文件：** `lib/models/status_model.dart`

```dart
class StatusModel {
  // ... 其他字段
  final bool lightsOn;  // ← 新增
  
  StatusModel({
    // ... 其他参数
    required this.lightsOn,
  });
  
  factory StatusModel.initial() {
    return StatusModel(
      // ...
      lightsOn: false,
    );
  }
  
  StatusModel copyWith({
    // ...
    bool? lightsOn,
  }) {
    return StatusModel(
      // ...
      lightsOn: lightsOn ?? this.lightsOn,
    );
  }
}
```

#### 步骤 2：在 ViewModel 中添加方法

**文件：** `lib/viewmodels/car_control_viewmodel.dart`

```dart
/// 切换灯光
void toggleLights() {
  // 获取当前状态
  final currentLightsOn = _statusModel.lightsOn;
  
  // 更新Model
  _statusModel = _statusModel.copyWith(
    lightsOn: !currentLightsOn,
  );
  
  // 通知UI重建
  notifyListeners();
}
```

#### 步骤 3：在 View 中使用

**文件：** `lib/views/pages/car_control_page.dart`

```dart
QuickActionsGrid(
  onLights: viewModel.toggleLights,  // ← 绑定方法
  // ... 其他回调
)
```

#### 步骤 4：完成！✅

现在点击"灯光"按钮会调用 `toggleLights()` 方法。

## 🔧 常见操作

### 查看当前所有设备

```bash
flutter devices
```

### 清理构建缓存

```bash
flutter clean
flutter pub get
```

### 运行 Lint 检查

```bash
flutter analyze
```

### 查看项目依赖

```bash
flutter pub deps
```

### 更新依赖

```bash
flutter pub upgrade
```

## 🐛 调试技巧

### 启用Debug信息

```bash
flutter run -v  # 详细日志
```

### 使用Hot Reload

- **Mac:** Ctrl+S 或 Cmd+S
- **Windows/Linux:** Ctrl+S

### 使用Hot Restart

- **Mac:** Ctrl+Shift+R 或 Cmd+Shift+R
- **Windows/Linux:** Ctrl+Shift+R

### 查看Widget树

```dart
// 在任何Widget中添加
debugPrintBeginFrameBanner = true;
debugPrintEndFrameBanner = true;
```

## 📊 架构速查表

```
┌─────────────────────────────────┐
│         View (UI 显示)           │
│  - CarControlPage               │
│  - 各种 Widget                  │
└────────────────┬────────────────┘
                 │ (数据+回调)
                 ↓
┌─────────────────────────────────┐
│   ViewModel (业务逻辑)           │
│  - CarControlViewModel          │
│  - 管理 Model                   │
│  - 提供方法                     │
└────────────────┬────────────────┘
                 │ (读/写)
                 ↓
┌─────────────────────────────────┐
│      Model (数据)                │
│  - CarModel                     │
│  - StatusModel                  │
└─────────────────────────────────┘
```

## 🎯 修改检查清单

- [ ] 是否涉及UI？→ 修改 `views/` 下的文件
- [ ] 是否涉及数据？→ 修改 `models/` 下的文件
- [ ] 是否涉及业务逻辑？→ 修改 `viewmodels/` 下的文件
- [ ] 是否需要与iOS通信？→ 修改 `services/platform_channel_service.dart`
- [ ] 是否通过 `notifyListeners()` 通知UI？→ ✅ 必须
- [ ] 是否运行 `flutter analyze` 检查？→ ✅ 必须

## 📚 文档

- [MVVM 架构完整说明](./lib/MVVM_ARCHITECTURE.md)
- [改造总结](./REFACTOR_SUMMARY.md)
- [本文件](./QUICK_START.md)

## 💪 下一步

1. 尝试添加新功能（参考上面的示例）
2. 实现ViewModel中的TODO方法
3. 添加单元测试
4. 参考官方文档：https://flutter.dev/docs

---

**提示：** 遇到问题？运行 `flutter doctor` 检查环境配置
