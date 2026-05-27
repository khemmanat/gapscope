import 'package:flutter/widgets.dart';

import '../capture/geometry_snapshot.dart';
import '../inspector/gapscope_controller.dart';
import '../measurement/measurement_engine.dart';
import 'bounds_painter.dart';
import 'gap_painter.dart';
import 'overlay_painter.dart';

/// Main CustomPainter for runtime inspection overlay
///
/// Coordinates all visualization layers and provides efficient
/// rendering of bounds, spacing, and measurements.
class InspectorPainter extends CustomPainter { // Selected OverlayInfo (dynamic to avoid circular import)

  const InspectorPainter({
    this.snapshots = const [],
    this.selectedSnapshot,
    this.mode = GapScopeMode.off,
    this.measurementEngine,
    this.overlays = const [],
    this.selectedOverlay,
  });
  final List<GeometrySnapshot> snapshots;
  final GeometrySnapshot? selectedSnapshot;
  final GapScopeMode mode;
  final MeasurementEngine? measurementEngine;
  final List<dynamic> overlays; // OverlayInfo list (dynamic to avoid circular import)
  final dynamic selectedOverlay;

  @override
  void paint(Canvas canvas, Size size) {
    if (mode == GapScopeMode.off) return;

    // Paint overlays if in overlay mode
    if (mode == GapScopeMode.overlay && overlays.isNotEmpty) {
      _paintOverlayMode(canvas);
      return;
    }

    if (snapshots.isEmpty) return;

    // Paint based on current mode
    switch (mode) {
      case GapScopeMode.bounds:
        _paintBoundsMode(canvas);
        break;
      case GapScopeMode.spacing:
        _paintSpacingMode(canvas);
        break;
      default:
        _paintBoundsMode(canvas); // Default to bounds
    }

    // Always paint selection if available
    if (selectedSnapshot != null) {
      _paintSelection(canvas);
    }
  }

  /// Paint bounds visualization mode
  void _paintBoundsMode(Canvas canvas) {
    // Paint all widget bounds
    BoundsPainter.paintMultipleBounds(
      canvas,
      snapshots,
      selectedId: selectedSnapshot?.id,
    );

    // Paint widget type labels for visible widgets
    for (final snapshot in snapshots) {
      if (!snapshot.visible) continue;
      if (snapshot.depth > 3) continue; // Only label top-level widgets

      BoundsPainter.paintWidgetLabel(canvas, snapshot);
    }

    // Paint size info for selected widget
    if (selectedSnapshot != null && selectedSnapshot!.visible) {
      BoundsPainter.paintSizeInfo(canvas, selectedSnapshot!);
    }
  }

  /// Paint spacing visualization mode
  void _paintSpacingMode(Canvas canvas) {
    if (measurementEngine == null || selectedSnapshot == null) {
      _paintBoundsMode(canvas);
      return;
    }

    // First paint bounds as background
    _paintBoundsMode(canvas);

    // Then paint spacing measurements
    final distances = measurementEngine!.findAllDistances(selectedSnapshot!);
    GapPainter.paintAllDistances(canvas, distances);
  }

  /// Paint overlay visualization mode
  void _paintOverlayMode(Canvas canvas) {
    // Cast overlays to proper type for overlay painter
    final overlayPainter = OverlayPainter(
      overlays: overlays.cast(),
      selectedOverlay: selectedOverlay,
    );
    overlayPainter.paint(canvas, const Size(double.infinity, double.infinity));
  }

  /// Paint selection highlights
  void _paintSelection(Canvas canvas) {
    if (selectedSnapshot == null || !selectedSnapshot!.visible) return;

    // Paint enhanced bounds for selected widget
    BoundsPainter.paintSelectedBounds(canvas, selectedSnapshot!);

    // Paint corner handles
    BoundsPainter.paintCornerHandles(canvas, selectedSnapshot!);
  }

  @override
  bool shouldRepaint(InspectorPainter oldDelegate) {
    return oldDelegate.mode != mode ||
        oldDelegate.selectedSnapshot?.id != selectedSnapshot?.id ||
        oldDelegate.overlays.length != overlays.length ||
        _snapshotsChanged(oldDelegate.snapshots);
  }

  /// Check if snapshots changed
  bool _snapshotsChanged(List<GeometrySnapshot> oldSnapshots) {
    if (oldSnapshots.length != snapshots.length) return true;

    for (int i = 0; i < snapshots.length; i++) {
      if (i >= oldSnapshots.length) return true;
      if (snapshots[i].id != oldSnapshots[i].id) return true;
      if (snapshots[i].bounds != oldSnapshots[i].bounds) return true;
    }

    return false;
  }

  /// Create copy with updated values
  InspectorPainter copyWith({
    List<GeometrySnapshot>? snapshots,
    GeometrySnapshot? selectedSnapshot,
    GapScopeMode? mode,
    MeasurementEngine? measurementEngine,
    List<dynamic>? overlays,
    dynamic selectedOverlay,
  }) {
    return InspectorPainter(
      snapshots: snapshots ?? this.snapshots,
      selectedSnapshot: selectedSnapshot ?? this.selectedSnapshot,
      mode: mode ?? this.mode,
      measurementEngine: measurementEngine ?? this.measurementEngine,
      overlays: overlays ?? this.overlays,
      selectedOverlay: selectedOverlay ?? this.selectedOverlay,
    );
  }
}