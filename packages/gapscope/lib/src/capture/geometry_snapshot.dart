import 'dart:ui';
import 'package:flutter/rendering.dart';

/// Immutable snapshot of widget geometry for safe runtime inspection
///
/// Copies only essential data from render objects, avoiding direct references
/// to ensure safety and performance.
class GeometrySnapshot {
  /// Unique identifier for this snapshot
  final String id;

  /// Bounding box in global coordinates
  final Rect bounds;

  /// Widget type name for display
  final String widgetType;

  /// Depth in widget tree (0 = root)
  final int depth;

  /// Whether this widget is visible
  final bool visible;

  /// Parent widget ID (if any)
  final String? parentId;

  /// Child widget IDs
  final List<String> childIds;

  const GeometrySnapshot({
    required this.id,
    required this.bounds,
    required this.widgetType,
    required this.depth,
    this.visible = true,
    this.parentId,
    this.childIds = const [],
  });

  /// Create snapshot from render object
  static GeometrySnapshot fromRenderObject(
    RenderObject renderObject,
    String id,
    int depth,
  ) {
    final bounds = _getBounds(renderObject);

    return GeometrySnapshot(
      id: id,
      bounds: bounds,
      widgetType: renderObject.runtimeType.toString(),
      depth: depth,
      visible: _isVisible(renderObject),
    );
  }

  /// Get bounds from render object safely
  static Rect _getBounds(RenderObject renderObject) {
    try {
      // Try to get semantic bounds if available
      if (renderObject is RenderSemanticsAnnotations) {
        final semanticsBox = (renderObject as RenderSemanticsAnnotations).semanticBounds;
        if (semanticsBox != null) {
          return semanticsBox;
        }
      }

      // Fall back to paint bounds
      final localBounds = renderObject.paintBounds;

      // Try to get global position through the render object's localToGlobal
      // This needs to be called from the render object's context
      try {
        final matrix = renderObject.getTransformTo(null);
        final globalPosition = MatrixUtils.transformPoint(matrix, Offset.zero);
        return Rect.fromLTWH(
          globalPosition.dx,
          globalPosition.dy,
          localBounds.width,
          localBounds.height,
        );
      } catch (e) {
        // If transform fails, just return local bounds at origin
        return localBounds;
      }
    } catch (e) {
      // Fallback to zero-size rect if bounds unavailable
      return Rect.zero;
    }
  }

  /// Check if render object is visible
  static bool _isVisible(RenderObject renderObject) {
    try {
      // Check if the render object has a layer and is attached
      if (!renderObject.attached) {
        return false;
      }

      // For render boxes, check if they have positive size
      if (renderObject is RenderBox) {
        final box = renderObject as RenderBox;
        final size = box.size;
        return size.width > 0 && size.height > 0;
      }

      return true;
    } catch (e) {
      return true; // Assume visible if can't determine
    }
  }

  /// Calculate center point
  Offset get center => bounds.center;

  /// Calculate size
  Size get size => bounds.size;

  /// Check if point is inside bounds
  bool contains(Offset point) => bounds.contains(point);

  /// Calculate distance to another snapshot
  double distanceTo(GeometrySnapshot other) {
    final centers = center;
    final otherCenter = other.center;
    return (centers - otherCenter).distance;
  }

  /// Find closest edge point to another snapshot
  Offset closestEdgeTo(GeometrySnapshot other) {
    final otherCenter = other.center;
    final dx = otherCenter.dx.clamp(bounds.left, bounds.right);
    final dy = otherCenter.dy.clamp(bounds.top, bounds.bottom);
    return Offset(dx, dy);
  }

  /// Check if this snapshot intersects with another
  bool intersects(GeometrySnapshot other) {
    return bounds.overlaps(other.bounds);
  }

  /// Calculate parent-child relationship
  bool isParentOf(GeometrySnapshot other) {
    return parentId == other.id || childIds.contains(other.id);
  }

  /// Calculate sibling relationship (same parent)
  bool isSiblingOf(GeometrySnapshot other) {
    return parentId != null && parentId == other.parentId;
  }

  GeometrySnapshot copyWith({
    String? id,
    Rect? bounds,
    String? widgetType,
    int? depth,
    bool? visible,
    String? parentId,
    List<String>? childIds,
  }) {
    return GeometrySnapshot(
      id: id ?? this.id,
      bounds: bounds ?? this.bounds,
      widgetType: widgetType ?? this.widgetType,
      depth: depth ?? this.depth,
      visible: visible ?? this.visible,
      parentId: parentId ?? this.parentId,
      childIds: childIds ?? this.childIds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeometrySnapshot &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}