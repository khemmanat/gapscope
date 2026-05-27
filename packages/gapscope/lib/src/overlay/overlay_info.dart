import 'package:flutter/material.dart';
import 'overlay_type.dart';

/// Immutable metadata about an overlay in the GapScope system
class OverlayInfo {
  /// Unique identifier for this overlay instance
  final String id;

  /// Type of overlay
  final OverlayType type;

  /// Route name if this is a navigational overlay
  final String? routeName;

  /// Current bounds of the overlay
  final Rect bounds;

  /// Whether the overlay is currently visible
  final bool isVisible;

  /// ID of parent overlay if nested
  final String? parentOverlayId;

  /// When this overlay was created
  final DateTime createdAt;

  /// Widget type of the overlay content
  final String widgetType;

  /// Depth level for nested overlays (0 = top level)
  final int depth;

  /// Create overlay info with all required fields
  const OverlayInfo({
    required this.id,
    required this.type,
    this.routeName,
    required this.bounds,
    required this.isVisible,
    this.parentOverlayId,
    required this.createdAt,
    required this.widgetType,
    this.depth = 0,
  });

  /// Create overlay info with current timestamp
  factory OverlayInfo.now({
    required String id,
    required OverlayType type,
    String? routeName,
    required Rect bounds,
    bool isVisible = true,
    String? parentOverlayId,
    required String widgetType,
    int depth = 0,
  }) {
    return OverlayInfo(
      id: id,
      type: type,
      routeName: routeName,
      bounds: bounds,
      isVisible: isVisible,
      parentOverlayId: parentOverlayId,
      createdAt: DateTime.now(),
      widgetType: widgetType,
      depth: depth,
    );
  }

  /// Check if this overlay contains another overlay info
  bool contains(OverlayInfo other) {
    return bounds.contains(other.bounds.topLeft) &&
        bounds.contains(other.bounds.bottomRight);
  }

  /// Check if this overlay is a child of another overlay
  bool isChildOf(OverlayInfo other) {
    if (parentOverlayId == null) return false;
    return parentOverlayId == other.id;
  }

  /// Calculate center point of overlay bounds
  Offset get center => bounds.center;

  /// Create a copy with some fields replaced
  OverlayInfo copyWith({
    String? id,
    OverlayType? type,
    String? routeName,
    Rect? bounds,
    bool? isVisible,
    String? parentOverlayId,
    DateTime? createdAt,
    String? widgetType,
    int? depth,
  }) {
    return OverlayInfo(
      id: id ?? this.id,
      type: type ?? this.type,
      routeName: routeName ?? this.routeName,
      bounds: bounds ?? this.bounds,
      isVisible: isVisible ?? this.isVisible,
      parentOverlayId: parentOverlayId ?? this.parentOverlayId,
      createdAt: createdAt ?? this.createdAt,
      widgetType: widgetType ?? this.widgetType,
      depth: depth ?? this.depth,
    );
  }

  @override
  String toString() {
    return 'OverlayInfo(id: $id, type: ${type.displayName}, '
        'visible: $isVisible, bounds: $bounds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OverlayInfo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}