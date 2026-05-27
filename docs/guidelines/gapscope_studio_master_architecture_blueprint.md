# GapScope Studio

## Overview

GapScope Studio is a Flutter component workbench and advanced runtime QA inspector.

It combines:

- Widgetbook-style component catalog
- Runtime layout inspection
- Overlay/dialog/bottomsheet inspection
- Flex and whitespace visualization
- Accessibility inspection
- Story preview system
- Addon ecosystem
- QA reporting tools

---

# Vision

GapScope Studio should become:

> The all-in-one Flutter design system, component workbench, runtime layout debugger, and QA visualization platform.

Unlike Widgetbook or standard Flutter Inspector, GapScope Studio focuses heavily on:

- Real runtime measurements
- Overlay-aware inspection
- QA-friendly visualization
- Flex spacing detection
- Whitespace analysis
- Runtime rendering accuracy

---

# Core Goals

## Primary Goals

- Extremely fast runtime inspection
- Minimal rebuilds
- Overlay-safe architecture
- Modular package structure
- AI-agent friendly architecture
- Small focused files
- Flutter lint compliance
- Extensible addon system
- Cross-platform support
- Production-safe debugging

## Non-Goals (Initial)

- Full browser-based editor
- Cloud sync system
- Figma plugin
- Remote collaborative editing

---

# Recommended Tech Stack

## Core

- Flutter latest stable
- Dart latest stable
- Material 3
- flutter_lints

## Suggested Optional Dependencies

```yaml
dependencies:
  collection:
  meta:
  uuid:
  vector_math:

dev_dependencies:
  flutter_lints:
  build_runner:
```

Avoid unnecessary heavy dependencies.

---

# Repository Structure

```txt
gapscope/
  melos.yaml
  pubspec.yaml
  README.md

  apps/
    gapscope_studio_app/

  packages/
    gapscope/

  tools/

  docs/
```

---

# Melos Workspace

## melos.yaml

```yaml
name: gapscope

packages:
  - packages/**
  - apps/**
```

---

# Main Package Structure

```txt
packages/
  gapscope/
    lib/
      gapscope.dart

      src/
        studio/
        addons/
        inspector/
        capture/
        measurement/
        overlay/
        painting/
        ui/
        models/
        services/
        utils/
```

---

# Detailed Architecture

# Studio Layer

Purpose:

- Component catalog
- Story navigation
- Addon management
- Preview shell
- Device preview
- Theme preview

## Structure

```txt
studio/
  gapscope_studio.dart
  gapscope_component.dart
  gapscope_story.dart
  gapscope_catalog.dart
  gapscope_registry.dart
  gapscope_story_context.dart
```

---

# Inspector Layer

Purpose:

- Runtime widget inspection
- Geometry analysis
- Distance calculations
- Overlay tracking
- Rendering measurements

## Structure

```txt
inspector/
  gapscope_inspector.dart
  gapscope_controller.dart
  gapscope_config.dart
  gapscope_mode.dart
  inspect_target.dart
```

---

# Overlay System

Purpose:

Flutter overlays are difficult because dialogs, dropdowns, bottom sheets, and overlay entries exist outside normal widget subtrees.

GapScope must inspect:

- Dialog
- BottomSheet
- Dropdown
- Tooltip
- PopupMenu
- OverlayEntry
- OverlayPortal
- Nested overlays

## Structure

```txt
overlay/
  overlay_registry.dart
  overlay_capture.dart
  gapscope_overlay_region.dart
  gapscope_overlay_host.dart
  gapscope_route_observer.dart
```

---

# Measurement System

Purpose:

- Calculate spacing
- Detect whitespace
- Detect flex gaps
- Detect Expanded runtime size
- Detect Spacer usage
- Detect alignment offsets
- Detect edge distances
- Detect tap targets

## Structure

```txt
measurement/
  measurement_engine.dart
  flex_gap_detector.dart
  whitespace_detector.dart
  tap_target_checker.dart
  constraint_reader.dart
```

---

# Capture System

Purpose:

Capture render object geometry safely.

## Structure

```txt
capture/
  render_tree_capture.dart
  geometry_snapshot.dart
  render_snapshot.dart
```

---

# Painting System

Purpose:

Efficient rendering of:

- Bounds
- Distance lines
- Gap labels
- Highlight boxes
- Flex spacing indicators
- Whitespace regions
- Tap targets

## Structure

```txt
painting/
  inspector_painter.dart
  bounds_painter.dart
  gap_painter.dart
  label_painter.dart
  flex_painter.dart
```

---

# UI System

Purpose:

- Toolbar
- Side panels
- Story browser
- Inspector controls
- Addon controls

## Structure

```txt
ui/
  studio_shell.dart
  component_sidebar.dart
  addon_panel.dart
  inspector_toolbar.dart
  story_canvas.dart
```

---

# Runtime Flow

```txt
Pointer Hover
    ↓
Throttle Input
    ↓
Capture Render Tree
    ↓
Generate Geometry Snapshot
    ↓
Run Measurement Engine
    ↓
Update Inspector State
    ↓
CustomPainter Repaint
```

---

# Performance Rules

## Must Follow

- Avoid rebuilding app tree
- Prefer CustomPainter
- Use RepaintBoundary
- Throttle pointer events
- Cache geometry snapshots
- Avoid GlobalKeys everywhere
- Use ValueNotifier for lightweight state
- Use post-frame callbacks carefully

## Avoid

- Deep rebuilds
- setState everywhere
- Continuous full tree scanning
- Heavy reflection
- Excessive allocations during pointer movement

---

# File Size Convention

## Recommended

- 100–250 lines per file
- One responsibility per file
- One primary class per file

## Avoid

- God files
- 1000+ line widgets
- Massive utility files

---

# State Management

## Recommended

Internal package:

- ValueNotifier
- ChangeNotifier
- InheritedNotifier

Example apps:

- Riverpod optional

Do not hard-couple package to Riverpod.

---

# Public API Design

## Studio Example

```dart
GapScopeStudio(
  title: 'Design System',
  addons: [
    DeviceAddon(),
    ThemeAddon(),
    LocaleAddon(),
    TextScaleAddon(),
    InspectorAddon(),
  ],
  components: [
    ButtonStories(),
    InputStories(),
  ],
)
```

## Runtime Inspector Example

```dart
MaterialApp(
  navigatorObservers: [
    GapScopeRouteObserver.instance,
  ],
  builder: (context, child) {
    return GapScopeInspector(
      enabled: true,
      child: child ?? const SizedBox.shrink(),
    );
  },
)
```

---

# Addon System

GapScope Studio should support addons similar to Widgetbook.

## Initial Addons

- DeviceAddon
- ThemeAddon
- LocaleAddon
- TextScaleAddon
- InspectorAddon
- AccessibilityAddon

## Future Addons

- Network Mocking
- API Scenario Switching
- Golden Testing
- Screenshot Export
- State Presets
- Animation Speed Control

---

# Inspector Modes

```dart
enum GapScopeMode {
  off,
  bounds,
  spacing,
  flex,
  whitespace,
  overlay,
  constraints,
  tapTarget,
}
```

---

# Overlay Strategy

# Important

This is one of the most important systems.

## Problem

Flutter overlays are often outside the main widget subtree.

## Solution

GapScope uses:

### 1. Root Overlay Host

```dart
Stack(
  children: [
    child,
    GapScopeOverlayHost(),
  ],
)
```

### 2. Route Observer

```dart
navigatorObservers: [
  GapScopeRouteObserver.instance,
]
```

### 3. Overlay Registry

```dart
GapScopeOverlayRegion(
  name: 'dropdown',
  child: MyDropdown(),
)
```

---

# Geometry Snapshot

## Purpose

Capture runtime render information.

## Example

```dart
final class GeometrySnapshot {
  const GeometrySnapshot({
    required this.id,
    required this.rect,
    required this.depth,
    required this.visible,
    required this.runtimeTypeName,
  });

  final String id;
  final Rect rect;
  final int depth;
  final bool visible;
  final String runtimeTypeName;
}
```

---

# Rendering Strategy

## Preferred

- CustomPainter
- Layer-based rendering
- Single repaint surface

## Avoid

- Widget overlays for every indicator
- Thousands of Positioned widgets

---

# Accessibility Inspection

Initial checks:

- Tap target size
- Overflow risk
- Text scaling problems
- Contrast warnings (future)
- Small touch area detection

---

# Suggested Keyboard Shortcuts

```txt
Cmd/Ctrl + Shift + I   Toggle inspector
Cmd/Ctrl + Shift + G   Gap mode
Cmd/Ctrl + Shift + F   Flex mode
Cmd/Ctrl + Shift + O   Overlay mode
Esc                     Clear selection
```

---

# Suggested Inspector Toolbar

```txt
[Select]
[Spacing]
[Flex]
[Whitespace]
[Overlay]
[Constraints]
[Tap Targets]
```

---

# Initial MVP Roadmap

# Phase 1

Goal:

Basic Studio + Story Preview

Features:

- Sidebar
- Story rendering
- Theme addon
- Device addon
- Inspector toggle

# Phase 2

Goal:

Runtime spacing inspection

Features:

- Bounds detection
- Distance calculation
- Hover selection
- Parent spacing
- Sibling spacing

# Phase 3

Goal:

Overlay support

Features:

- Dialog inspection
- BottomSheet inspection
- Dropdown inspection
- Overlay registry

# Phase 4

Goal:

Advanced QA

Features:

- Flex visualization
- Spacer analysis
- Whitespace detection
- Accessibility checks

# Phase 5

Goal:

Export + ecosystem

Features:

- Screenshot export
- QA report export
- Golden integration
- CI support

---

# Lint Rules

## analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    public_member_api_docs: true
    prefer_const_constructors: true
    prefer_final_locals: true
    avoid_print: true
    sort_constructors_first: true
    require_trailing_commas: true
```

---

# Naming Rules

## File Naming

```txt
snake_case.dart
```

## Class Naming

```txt
PascalCase
```

## Variables

```txt
camelCase
```

---

# Documentation Strategy

Every public class should contain:

- Purpose
- Usage example
- Notes
- Limitations

---

# Testing Strategy

## Must Have

- Unit tests
- Widget tests
- Golden tests

## Initial Coverage

- Measurement engine
- Geometry calculations
- Overlay registry
- Flex calculations

---

# Future Possibilities

## Potential Future Features

- AI layout analysis
- Figma sync
- DevTools extension
- VSCode extension
- Remote QA sessions
- Cloud snapshots
- Layout timeline replay
- Animation frame inspector
- Multi-device sync preview

---

# Suggested Initial Commands

## Create Workspace

The root folder is a workspace, not the package itself.

```bash
mkdir gapscope
cd gapscope
```

## Create Melos Workspace File

Create `melos.yaml` in the root:

```yaml
name: gapscope

packages:
  - packages/**
  - apps/**
```

## Create Main Reusable Package

This is the real package that can later be used in production apps or published to pub.dev.

```bash
flutter create --template=package packages/gapscope
```

## Create Studio Development App

This app is only for local development, previewing stories, testing addons, and developing the inspector UI.

```bash
flutter create apps/gapscope_studio_app
```

## Activate Melos

```bash
dart pub global activate melos
```

## Bootstrap Workspace

```bash
melos bootstrap
```

---

# Package Export Strategy

The reusable package lives here:

```txt
packages/gapscope
```

The studio app lives here:

```txt
apps/gapscope_studio_app
```

The studio app depends on the package. The package must never depend on the studio app.

Correct direction:

```txt
apps/gapscope_studio_app
    ↓ uses
packages/gapscope
```

Wrong direction:

```txt
packages/gapscope
    ↓ depends on
apps/gapscope_studio_app
```

---

# Using GapScope in a Real Flutter Project

## Local Path Dependency

```yaml
dependencies:
  gapscope:
    path: ../gapscope/packages/gapscope
```

## Git Dependency

```yaml
dependencies:
  gapscope:
    git:
      url: https://github.com/your-org/gapscope.git
      path: packages/gapscope
```

## Future pub.dev Dependency

```yaml
dependencies:
  gapscope: ^1.0.0
```

---

# Main Package Requirements

Inside `packages/gapscope`, keep it ready for real package distribution:

```txt
packages/gapscope/
  lib/
  test/
  example/
  pubspec.yaml
  README.md
  CHANGELOG.md
  LICENSE
```

The root workspace can contain internal docs and tools, but the package itself must remain clean and publishable.

---

# Package Boundary Rules

## Must Follow

- `packages/gapscope` contains reusable public APIs.
- `apps/gapscope_studio_app` is only a development and preview app.
- The package should not import from the app.
- Public exports must go through `lib/gapscope.dart`.
- Internal implementation must stay under `lib/src`.
- Only stable APIs should be exported.

## Export Example

```dart
library gapscope;

export 'src/studio/gapscope_studio.dart';
export 'src/studio/gapscope_component.dart';
export 'src/studio/gapscope_story.dart';
export 'src/inspector/gapscope_inspector.dart';
export 'src/inspector/gapscope_controller.dart';
export 'src/overlay/gapscope_overlay_region.dart';
export 'src/overlay/gapscope_route_observer.dart';
```

---

# Recommended Early Development Order

## Phase 1

Create the package and app structure.

```txt
packages/gapscope
apps/gapscope_studio_app
melos.yaml
```

## Phase 2

Build only the story system.

```txt
GapScopeStory
GapScopeComponent
GapScopeStudio
Sidebar
Canvas
Addon Panel
```

## Phase 3

Connect the studio app to local package.

In `apps/gapscope_studio_app/pubspec.yaml`:

```yaml
dependencies:
  gapscope:
    path: ../../packages/gapscope
```

## Phase 4

Add the inspector foundation.

```txt
GapScopeInspector
GapScopeController
GapScopeMode
GapScopeConfig
CustomPainter overlay
```

## Phase 5

Add measurement engine and overlay system.

```txt
Render tree capture
Bounds measurement
Spacing labels
Overlay registry
Dialog/bottomsheet inspection
```

---

# Suggested Git Strategy

## Main Branches

```txt
main
develop
```

## Feature Branches

```txt
feature/inspector
feature/overlay-system
feature/flex-visualizer
feature/studio-ui
```

---

# Suggested README Positioning

```txt
GapScope Studio is a Flutter component workbench and runtime QA inspector that combines Widgetbook-style component previews with advanced spacing, overlay, flex, whitespace, and accessibility inspection.
```

---

# Final Recommendation

Do not position GapScope Studio as:

- only a Widgetbook competitor
- only a Flutter Inspector replacement

Instead position it as:

> The runtime-aware Flutter QA and component workbench platform.

That positioning is significantly stronger because it covers:

- design systems
- runtime QA
- overlay inspection
- layout debugging
- accessibility
- developer experience
- design verification

all inside one ecosystem.

