import '../models/addon_state.dart';

/// Base class for GapScope addons
///
/// Addons extend the functionality of GapScope Studio with additional
/// features like device preview, theme switching, etc.
abstract class GapScopeAddon<T extends AddonState> {
  /// Unique identifier for this addon
  String get id;

  /// Display name for this addon
  String get name;

  /// Optional description
  String? get description;

  /// Current state of the addon
  T get state;

  /// Create a new state with updated values
  T updateState(T state);

  /// Whether this addon is enabled
  bool get isEnabled => state.enabled;
}