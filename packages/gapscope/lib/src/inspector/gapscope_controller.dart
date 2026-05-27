import 'package:flutter/material.dart';

/// Inspector controller for managing inspector state
class GapScopeController extends ValueNotifier<GapScopeMode> {
  GapScopeController([super.value = GapScopeMode.off]);

  /// Current inspector mode
  GapScopeMode get mode => value;

  /// Update inspector mode
  set mode(GapScopeMode mode) => value = mode;

  /// Toggle inspector on/off
  void toggle() {
    value = value == GapScopeMode.off ? GapScopeMode.bounds : GapScopeMode.off;
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
