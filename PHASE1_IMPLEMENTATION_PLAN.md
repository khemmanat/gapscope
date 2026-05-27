# Phase 1 UI Implementation Plan

## 🎯 Current Phase: Phase 1 - Basic Studio + Story Preview

### Architecture Guidance Summary

**From Blueprint**:
```dart
GapScopeStudio(
  title: 'Design System',
  addons: [
    DeviceAddon(),
    ThemeAddon(),
  ],
  components: [
    ButtonStories(),
    InputStories(),
  ],
)
```

**UI System Structure Required**:
- Toolbar
- Side panels (sidebar)
- Story browser
- Inspector controls
- Addon controls

---

## 📋 Phase 1 Implementation Plan

### Priority 1: Core Studio UI Structure

**Goal**: Create the main studio layout with responsive design

**Components to Build**:
1. **Studio Shell** - Main layout container
2. **Sidebar** - Component/story navigation
3. **Story Canvas** - Story rendering area
4. **Addon Panel** - Addon controls
5. **Toolbar** - Quick actions

**File Structure**:
```
packages/gapscope/lib/src/ui/
├── studio_shell.dart           # Main layout container
├── component_sidebar.dart      # Story navigation
├── story_canvas.dart           # Story rendering
├── addon_panel.dart            # Addon controls
└── inspector_toolbar.dart      # Quick actions
```

### Priority 2: Story System Implementation

**Goal**: Make the story foundation functional with UI

**Features**:
- Story selection from sidebar
- Story rendering in canvas
- Component grouping
- Story navigation

**Implementation**:
- Wire up existing `GapScopeCatalog` to UI
- Connect `_selectStory` method to story selection
- Use `_currentStory` for rendering
- Display component organization

### Priority 3: Addon Integration

**Goal**: Make addons functional with UI controls

**Theme Addon**:
- Theme switcher button in addon panel
- Light/Dark/System mode toggle
- Theme preview in real-time

**Device Addon**:
- Device selector in addon panel
- Device frame preview
- Responsive testing

### Priority 4: Studio Layout & Navigation

**Goal**: Complete studio experience

**Features**:
- Responsive layout (desktop-first)
- Collapsible sidebar
- Full-screen story preview
- Addon panel toggle
- Inspector toggle (foundation only)

---

## 🏗️ Implementation Strategy

### Step 1: UI Foundation (Current Priority)

**Create UI Package Structure**:
```bash
mkdir -p packages/gapscope/lib/src/ui
```

**Build Core Components**:
1. `studio_shell.dart` - Main responsive layout
2. `component_sidebar.dart` - Story navigation
3. `story_canvas.dart` - Story rendering area

**Design Approach**:
- Material 3 design system
- Desktop-first responsive layout
- Row-based layout: [Sidebar | Canvas | Addon Panel]
- Collapsible panels
- Keyboard shortcuts support

### Step 2: Story System Integration

**Wire Foundation to UI**:
- Connect `GapScopeStudio._catalog` to sidebar
- Connect `_selectStory` to story selection
- Connect `_currentStory` to canvas rendering
- Implement story navigation

**Story Rendering**:
- Display selected story in canvas
- Handle story state changes
- Support story parameters (future)

### Step 3: Addon UI Controls

**Theme Addon Integration**:
- Create theme switcher widget
- Connect to `ThemeAddon.state`
- Apply theme changes to studio
- Persist theme preference

**Device Addon Integration**:
- Create device selector widget
- Connect to `DeviceAddon.state`
- Apply device frame to canvas
- Support custom device sizes

### Step 4: Polish & Navigation

**Complete User Experience**:
- Smooth transitions between stories
- Responsive sidebar behavior
- Addon panel animations
- Keyboard shortcuts
- Visual feedback

---

## 📐 UI Layout Design

### Main Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│                        Toolbar                                │
├──────────┬──────────────────────────────┬───────────────────┤
│          │                              │                   │
│  Sidebar │       Story Canvas           │   Addon Panel     │
│          │                              │                   │
│ Components│   [Selected Story Preview]   │  Theme Controls   │
│   ├── A  │                              │  Device Controls  │
│   ├── B  │                              │  Inspector Toggle │
│   └── C  │                              │                   │
│          │                              │                   │
└──────────┴──────────────────────────────┴───────────────────┘
```

### Responsive Behavior

**Large Screens (>1200px)**:
- Full 3-column layout
- Sidebar: 300px
- Canvas: flex
- Addon Panel: 300px

**Medium Screens (800-1200px)**:
- Collapsible addon panel
- Flexible sidebar width

**Small Screens (<800px)**:
- Full-screen canvas
- Overlay sidebar
- Overlay addon controls

---

## 🎨 Material 3 Design System

### Color Scheme

**Primary**: Blue-based (as set in app)
**Surface**: Material 3 surfaces
**Elevation**: Material 3 elevation system

### Components

**Cards**: Story previews, addon controls
**Navigation**: Rail/Drawer for sidebar
**Buttons**: Filled, outlined, text buttons
**Icons**: Material icons throughout

### Typography

**Headlines**: Story titles, component names
**Body**: Story descriptions, UI text
**Labels**: Small UI labels

---

## ⚙️ Technical Implementation

### State Management

**Approach**: ValueNotifier-based (per architecture)

**Studio State**:
```dart
class StudioState extends ChangeNotifier {
  GapScopeCatalog? catalog;
  StoryData? selectedStory;
  List<GapScopeAddon> addons;
  // ...
}
```

**Addon State**:
- Use existing addon state classes
- Connect to UI controllers
- Real-time updates

### Performance Considerations

**Constraints** (from PROJECT_CONSTRAINTS.md):
- Minimize rebuilds
- Use RepaintBoundary for story canvas
- Throttle story selection changes
- Cache rendered stories when possible

**File Size Constraints**:
- Each UI file: ≤ 250 lines
- Split complex components
- Keep focused responsibilities

---

## 🚀 Development Workflow

### Current Focus: UI Foundation

**Step 1**: Create UI structure files
**Step 2**: Build studio shell layout
**Step 3**: Implement sidebar navigation
**Step 4**: Create story canvas rendering
**Step 5**: Integrate addon controls

### Testing Strategy

**Widget Tests**:
- Studio layout rendering
- Story selection behavior
- Addon control interactions
- Responsive layout behavior

**Integration Tests**:
- Full story navigation flow
- Addon functionality
- Theme switching
- Device preview

---

## 📊 Success Metrics

### Phase 1 Complete When:

- [x] Foundation components exist
- [ ] Studio shell layout works
- [ ] Story navigation functional
- [ ] Story rendering operational
- [ ] Theme addon integration works
- [ ] Device addon integration works
- [ ] All files ≤ 250 lines
- [ ] No architecture violations
- [ ] Responsive layout works

### User Experience Goals:

- Smooth story navigation
- Intuitive sidebar organization
- Real-time theme switching
- Responsive device preview
- Professional Material 3 design

---

## 🎯 Next Immediate Steps

### 1. Create UI Package Structure
```bash
mkdir -p packages/gapscope/lib/src/ui
```

### 2. Build Core UI Components
- `studio_shell.dart` - Main layout
- `component_sidebar.dart` - Navigation
- `story_canvas.dart` - Rendering

### 3. Update GapScopeStudio
- Connect UI components
- Wire up existing state
- Implement interaction handlers

### 4. Test Integration
- Run in studio app
- Verify navigation
- Test addon functionality

---

*This plan guides Phase 1 UI implementation while maintaining all architectural constraints and following the blueprint design.*

**Current Status**: Ready to implement UI foundation
**Next Action**: Create UI package structure and build first components

---

*Created: 2025-05-27*
*Phase: Phase 1 - UI Implementation*