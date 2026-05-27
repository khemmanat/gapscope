/// Base state model for GapScope addons
///
/// Provides a common interface for addon state management
class AddonState {
  /// Whether this addon is currently enabled
  final bool enabled;

  const AddonState({this.enabled = true});

  AddonState copyWith({bool? enabled}) {
    return AddonState(enabled: enabled ?? this.enabled);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddonState &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled;

  @override
  int get hashCode => enabled.hashCode;
}