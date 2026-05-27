import 'package:flutter/widgets.dart';

import '../capture/geometry_snapshot.dart';
import '../capture/render_tree_capture.dart';
import '../measurement/measurement_engine.dart';
import '../overlay/overlay_info.dart';
import '../overlay/overlay_registry.dart';
import '../painting/inspector_painter.dart';
import 'gapscope_controller.dart';

/// Enhanced inspector widget for GapScope Studio (Phase 2 + Phase 3 overlay support)
///
/// Provides runtime widget inspection with bounds detection, spacing analysis,
/// and overlay visualization.
class GapScopeInspector extends StatefulWidget {
  const GapScopeInspector({
    super.key,
    this.enabled = true,
    this.controller,
    required this.child,
  });
  final bool enabled;
  final GapScopeController? controller;
  final Widget child;

  @override
  State<GapScopeInspector> createState() => _GapScopeInspectorState();
}

class _GapScopeInspectorState extends State<GapScopeInspector> {
  late GapScopeController _controller;
  late RenderTreeCapture _capture;
  late MeasurementEngine _measurementEngine;

  GeometrySnapshot? _selectedSnapshot;
  List<GeometrySnapshot> _currentSnapshots = [];

  // Phase 3 overlay support
  OverlayInfo? _selectedOverlay;
  List<OverlayInfo> _currentOverlays = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? GapScopeController();
    _capture = RenderTreeCapture();
    _measurementEngine = MeasurementEngine();

    if (!widget.enabled) {
      _controller.mode = GapScopeMode.off;
    }

    _controller.addListener(_onControllerChanged);

    // Listen to overlay registry changes
    OverlayRegistry.instance.overlays.addListener(_onOverlaysChanged);
  }

  @override
  void didUpdateWidget(GapScopeInspector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (!widget.enabled) {
        _controller.mode = GapScopeMode.off;
      }
    }

    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onControllerChanged);
      _controller = widget.controller ?? GapScopeController();
      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    OverlayRegistry.instance.overlays.removeListener(_onOverlaysChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _capture.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {
      // Rebuild when controller changes
    });
  }

  void _onOverlaysChanged() {
    setState(() {
      _currentOverlays = OverlayRegistry.instance.overlays.value;
    });
  }

  void _handlePointerEvent(PointerEvent event) {
    if (_controller.mode == GapScopeMode.off) return;

    switch (event) {
      case PointerDownEvent():
        _handlePointerDown(event);
        break;
      case PointerMoveEvent():
        _handlePointerMove(event);
        break;
      default:
        break;
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_controller.mode == GapScopeMode.overlay) {
      _selectOverlayAtPoint(event.position);
    } else {
      _capture.requestCapture();
      _updateSnapshots();
      _selectSnapshotAtPoint(event.position);
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.buttons == 0) return; // Only respond when button pressed

    if (_controller.mode == GapScopeMode.overlay) {
      _selectOverlayAtPoint(event.position);
    } else {
      _capture.requestCapture();
      _selectSnapshotAtPoint(event.position);
    }
  }

  void _selectSnapshotAtPoint(Offset position) {
    final snapshot = _measurementEngine.findDeepestAtPoint(position);
    setState(() {
      _selectedSnapshot = snapshot;
    });
  }

  void _selectOverlayAtPoint(Offset position) {
    final overlay = OverlayRegistry.instance.getTopmostOverlayAtPoint(position);
    setState(() {
      _selectedOverlay = overlay;
    });
  }

  void _updateSnapshots() {
    try {
      final renderObject =
          _capture.captureKey.currentContext?.findRenderObject();
      if (renderObject == null) return;

      _currentSnapshots = _capture.captureSubtree(renderObject);
      _measurementEngine =
          _measurementEngine.updateSnapshots(_currentSnapshots);
    } catch (e) {
      // Handle capture errors gracefully
      _currentSnapshots = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.mode == GapScopeMode.off) {
      return widget.child;
    }

    return Stack(
      children: [
        // Wrap child in mouse region for hover detection
        Listener(
          onPointerDown: _handlePointerEvent,
          onPointerMove: _handlePointerEvent,
          behavior: HitTestBehavior.translucent,
          child: widget.child,
        ),

        // Inspector overlay
        Positioned.fill(
          child: CustomPaint(
            painter: InspectorPainter(
              snapshots: _currentSnapshots,
              selectedSnapshot: _selectedSnapshot,
              mode: _controller.mode,
              measurementEngine: _measurementEngine,
              overlays: _currentOverlays,
              selectedOverlay: _selectedOverlay,
            ),
          ),
        ),
      ],
    );
  }
}
