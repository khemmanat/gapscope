import 'package:flutter/material.dart';

/// Inspector controller for managing inspector state
class GapScopeController extends ValueNotifier<GapScopeMode> {
  GapScopeController([GapScopeMode value = GapScopeMode.off])
      : super(value);

  /// Current inspector mode
  GapScopeMode get mode => value;

  /// Update inspector mode
  void setMode(GapScopeMode mode) {
    value = mode;
  }

  /// Toggle inspector on/off
  void toggle() {
    value = value == GapScopeMode.off
        ? GapScopeMode.bounds
        : GapScopeMode.off;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// Inspector mode enum
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