# Phase 2 Implementation Plan - Runtime Spacing Inspection

## 🎯 Current Phase: Phase 2 - Runtime Spacing Inspection

### Architecture Blueprint Requirements

**Goal**: Runtime spacing inspection

**Required Features**:
- Bounds detection
- Distance calculation
- Hover selection
- Parent spacing
- Sibling spacing

**Performance Constraints**:
- Extremely fast runtime inspection
- Minimal rebuilds
- Overlay-safe architecture

---

## 🏗️ Phase 2 Architecture

### Core Systems to Build

**1. Capture System**
- Render tree capture
- Geometry snapshot
- Safe widget identification

**2. Measurement Engine**
- Bounds detection
- Distance calculations
- Spacing analysis
- Performance-optimized algorithms

**3. Inspector Overlay**
- CustomPainter-based rendering
- Layer system for different visualizations
- Efficient repaint management

**4. Selection System**
- Hover detection
- Target identification
- State management

**5. Integration System**
- Connect to existing GapScopeStudio
- Inspector controls
- Mode switching

---

## 📋 Implementation Strategy

### Step 1: Foundation Systems (Current Priority)

**Create Capture System**:
```dart
packages/gapscope/lib/src/capture/
├── render_tree_capture.dart      # Render object tree capture
├── geometry_snapshot.dart         # Runtime geometry data
└── render_snapshot.dart          # Safe render object data
```

**Create Measurement Engine**:
```dart
packages/gapscope/lib/src/measurement/
├── measurement_engine.dart        # Main measurement coordinator
├── bounds_detector.dart          # Widget bounds detection
├── distance_calculator.dart       # Spacing distance calculations
└── constraint_reader.dart        # Layout constraint reading
```

### Step 2: Inspector Overlay System

**Create Painting System**:
```dart
packages/gapscope/lib/src/painting/
├── inspector_painter.dart         # Main CustomPainter coordinator
├── bounds_painter.dart            # Widget bounds rendering
├── gap_painter.dart               # Spacing gap rendering
└── label_painter.dart             # Measurement labels
```

### Step 3: Integration & Controls

**Enhance Inspector System**:
```dart
packages/gapscope/lib/src/inspector/
├── gapscope_inspector.dart        # Main inspector widget
├── gapscope_controller.dart       # Mode and state management
└── inspect_target.dart            # Target identification
```

### Step 4: Studio Integration

**Integrate with Existing UI**:
- Add inspector overlay to story canvas
- Connect inspector controls to toolbar
- Implement mode switching
- Add hover interaction

---

## 🎨 Technical Architecture

### Performance Strategy

**Key Requirements** (from PROJECT_CONSTRAINTS.md):
- Minimal rebuilds
- Use CustomPainter for rendering
- Throttle pointer events
- Cache geometry snapshots
- Avoid GlobalKeys everywhere
- Use ValueNotifier for lightweight state

### Inspector Modes (from architecture)

```dart
enum GapScopeMode {
  off,        // Inspector disabled
  bounds,     // Show widget bounds
  spacing,    // Show spacing distances
  flex,       // (Phase 4) Flex visualization
  whitespace, // (Phase 4) Whitespace detection
  overlay,    // (Phase 3) Overlay regions
  constraints,// (Phase 4) Layout constraints
  tapTarget,  // (Phase 4) Touch target analysis
}
```

**Phase 2 Focus**: `off`, `bounds`, `spacing` modes only

---

## 🔧 Detailed Implementation Plan

### 1. Capture System Design

**Purpose**: Safely capture runtime widget geometry

**Key Components**:
- **RenderTreeCapture**: Traverse render tree safely
- **GeometrySnapshot**: Immutable snapshot of widget positions
- **RenderSnapshot**: Safe wrapper around RenderObject data

**Design Principles**:
- No render object modification
- Read-only access
- Safe casting and null checking
- Performance-first (throttle capture rate)

### 2. Measurement Engine Design

**Purpose**: Calculate spacing and relationships

**Key Components**:
- **BoundsDetector**: Find widget bounds in snapshots
- **DistanceCalculator**: Calculate pixel distances
- **SpacingAnalyzer**: Parent/sibling spacing analysis

**Algorithms**:
- Rect-based distance calculation
- Parent-child relationship detection
- Sibling relationship detection
- Edge-to-edge measurements

### 3. Inspector Overlay Design

**Purpose**: Visualize inspection results efficiently

**Key Components**:
- **InspectorPainter**: Main CustomPainter
- **BoundsPainter**: Draw widget outlines
- **GapPainter**: Draw spacing measurements
- **LabelPainter**: Draw dimension labels

**Rendering Strategy**:
- Single CustomPainter overlay
- Layer-based rendering
- RepaintBoundary for performance
- Request-only repainting

### 4. Selection System Design

**Purpose**: Identify widgets under cursor

**Key Components**:
- **Hover Detection**: Mouse position tracking
- **Target Identification**: Find render objects at position
- **Selection State**: Track selected widget

**Performance**:
- Throttled hover events (60fps cap)
- Spatial indexing for fast lookup
- Cached render object lookup

---

## 📐 File Size Constraints

**Target**: Each file ≤ 250 lines (per PROJECT_CONSTRAINTS.md)

**Planned Structure**:
- `render_tree_capture.dart`: ~180 lines
- `geometry_snapshot.dart`: ~120 lines
- `measurement_engine.dart`: ~200 lines
- `bounds_detector.dart`: ~150 lines
- `distance_calculator.dart`: ~140 lines
- `inspector_painter.dart`: ~160 lines
- `bounds_painter.dart`: ~130 lines
- `gap_painter.dart`: ~150 lines

---

## 🎯 Success Criteria

### Phase 2 Complete When:

- [x] Phase 1 foundation working
- [ ] Render tree capture working
- [ ] Bounds detection functional
- [ ] Distance calculations accurate
- [ ] Hover selection working
- [ ] Inspector overlay rendering
- [ ] Mode switching functional
- [ ] Performance acceptable (60fps)
- [ ] All files ≤ 250 lines
- [ ] No architecture violations

### User Experience Goals:

- Smooth hover interaction
- Clear visual feedback
- Accurate measurements
- Fast performance
- Professional appearance

---

## 🚀 Development Workflow

### Current Focus: Foundation Systems

**Step 1**: Create capture system foundation
**Step 2**: Build measurement engine
**Step 3**: Implement inspector overlay
**Step 4**: Integrate with existing studio
**Step 5**: Add user controls and mode switching

### Integration Approach

**Non-Breaking Integration**:
- Add inspector overlay to story canvas
- Use existing GapScopeInspector widget
- Extend GapScopeController modes
- Add inspector controls to toolbar

---

## 🎨 Design System

### Visual Design

**Bounds Visualization**:
- Color-coded widget outlines
- Semi-transparent fills
- Different colors for selected vs unselected

**Spacing Visualization**:
- Dimension lines with arrows
- Distance labels in pixels
- Color-coded relationships (parent/sibling)

**Selection Feedback**:
- Highlight selected widget
- Show measurement details
- Clear visual hierarchy

### Color Scheme

**Bounds Colors**:
- Unselected: Blue with 30% opacity
- Selected: Blue with 70% opacity
- Parent-child: Green spacing
- Sibling: Orange spacing

---

## ⚙️ Technical Implementation Details

### Capture System Architecture

**Key Challenge**: Safe render object access
**Solution**: Copy only needed data, no references

```dart
class GeometrySnapshot {
  final Rect bounds;
  final String widgetType;
  final int depth;
  // Copy data, not references
}
```

### Measurement Engine Architecture

**Key Challenge**: Fast distance calculations
**Solution**: Pre-computed spatial indexing

```dart
class MeasurementEngine {
  final Map<String, List<GeometrySnapshot>> _spatialIndex;
  // Fast lookups for distance calculations
}
```

### Inspector Overlay Architecture

**Key Challenge**: Efficient rendering
**Solution**: Layer-based CustomPainter

```dart
class InspectorPainter extends CustomPainter {
  final List<PaintLayer> layers;
  // Each layer handles specific visualization
}
```

---

## 📊 Performance Considerations

### Critical Performance Constraints

**From PROJECT_CONSTRAINTS.md**:
- Avoid continuous full tree scanning
- Throttle pointer events
- Cache geometry snapshots
- Use RepaintBoundary strategically
- Prefer CustomPainter over widget overlays

### Performance Strategy

1. **Capture Throttling**: Limit to 30fps max
2. **Render Throttling**: Limit to 60fps max
3. **Spatial Caching**: Cache render object lookups
4. **Incremental Updates**: Only update changed regions
5. **Background Processing**: Use compute isolates for heavy calculations

---

## 🔗 Integration with Existing Code

### GapScopeInspector Enhancement

**Current**: Foundation widget with controller
**Phase 2 Addition**: Runtime inspection capabilities

```dart
// Extend existing widget
GapScopeInspector(
  enabled: true,
  controller: _controller,
  child: storyWidget,
  // Add inspector overlay
)
```

### StoryCanvas Integration

**Current**: Story rendering in card
**Phase 2 Addition**: Inspector overlay

```dart
// Wrap story in inspector
GapScopeInspector(
  enabled: _inspectorEnabled,
  controller: _inspectorController,
  child: story.builder(context),
)
```

---

## 🧪 Testing Strategy

### Unit Tests

- Geometry snapshot creation
- Distance calculation accuracy
- Bounds detection correctness
- Spacing relationship detection

### Integration Tests

- Full inspection workflow
- Mode switching behavior
- Performance under load
- Edge cases (overlapping widgets, etc.)

### Performance Tests

- Capture frequency benchmarks
- Render performance benchmarks
- Memory usage monitoring
- Frame rate consistency

---

## 📈 Progress Metrics

### Foundation Status

**Phase 1**: ✅ Complete
**Phase 2**: 🚧 In Progress
**Capture System**: ⏳ Not Started
**Measurement Engine**: ⏳ Not Started
**Inspector Overlay**: ⏳ Not Started
**Integration**: ⏳ Not Started

---

## 🎯 Next Immediate Steps

### 1. Create Capture System
```bash
mkdir -p packages/gapscope/lib/src/capture
```

### 2. Build Geometry Snapshot
- Create immutable data structures
- Implement safe render object capture
- Add performance throttling

### 3. Implement Measurement Engine
- Build bounds detector
- Create distance calculator
- Implement spacing analysis

### 4. Create Inspector Overlay
- Design CustomPainter architecture
- Implement bounds painting
- Add spacing visualization

---

*This plan guides Phase 2 runtime inspection implementation while maintaining all architectural constraints and following the blueprint design.*

**Current Status**: Ready to implement Phase 2 foundation
**Next Action**: Create capture system and measurement engine

---

*Created: 2025-05-27*
*Phase: Phase 2 - Runtime Spacing Inspection*