# Copilot Instructions for FlutteriOSIntegration

## Project Overview

This is a **Flutter-to-iOS add-to-app integration** project, embedding a Flutter module into an existing native iOS app (SwiftUI). The project demonstrates platform channel communication for car control features.

**Key Structure:**
- `flutter_module/`: Standalone Flutter module with car control UI and method channel handlers
- `MyiOSApp/`: Native iOS SwiftUI app that hosts the Flutter module

## Architecture & Integration Pattern

### Flutter Module Integration
The Flutter module is embedded in native iOS via **method channels** (Platform Channel pattern):

- **Channel Name:** `com.changan.carcontrol/channel`
- **Location:** [flutter_module/lib/main.dart](../flutter_module/lib/main.dart#L22) - `ModuleHomePage` class
- **Protocol:** iOS calls `updateBattery` → Flutter receives and updates state

### iOS Integration
[MyiOSApp/SwiftUI10/ViewController.swift](../MyiOSApp/SwiftUI10/ViewController.swift) demonstrates the integration:
1. Create `FlutterEngine` instance with a unique name ("MyFlutterEngine")
2. Run the engine and initialize `FlutterViewController`
3. Push the Flutter view controller onto the navigation stack

**Critical Setup:**
- [Podfile](../MyiOSApp/Podfile) must load Flutter module dependencies via `flutter_install_all_ios_pods`
- Use `use_frameworks!` in Podfile (required for Flutter integration)
- Flutter module path is relative: `'../flutter_module'`

## Key Components & Conventions

### Flutter Widget Structure ([main.dart](../flutter_module/lib/main.dart))
The UI is organized hierarchically with private widget classes for sections:
- `CarControlPage` - Main stateless widget with ListView layout
- `_HeaderCard`, `_CarImageCard`, `_StatusRow` - Private header components
- `_QuickActionsGrid`, `_ClimateCard`, `_SeatCard`, `_SecurityCard`, `_ChargeCard` - Feature sections
- `_SectionTitle` - Shared reusable title widget

**Pattern:** Stateless widgets for UI structure; state managed through MethodChannel callbacks.

### Method Channel Handler
Located in `ModuleHomePage.setMethodCallHandler()`:
```dart
_channel.setMethodCallHandler((call) async {
  switch (call.method) {
    case "updateBattery":
      final int battery = call.arguments['battery'] as int;
      return "电量已更新为：$battery%";
    default:
      throw PlatformException(code: "METHOD_NOT_FOUND", message: "方法未实现");
  }
});
```
**Convention:** Handle platform calls with type-safe argument casting; throw `PlatformException` for unknown methods.

## Development Workflows

### Building the Flutter Module
```bash
cd flutter_module
flutter pub get
flutter build ios --release  # Builds framework for iOS integration
```

### Building the iOS App
```bash
cd MyiOSApp
pod install  # Essential - fetches Flutter pods and integrates module
open SwiftUI10.xcworkspace  # Always use .xcworkspace, not .xcodeproj
```

### Adding Flutter Dependencies
When adding packages to the Flutter module, you must rebuild iOS pods:
```bash
cd flutter_module && flutter pub add package_name
cd ../MyiOSApp && pod install
```

## Important Conventions & Gotchas

1. **Always use `.xcworkspace`** in Xcode, not `.xcodeproj` - pods won't resolve correctly otherwise
2. **Relative path in Podfile:** Flutter module path is `../flutter_module` from Podfile location
3. **Method Channel naming:** Use reverse domain format (`com.changan.carcontrol/channel`) for clarity
4. **Type safety:** Always cast method channel arguments explicitly and throw exceptions for missing methods
5. **Widget naming:** Private internal widgets use leading underscore (`_WidgetName`); public widgets capitalize normally
6. **Chinese text:** UI includes Chinese labels (电量 = battery, 充电 = charging) - localization not yet implemented

## File Reference Guide

| File | Purpose |
|------|---------|
| [flutter_module/pubspec.yaml](../flutter_module/pubspec.yaml) | Flutter dependencies & metadata |
| [flutter_module/lib/main.dart](../flutter_module/lib/main.dart) | Flutter UI & platform channel implementation |
| [MyiOSApp/SwiftUI10/ViewController.swift](../MyiOSApp/SwiftUI10/ViewController.swift) | iOS entry point; Flutter engine initialization |
| [MyiOSApp/Podfile](../MyiOSApp/Podfile) | iOS dependency management & Flutter pod integration |
| [MyiOSApp/SwiftUI10/AppDelegate.swift](../MyiOSApp/SwiftUI10/AppDelegate.swift) | App lifecycle (basic template, minimal setup) |

## Common Tasks for AI Agents

- **Modifying Flutter UI:** Edit [main.dart](../flutter_module/lib/main.dart) widget classes directly
- **Adding new methods:** Add case to `setMethodCallHandler()` in `ModuleHomePage`
- **Testing platform integration:** Use method channels from iOS to trigger Flutter state updates
- **Pod dependency issues:** Run `pod install --repo-update` in MyiOSApp directory
