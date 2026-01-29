# Copilot Instructions for FlutteriOSIntegration

## Project Overview

This is a **Flutter-to-iOS add-to-app integration** project with **MVVM architecture**, embedding a Flutter module into an existing native iOS app (SwiftUI). Features car control UI with platform channel communication between Flutter and native iOS.

**Structure:**
- `flutter_module/`: MVVM-organized Flutter module (Models → ViewModels → Views)
- `MyiOSApp/`: Native iOS SwiftUI app hosting the Flutter module via method channels

## Critical Architecture: MVVM Pattern

The Flutter module follows strict **MVVM separation**:

### Data Flow
```
View (Stateless Widgets) ←→ ViewModel (Business Logic) ←→ Models (Data)
     ↓ (Consumer)              ↓ (notifyListeners)         ↓ (copyWith)
   CarControlPage        CarControlViewModel       CarModel, StatusModel
```

### Key Directories & Responsibilities
- **`models/`** - Immutable data classes with `copyWith()`, `fromJson()`, `toJson()`
  - [CarModel](../flutter_module/lib/models/car_model.dart): Vehicle data (battery, range, lock status)
  - [StatusModel](../flutter_module/lib/models/status_model.dart): Feature states (climate, seats, security)
  
- **`viewmodels/`** - Single [CarControlViewModel](../flutter_module/lib/viewmodels/car_control_viewmodel.dart) managing all business logic
  - Extends `ChangeNotifier` for reactive updates
  - Initializes models and sets up platform channel handlers
  - Methods named after actions: `toggleClimateAuto()`, `updateTargetTemperature()`, `lockCar()`
  
- **`views/pages/`** - [CarControlPage](../flutter_module/lib/views/pages/car_control_page.dart) uses `Consumer<CarControlViewModel>` to reactively display state
  
- **`views/widgets/`** - 8 reusable stateless widgets (HeaderCard, ClimateCard, SeatCard, etc.) accepting callbacks & model data as parameters

**Key Convention:** All state mutations happen in ViewModel; Views never modify models directly.

## Platform Channel Integration (iOS ↔ Flutter)

**Channel Name:** `com.changan.carcontrol/channel`  
**Handler Location:** [PlatformChannelService](../flutter_module/lib/services/platform_channel_service.dart)

**Flow:**
```
iOS ViewController → invokes "updateBattery" → PlatformChannelService
  → calls CarControlViewModel._updateBattery()
  → updates CarModel via copyWith()
  → notifyListeners() → UI rebuilds
```

**Setup in iOS:**
1. [ViewController.swift](../MyiOSApp/SwiftUI10/ViewController.swift): Creates `FlutterEngine` and `FlutterViewController`
2. [Podfile](../MyiOSApp/Podfile): Loads Flutter pods via `flutter_install_all_ios_pods`

## Development Workflows

### First-Time Setup
```bash
cd flutter_module && flutter pub get && flutter build ios --release
cd ../MyiOSApp && pod install --repo-update
open SwiftUI10.xcworkspace  # Always .xcworkspace, never .xcodeproj
```

### Adding Features (3-Step MVVM Pattern)

**Example: Add new "lights" toggle**

1. **Model** - Add field to [StatusModel](../flutter_module/lib/models/status_model.dart):
   ```dart
   final bool lightsOn;
   
   StatusModel copyWith({bool? lightsOn}) {
     return StatusModel(..., lightsOn: lightsOn ?? this.lightsOn);
   }
   ```

2. **ViewModel** - Add method to [CarControlViewModel](../flutter_module/lib/viewmodels/car_control_viewmodel.dart):
   ```dart
   void toggleLights() {
     _statusModel = _statusModel.copyWith(lightsOn: !_statusModel.lightsOn);
     notifyListeners();
   }
   ```

3. **View** - Use in [CarControlPage](../flutter_module/lib/views/pages/car_control_page.dart) widget callbacks.

### Pod Dependency Management
```bash
# After adding Flutter packages
cd flutter_module && flutter pub add package_name
cd ../MyiOSApp && pod install
```

## Critical Conventions & Gotchas

| Issue | Solution |
|-------|----------|
| Pods won't resolve in Xcode | Always open `.xcworkspace`, not `.xcodeproj` |
| Platform channel method not recognized | Ensure `case "methodName"` matches iOS invoke exactly; throw `PlatformException` for unknown methods |
| State not updating in UI | ViewModel method must call `notifyListeners()` after model update |
| Widget doesn't receive updated data | Ensure widget is wrapped in `Consumer<CarControlViewModel>` |
| Model field changes not detected | Use `copyWith()` to create new instance; direct field mutation won't trigger UI rebuild |

## File Reference Quick Guide

| File | When to Edit |
|------|-------------|
| [CarControlViewModel](../flutter_module/lib/viewmodels/car_control_viewmodel.dart) | Adding new features, business logic |
| [CarModel](../flutter_module/lib/models/car_model.dart), [StatusModel](../flutter_module/lib/models/status_model.dart) | New data fields |
| [CarControlPage](../flutter_module/lib/views/pages/car_control_page.dart) | Changing UI layout, adding widgets |
| [views/widgets/*.dart](../flutter_module/lib/views/widgets/) | Styling, UI component logic |
| [PlatformChannelService](../flutter_module/lib/services/platform_channel_service.dart) | New iOS ↔ Flutter methods |
| [Podfile](../MyiOSApp/Podfile) | Adding native iOS dependencies |
| [ViewController.swift](../MyiOSApp/SwiftUI10/ViewController.swift) | Flutter engine initialization issues |

## Documentation for Reference

- [QUICK_START.md](../flutter_module/QUICK_START.md) - Setup & running guide
- [README_MVVM.md](../flutter_module/README_MVVM.md) - MVVM architecture details
- [MVVM_ARCHITECTURE.md](../flutter_module/lib/MVVM_ARCHITECTURE.md) - Design decisions
