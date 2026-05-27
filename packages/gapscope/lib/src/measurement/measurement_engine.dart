import 'package:flutter/widgets.dart';
import '../capture/geometry_snapshot.dart';

/// Coordinates measurement operations for runtime spacing inspection
///
/// Provides high-performance spatial analysis and distance calculations
/// while maintaining strict performance constraints.
class MeasurementEngine {

  MeasurementEngine({this.snapshots = const []})
      : _snapshotMap = {for (var s in snapshots) s.id: s};
  final List<GeometrySnapshot> snapshots;
  final Map<String, GeometrySnapshot> _snapshotMap;

  /// Get snapshot by ID
  GeometrySnapshot? getSnapshot(String id) => _snapshotMap[id];

  /// Find all snapshots at a point (deepest first)
  List<GeometrySnapshot> findSnapshotsAtPoint(Offset point) {
    final candidates = <GeometrySnapshot>[];

    for (final snapshot in snapshots) {
      if (snapshot.contains(point) && snapshot.visible) {
        candidates.add(snapshot);
      }
    }

    // Sort by depth descending (deepest first)
    candidates.sort((a, b) => b.depth.compareTo(a.depth));
    return candidates;
  }

  /// Find deepest snapshot at point
  GeometrySnapshot? findDeepestAtPoint(Offset point) {
    final candidates = findSnapshotsAtPoint(point);
    return candidates.isNotEmpty ? candidates.first : null;
  }

  /// Calculate distance between two snapshots
  SpacingDistance calculateDistance(GeometrySnapshot from, GeometrySnapshot to) {
    if (!from.visible || !to.visible) {
      return const SpacingDistance.invisible();
    }

    // Check for relationships first
    if (from.isParentOf(to) || to.isParentOf(from)) {
      return _calculateParentChildSpacing(from, to);
    }

    if (from.isSiblingOf(to)) {
      return _calculateSiblingSpacing(from, to);
    }

    // Default: center-to-center distance
    final centerDistance = from.distanceTo(to);
    return SpacingDistance(
      from: from.closestEdgeTo(to),
      to: to.closestEdgeTo(from),
      pixels: centerDistance,
      type: SpacingType.general,
    );
  }

  /// Calculate parent-child spacing
  SpacingDistance _calculateParentChildSpacing(GeometrySnapshot parent, GeometrySnapshot child) {
    // Find the shortest edge-to-edge distance
    final fromEdge = parent.closestEdgeTo(child);
    final toEdge = child.closestEdgeTo(parent);
    final pixels = (fromEdge - toEdge).distance;

    return SpacingDistance(
      from: fromEdge,
      to: toEdge,
      pixels: pixels,
      type: SpacingType.parentChild,
    );
  }

  /// Calculate sibling spacing
  SpacingDistance _calculateSiblingSpacing(GeometrySnapshot sibling1, GeometrySnapshot sibling2) {
    // Find horizontal spacing first
    final horizontalSpacing = _calculateHorizontalSpacing(sibling1, sibling2);

    // Find vertical spacing
    final verticalSpacing = _calculateVerticalSpacing(sibling1, sibling2);

    // Return the minimum spacing
    if (horizontalSpacing < verticalSpacing) {
      return SpacingDistance(
        from: sibling1.closestEdgeTo(sibling2),
        to: sibling2.closestEdgeTo(sibling1),
        pixels: horizontalSpacing,
        type: SpacingType.sibling,
        orientation: SpacingOrientation.horizontal,
      );
    } else {
      return SpacingDistance(
        from: sibling1.closestEdgeTo(sibling2),
        to: sibling2.closestEdgeTo(sibling1),
        pixels: verticalSpacing,
        type: SpacingType.sibling,
        orientation: SpacingOrientation.vertical,
      );
    }
  }

  /// Calculate horizontal spacing between two widgets
  double _calculateHorizontalSpacing(GeometrySnapshot left, GeometrySnapshot right) {
    if (left.bounds.right <= right.bounds.left) {
      // Widgets are horizontally separated
      return right.bounds.left - left.bounds.right;
    } else if (right.bounds.right <= left.bounds.left) {
      // Widgets are horizontally separated (reversed)
      return left.bounds.left - right.bounds.right;
    } else {
      // Widgets overlap horizontally
      return 0;
    }
  }

  /// Calculate vertical spacing between two widgets
  double _calculateVerticalSpacing(GeometrySnapshot top, GeometrySnapshot bottom) {
    if (top.bounds.bottom <= bottom.bounds.top) {
      // Widgets are vertically separated
      return bottom.bounds.top - top.bounds.bottom;
    } else if (bottom.bounds.bottom <= top.bounds.top) {
      // Widgets are vertically separated (reversed)
      return top.bounds.top - bottom.bounds.bottom;
    } else {
      // Widgets overlap vertically
      return 0;
    }
  }

  /// Find all parent-child distances for a snapshot
  List<SpacingDistance> findParentChildDistances(GeometrySnapshot snapshot) {
    final distances = <SpacingDistance>[];

    // Find parent
    if (snapshot.parentId != null) {
      final parent = getSnapshot(snapshot.parentId!);
      if (parent != null && parent.visible) {
        distances.add(calculateDistance(parent, snapshot));
      }
    }

    // Find children
    for (final childId in snapshot.childIds) {
      final child = getSnapshot(childId);
      if (child != null && child.visible) {
        distances.add(calculateDistance(snapshot, child));
      }
    }

    return distances;
  }

  /// Find all sibling distances for a snapshot
  List<SpacingDistance> findSiblingDistances(GeometrySnapshot snapshot) {
    if (snapshot.parentId == null) return [];

    final siblings = snapshots.where((s) =>
      s.parentId == snapshot.parentId &&
      s.id != snapshot.id &&
      s.visible,
    );

    return siblings.map((sibling) =>
      calculateDistance(snapshot, sibling),
    ).toList();
  }

  /// Find all distances for a snapshot
  List<SpacingDistance> findAllDistances(GeometrySnapshot snapshot) {
    return [
      ...findParentChildDistances(snapshot),
      ...findSiblingDistances(snapshot),
    ];
  }

  /// Update snapshots and rebuild spatial index
  MeasurementEngine updateSnapshots(List<GeometrySnapshot> newSnapshots) {
    return MeasurementEngine(snapshots: newSnapshots);
  }
}

/// Distance measurement between two widgets
class SpacingDistance {

  const SpacingDistance({
    required this.from,
    required this.to,
    required this.pixels,
    required this.type,
    this.orientation = SpacingOrientation.none,
  });

  /// Create distance for invisible widgets
  const SpacingDistance.invisible()
      : from = Offset.zero,
        to = Offset.zero,
        pixels = 0,
        type = SpacingType.invisible,
        orientation = SpacingOrientation.none;
  final Offset from;
  final Offset to;
  final double pixels;
  final SpacingType type;
  final SpacingOrientation orientation;

  /// Check if this represents a meaningful spacing
  bool get isMeaningful => pixels > 0 && type != SpacingType.invisible;

  /// Get formatted distance string
  String get formatted => '${pixels.toStringAsFixed(1)}px';

  @override
  String toString() => 'SpacingDistance($formatted, $type)';
}

/// Type of spacing relationship
enum SpacingType {
  parentChild,
  sibling,
  general,
  invisible,
}

/// Orientation of spacing
enum SpacingOrientation {
  horizontal,
  vertical,
  none,
}