import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'geometry_snapshot.dart';

/// Captures render tree geometry snapshots safely and efficiently
///
/// Throttles capture operations to maintain performance while providing
/// up-to-date geometry information for runtime inspection.
class RenderTreeCapture {
  static const _defaultThrottleDuration = Duration(milliseconds: 33); // ~30fps

  final Duration throttleDuration;
  final GlobalKey _captureKey = GlobalKey();

  GeometrySnapshot? _lastSnapshot;
  Timer? _throttleTimer;
  bool _captureRequested = false;

  RenderTreeCapture({
    this.throttleDuration = _defaultThrottleDuration,
  });

  /// Get the global key for capturing
  GlobalKey get captureKey => _captureKey;

  /// Get the most recent snapshot
  GeometrySnapshot? get lastSnapshot => _lastSnapshot;

  /// Request a capture (throttled for performance)
  void requestCapture() {
    if (_throttleTimer == null) {
      _performCapture();
      _throttleTimer = Timer(throttleDuration, () {
        _throttleTimer = null;
        if (_captureRequested) {
          _captureRequested = false;
          _performCapture();
        }
      });
    } else {
      _captureRequested = true;
    }
  }

  /// Perform the actual capture operation
  void _performCapture() {
    final RenderObject? renderObject = _captureKey.currentContext?.findRenderObject();
    if (renderObject == null) return;

    _lastSnapshot = GeometrySnapshot.fromRenderObject(
      renderObject,
      _generateId(renderObject),
      0, // Root level
    );
  }

  /// Generate unique ID for render object
  String _generateId(RenderObject renderObject) {
    return '${renderObject.runtimeType}_${renderObject.hashCode}';
  }

  /// Capture entire subtree starting from a render object
  List<GeometrySnapshot> captureSubtree(RenderObject root) {
    final snapshots = <GeometrySnapshot>[];
    _captureRenderObject(root, 0, null, snapshots);
    return snapshots;
  }

  /// Recursively capture render object and children
  void _captureRenderObject(
    RenderObject renderObject,
    int depth,
    String? parentId,
    List<GeometrySnapshot> snapshots,
  ) {
    final id = _generateId(renderObject);
    final snapshot = GeometrySnapshot.fromRenderObject(
      renderObject,
      id,
      depth,
    );

    // Update parent-child relationships
    if (parentId != null) {
      final parentIndex = snapshots.indexWhere((s) => s.id == parentId);
      if (parentIndex >= 0) {
        final parent = snapshots[parentIndex];
        snapshots[parentIndex] = parent.copyWith(
          childIds: [...parent.childIds, id],
        );
      }
    }

    snapshots.add(snapshot.copyWith(parentId: parentId));

    // Capture children
    renderObject.visitChildren((child) {
      _captureRenderObject(child, depth + 1, id, snapshots);
    });
  }

  /// Find snapshot containing a point
  GeometrySnapshot? findSnapshotAtPoint(Offset point, List<GeometrySnapshot> snapshots) {
    // Search from deepest to shallowest
    final sortedSnapshots = List<GeometrySnapshot>.from(snapshots)
      ..sort((a, b) => b.depth.compareTo(a.depth));

    for (final snapshot in sortedSnapshots) {
      if (snapshot.contains(point) && snapshot.visible) {
        return snapshot;
      }
    }
    return null;
  }

  /// Find all snapshots within a bounds
  List<GeometrySnapshot> findSnapshotsInBounds(Rect bounds, List<GeometrySnapshot> snapshots) {
    return snapshots.where((snapshot) {
      return snapshot.bounds.overlaps(bounds) && snapshot.visible;
    }).toList();
  }

  /// Dispose resources
  void dispose() {
    _throttleTimer?.cancel();
    _throttleTimer = null;
  }
}