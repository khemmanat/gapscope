# GapScope Studio - Project Constraints & Rules

## 🔒 Development Constraints

### Scope Boundaries (Current Phase: Phase 1)

**We ARE building:**
- ✅ Basic Studio + Story Preview
- ✅ Sidebar navigation
- ✅ Story rendering system
- ✅ Theme addon
- ✅ Device addon
- ✅ Inspector toggle
- ✅ Component catalog foundation

**We are NOT building (yet):**
- ❌ Runtime spacing inspection (Phase 2)
- ❌ Overlay support (Phase 3)
- ❌ Advanced QA features (Phase 4)
- ❌ Export ecosystem (Phase 5)
- ❌ Cloud sync system
- ❌ Full browser-based editor
- ❌ Figma plugin
- ❌ Remote collaborative editing

### Feature Freeze Rules

**Allowed Features:**
- Story system (GapScopeStory, GapScopeComponent)
- Basic UI foundation (sidebar, canvas, toolbar)
- Theme and device preview addons
- Basic inspector toggle (without full inspection logic)
- Package structure foundation

**Prohibited Features:**
- Runtime measurement calculations
- Overlay inspection systems
- Flex visualization
- Whitespace detection
- Accessibility checks
- Advanced painting systems
- Export functionality

---

## 🏗️ Architecture Constraints

### Package Structure Rules

**MUST Maintain:**
```
gapscope/
├── packages/gapscope/          # Reusable package ONLY
├── apps/gapscope_studio_app/    # Development app ONLY
└── docs/                        # Documentation ONLY
```

**Package Boundary Rules:**
- ✅ `packages/gapscope` can have NO dependencies on `apps/`
- ✅ `apps/gapscope_studio_app` CAN depend on `packages/gapscope`
- ❌ NO circular dependencies
- ❌ NO app code in packages
- ❌ NO package-specific code in apps

### File Size Constraints

**STRICT Limits:**
- Maximum: **250 lines per file**
- Recommended: **100-200 lines per file**
- One primary class per file
- One responsibility per file

**Examples:**
```dart
// ✅ GOOD - Single responsibility, 150 lines
class GapScopeStory {
  // Story-specific logic only
}

// ❌ BAD - Multiple responsibilities, 400+ lines
class GapScopeStory {
  // Story logic + UI + state + ... (too much!)
}
```

### State Management Constraints

**ALLOWED:**
- ✅ `ValueNotifier` for lightweight state
- ✅ `ChangeNotifier` for complex state
- ✅ `InheritedNotifier` for scoped state
- ✅ Standard Flutter state management

**PROHIBITED:**
- ❌ Riverpod dependency in `packages/gapscope`
- ❌ Provider dependency in `packages/gapscope`
- ❌ Any external state management coupling in packages

**Example:**
```yaml
# packages/gapscope/pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

# ❌ NO state management packages!
# ✅ Keep it dependency-free

# apps/gapscope_studio_app/pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  gapscope:
    path: ../../packages/gapscope

# ✅ Apps CAN use Riverpod/Provider if needed
# riverpod: ^2.0.0
```

---

## 🎯 Technical Constraints

### Performance Rules

**MANDATORY:**
- ✅ Minimize rebuilds
- ✅ Use `RepaintBoundary` strategically
- ✅ Prefer `CustomPainter` over widget-based rendering
- ✅ Throttle pointer events
- ✅ Cache geometry snapshots

**PROHIBITED:**
- ❌ Deep widget tree rebuilds
- ❌ `setState` everywhere
- ❌ Continuous full tree scanning
- ❌ Heavy reflection operations
- ❌ Excessive allocations during pointer movement

### Dependency Rules

**ALLOWED Dependencies (packages/gapscope):**
```yaml
dependencies:
  flutter:
    sdk: flutter
  collection: ^1.0.0
  meta: ^1.0.0
```

**PROHIBITED Dependencies:**
- ❌ Heavy UI libraries
- ❌ Complex state management
- ❌ Unnecessary networking libraries
- ❌ Large utility packages

### API Design Constraints

**Public API Rules:**
- ✅ Export ONLY through `lib/gapscope.dart`
- ✅ Keep internal implementation in `lib/src/`
- ✅ Use stable, well-documented APIs
- ✅ Follow Flutter API conventions

**Internal Structure:**
```dart
// lib/gapscope.dart (PUBLIC API)
export 'src/studio/gapscope_studio.dart';
export 'src/studio/gapscope_component.dart';
// ✅ ONLY export stable public APIs

// lib/src/ (INTERNAL)
// ✅ All implementation details stay here
// ❌ NO direct imports from outside package
```

---

## 📋 Development Workflow Constraints

### Phase-Specific Rules

**Current Phase: Phase 1**
- Focus: Basic Studio + Story Preview
- Scope: Foundation systems only
- Duration: Until story system works

**Phase Transition Rules:**
- ❌ NO Phase 2 features until Phase 1 is complete
- ❌ NO Phase 3 features until Phase 2 is complete
- ✅ Phase completion must be verified
- ✅ Architecture review required before phase advance

### Code Review Constraints

**Must Pass:**
- ✅ File size ≤ 250 lines
- ✅ No circular dependencies
- ✅ Public API properly exported
- ✅ Performance rules followed
- ✅ Architecture constraints respected
- ✅ Lint rules pass

**Blocking Issues:**
- ❌ Files > 250 lines
- ❌ Package boundary violations
- ❌ Performance rule violations
- ❌ Dependency rule violations

---

## 🚨 Enforcement Rules

### Pre-Commit Checklist

**Before ANY commit:**
- [ ] File size ≤ 250 lines
- [ ] No prohibited features
- [ ] Package boundaries maintained
- [ ] Dependencies within constraints
- [ ] Performance rules followed
- [ ] Lint rules pass
- [ ] Phase-appropriate features only

### Violation Consequences

**Automatic Reject:**
- Files > 250 lines
- Circular dependencies
- Package boundary violations
- Phase-inappropriate features
- Prohibited dependencies

**Required Fixes:**
- Split oversized files immediately
- Remove circular dependencies immediately
- Move code to appropriate package
- Remove advanced features until appropriate phase

---

## 🎯 Current Sprint Boundaries

### Sprint Goal: Phase 1 Foundation

**Target Components:**
- `GapScopeStudio` - Main studio shell
- `GapScopeComponent` - Component definition
- `GapScopeStory` - Story definition
- Basic sidebar UI
- Canvas for story rendering
- Theme addon foundation
- Device addon foundation

**Success Criteria:**
- [ ] Can define components and stories
- [ ] Can navigate between stories
- [ ] Can switch themes
- [ ] Can preview device frames
- [ ] All files ≤ 250 lines
- [ ] All constraints followed
- [ ] Package structure clean

### Out-of-Scope (Do NOT Build)

- Runtime inspector logic
- Measurement systems
- Overlay handling
- Advanced painting
- Export functionality
- Cloud features

---

## 📊 Measurement & Compliance

### Compliance Metrics

**Track These:**
- File size compliance (target: 100%)
- Package boundary violations (target: 0)
- Phase appropriateness (target: 100%)
- Dependency rule compliance (target: 100%)
- Performance rule compliance (target: 100%)

### Weekly Reviews

**Check:**
- All constraints followed
- Phase boundaries maintained
- Package structure intact
- File sizes within limits
- Dependencies appropriate

---

## 🔧 Decision Framework

### When Adding Features

**Ask:**
1. Is this in Phase 1 scope? → NO: Don't build
2. Does it fit existing architecture? → NO: Redesign
3. Can it be kept under 250 lines? → NO: Split it
4. Does it maintain package boundaries? → NO: Restructure
5. Does it follow performance rules? → NO: Optimize

### When Facing Technical Decisions

**Framework:**
1. Check architecture blueprint
2. Verify current phase scope
3. Ensure constraint compliance
4. Maintain package boundaries
5. Follow established patterns

---

## 🚀 Success Criteria

### Phase 1 Complete When:

- ✅ Story system works end-to-end
- ✅ Basic UI navigation functional
- ✅ Theme/device addons work
- ✅ All constraints followed
- ✅ All files ≤ 250 lines
- ✅ Package boundaries intact
- ✅ Foundation ready for Phase 2

### Project Success Metrics:

- ✅ Architecture constraints respected
- ✅ Performance goals met
- ✅ Package boundaries maintained
- ✅ Clean, maintainable code
- ✅ Phase-appropriate features only

---

## 📝 Quick Reference

### Phase 1 DO's:
✅ Build story system
✅ Create basic UI
✅ Add theme/device addons
✅ Maintain package boundaries
✅ Keep files small
✅ Follow performance rules

### Phase 1 DON'Ts:
❌ Build runtime inspector
❌ Add measurement systems
❌ Create overlay handling
❌ Add advanced features
❌ Violate package boundaries
❌ Create large files

---

*This document governs all GapScope Studio development. Updates require architecture review.*
*Last Updated: 2025-05-27*
*Current Phase: Phase 1*