# Phase 3 Implementation Plan - Overlay Support

## 🎯 Current Phase: Phase 3 - Overlay Support

### Architecture Blueprint Requirements

**Goal**: Enable inspection of Flutter overlays (dialogs, bottom sheets, dropdowns, etc.)

**Challenge**: Flutter overlays exist outside normal widget subtrees

**Required Overlays to Support**:
- Dialog
- BottomSheet
- Dropdown
- Tooltip
- PopupMenu
- OverlayEntry
- OverlayPortal
- Nested overlays

---

## 🏗️ Phase 3 Architecture

### Core Challenge: Flutter Overlay Problem

**The Issue**: Overlays in Flutter are rendered outside the normal widget tree:

```dart
MaterialApp(
  home: MyWidget(), // ✅ Normal widget tree
)

// Dialog (❌ Outside normal tree)
showDialog(
  context: context,
  builder: (context) => AlertDialog(),
)
```

**The Solution**: Track overlays through special observers and capture mechanisms

---

### Required Systems

**1. Overlay Registry**
- Track active overlay instances
- Manage overlay lifecycle
- Provide overlay metadata
- Support nested overlays

**2. Route Observer**
- Monitor navigation events
- Detect route changes
- Track modal routes
- Identify overlay transitions

**3. Overlay Capture**
- Special capture for overlay render objects
- Safe access to overlay content
- Handle different overlay types
- Manage overlay states

**4. Overlay Regions**
- Widgets that mark overlay boundaries
- Provide overlay context
- Enable overlay identification
- Support overlay inspection

**5. Enhanced Inspector**
- Overlay-aware rendering
- Different visual styles for overlays
- Overlay selection and measurement
- Overlay relationship visualization

---

## 📋 Implementation Strategy

### Step 1: Overlay Foundation (Current Priority)

**Create Overlay Registry**:
```dart
packages/gapscope/lib/src/overlay/
├── overlay_registry.dart          # Central overlay tracker
├── overlay_info.dart              # Overlay metadata
└── overlay_type.dart              # Overlay type enumeration
```

**Create Route Observer**:
```dart
packages/gapscope/lib/src/overlay/
└── gapscope_route_observer.dart   # Navigation tracking
```

### Step 2: Capture System Enhancement

**Enhance Capture for Overlays**:
```dart
packages/gapscope/lib/src/overlay/
└── overlay_capture.dart            # Overlay-specific capture
```

### Step 3: Overlay Region Widgets

**Create Overlay Marking Widgets**:
```dart
packages/gapscope/lib/src/overlay/
├── gapscope_overlay_region.dart    # User-facing widget
├── gapscope_overlay_host.dart      # Internal overlay host
└── overlay_capture.dart           # Capture integration
```

### Step 4: Inspector Enhancement

**Extend Inspector for Overlays**:
- Add overlay mode to GapScopeMode enum
- Enhance inspector painter for overlays
- Update inspector controller
- Integrate with overlay registry

### Step 5: Testing & Examples

**Create Overlay Examples**:
- Dialog examples
- BottomSheet examples
- Dropdown examples
- Nested overlay examples

---

## 🎨 Technical Architecture

### Overlay Type System

```dart
enum OverlayType {
  dialog,
  bottomSheet,
  dropdown,
  tooltip,
  popupMenu,
  overlayEntry,
  overlayPortal,
  other,
}
```

### Overlay Information Model

```dart
class OverlayInfo {
  final String id;
  final OverlayType type;
  final String routeName;
  final Rect bounds;
  final bool isVisible;
  final String? parentOverlayId;
  final DateTime createdAt;
}
```

### Overlay Registry Design

**Central tracking system**:
- Singleton pattern for global access
- Thread-safe overlay registration
- Lifecycle management
- Event notification system

### Route Observer Integration

**Navigation tracking**:
- Monitor route pushes/pops
- Detect modal routes
- Track overlay transitions
- Identify dialog/bottom sheet routes

---

## 🔧 Detailed Implementation Plan

### 1. Overlay Type System

**Purpose**: Categorize different overlay types

**Features**:
- Type enumeration for all Flutter overlays
- Type detection heuristics
- Type-specific rendering styles
- Parent-child relationship tracking

### 2. Overlay Registry

**Purpose**: Central overlay tracking system

**Key Components**:
- Overlay registration/unregistration
- Active overlay list
- Overlay metadata storage
- Change notification system

**Design**:
- Singleton: `OverlayRegistry.instance`
- Thread-safe operations
- Event-driven updates
- Memory-efficient storage

### 3. Route Observer

**Purpose**: Track navigation for overlay detection

**Key Components**:
- Route push/pop monitoring
- Modal route detection
- Dialog/BottomSheet route identification
- Overlay transition tracking

**Integration**:
```dart
MaterialApp(
  navigatorObservers: [
    GapScopeRouteObserver.instance,
  ],
)
```

### 4. Overlay Capture System

**Purpose**: Safely capture overlay render objects

**Key Components**:
- Overlay-specific capture logic
- Safe render object access
- Different handling per overlay type
- State preservation

**Challenges**:
- Overlays have separate render trees
- Need special capture for modal routes
- Handle different overlay contexts
- Manage overlay lifecycle

### 5. Overlay Region Widgets

**Purpose**: User-facing widgets for overlay marking

**Components**:
- `GapScopeOverlayRegion` - Mark overlay boundaries
- `GapScopeOverlayHost` - Internal overlay host
- Integration with existing inspector

**Usage**:
```dart
GapScopeOverlayRegion(
  name: 'my_dialog',
  type: OverlayType.dialog,
  child: MyDialog(),
)
```

---

## 📐 File Size Constraints

**Target**: Each file ≤ 250 lines (per PROJECT_CONSTRAINTS.md)

**Planned Structure**:
- `overlay_type.dart`: ~50 lines (enum + utilities)
- `overlay_info.dart`: ~120 lines (data model)
- `overlay_registry.dart`: ~200 lines (registry system)
- `gapscope_route_observer.dart`: ~150 lines (route tracking)
- `overlay_capture.dart`: ~180 lines (capture logic)
- `gapscope_overlay_region.dart`: ~120 lines (user widget)
- `gapscope_overlay_host.dart`: ~100 lines (internal host)

---

## 🎯 Success Criteria

### Phase 3 Complete When:

- [x] Phase 2 foundation working
- [ ] Overlay registry functional
- [ ] Route observer implemented
- [ ] Overlay capture working
- [ ] Overlay region widgets operational
- [ ] Inspector renders overlays distinctly
- [ ] Dialog inspection functional
- [ ] BottomSheet inspection functional
- [ ] Dropdown inspection functional
- [ ] All files ≤ 250 lines
- [ ] No architecture violations

### User Experience Goals:

- Visual distinction for overlays
- Easy overlay identification
- Accurate overlay bounds detection
- Smooth overlay tracking
- Professional overlay visualization

---

## 🎨 Design System

### Overlay Visualization

**Color Coding**:
- Dialog: Purple (#9C27B0)
- BottomSheet: Teal (#009688)
- Dropdown: Amber (#FFC107)
- Tooltip: Pink (#E91E63)
- Selected Overlay: Enhanced brightness

**Visual Elements**:
- Dashed borders for overlays
- Different border styles per type
- Overlay type labels
- Nested overlay depth indicators

### Inspector Enhancement

**New Inspector Mode**: `GapScopeMode.overlay`

**Features**:
- Render all active overlays
- Different visual styles per overlay type
- Overlay selection and measurement
- Overlay relationship visualization
- Depth-based nested overlay display

---

## ⚙️ Technical Implementation Details

### Overlay Detection Strategy

**Method 1: Route Observation**
- Monitor Navigator 2.0 routes
- Detect modal routes (dialogs, bottom sheets)
- Track overlay transitions

**Method 2: Widget Tracking**
- User wraps overlays with `GapScopeOverlayRegion`
- Automatic overlay registration
- Lifecycle management

**Method 3: Hybrid Approach** (Recommended)
- Route observation for system overlays
- Widget wrapping for custom overlays
- Best of both approaches

### Registry Implementation

**Singleton Pattern**:
```dart
class OverlayRegistry {
  static OverlayRegistry? _instance;

  static OverlayRegistry get instance {
    _instance ??= OverlayRegistry._internal();
    return _instance!;
  }

  final ValueNotifier<List<OverlayInfo>> overlays = ValueNotifier([]);

  void register(OverlayInfo info) { ... }
  void unregister(String id) { ... }
}
```

### Route Observer Integration

**Navigator 2.0 Observer**:
```dart
class GapScopeRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is OverlayRoute) {
      OverlayRegistry.instance.register(...);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route is OverlayRoute) {
      OverlayRegistry.instance.unregister(...);
    }
  }
}
```

---

## 🚀 Development Workflow

### Current Focus: Overlay Foundation

**Step 1**: Create overlay type system and registry
**Step 2**: Implement route observer
**Step 3**: Build overlay capture system
**Step 4**: Create overlay region widgets
**Step 5**: Integrate with inspector
**Step 6**: Add overlay examples

---

## 🎨 Visualization Design

### Overlay Rendering Styles

**Dialog Style**:
- Purple dashed border (2px)
- Semi-transparent purple fill (10%)
- Dialog icon indicator
- "Dialog" label

**BottomSheet Style**:
- Teal dashed border (2px)
- Semi-transparent teal fill (10%)
- Bottom sheet icon
- "BottomSheet" label

**General Overlay Style**:
- Rounded corners (8px)
- Type indicator icon
- Depth level indicator
- Selection enhancement

### Inspector Mode Enhancement

**New Mode**: `GapScopeMode.overlay`

**Behavior**:
- Show all active overlays
- Use different colors per type
- Enable overlay selection
- Show overlay relationships
- Display overlay metadata

---

## 📊 Performance Considerations

### Critical Performance Constraints

**From PROJECT_CONSTRAINTS.md**:
- Minimal rebuilds with overlay tracking
- Throttle overlay detection
- Cache overlay metadata
- Efficient overlay rendering
- Safe overlay capture

### Performance Strategy

1. **Lazy Registration**: Register overlays only when inspector active
2. **Throttled Updates**: Limit overlay state updates
3. **Efficient Rendering**: Reuse existing painter system
4. **Smart Caching**: Cache overlay bounds information
5. **Background Processing**: Handle overlay lifecycle in background

---

## 🔗 Integration with Existing Code

### Enhanced GapScopeInspector

**Current**: Handles normal widget tree
**Phase 3 Addition**: Overlay awareness

```dart
// Extend inspector to handle overlays
GapScopeInspector(
  enabled: true,
  controller: _controller,
  child: widget.child,
  // Now captures overlays too
)
```

### Enhanced Measurement Engine

**Current**: Normal widget measurements
**Phase 3 Addition**: Overlay-aware measurements

```dart
// Extend measurement engine
measurementEngine.findSnapshotsAtPoint(point, overlays)
measurementEngine.calculateOverlayDistance(overlay1, overlay2)
```

---

## 🧪 Testing Strategy

### Unit Tests

- Overlay type detection
- Registry operations
- Route observer events
- Overlay capture accuracy

### Integration Tests

- Full overlay workflow
- Inspector overlay mode
- Multiple overlay types
- Nested overlays
- Overlay lifecycle

### Manual Tests

- Dialog inspection
- BottomSheet inspection
- Dropdown inspection
- Performance with many overlays

---

## 📈 Progress Metrics

### Foundation Status

**Phase 1**: ✅ Complete
**Phase 2**: ✅ Complete
**Phase 3**: 🚧 In Progress
**Overlay Registry**: ⏳ Not Started
**Route Observer**: ⏳ Not Started
**Overlay Capture**: ⏳ Not Started
**Inspector Integration**: ⏳ Not Started

---

## 🎯 Next Immediate Steps

### 1. Create Overlay Type System
```bash
mkdir -p packages/gapscope/lib/src/overlay
```

### 2. Build Overlay Registry
- Singleton registry implementation
- Overlay registration system
- Change notification setup

### 3. Implement Route Observer
- Navigator 2.0 observer
- Route push/pop tracking
- Overlay detection logic

### 4. Create Overlay Region Widgets
- User-facing overlay region widget
- Internal overlay host
- Integration with registry

---

*This plan guides Phase 3 overlay support implementation while maintaining all architectural constraints and following the blueprint design.*

**Current Status**: Ready to implement Phase 3 overlay foundation
**Next Action**: Create overlay type system and registry

---

*Created: 2025-05-27*
*Phase: Phase 3 - Overlay Support*