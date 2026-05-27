import 'package:flutter/material.dart';
import 'overlay_info.dart';
import 'overlay_registry.dart';
import 'overlay_type.dart';

/// Widget that marks an overlay region for GapScope inspection
///
/// Wrap your overlay widgets with GapScopeOverlayRegion to enable
/// inspection and visualization of custom overlays like dialogs,
/// bottom sheets, dropdowns, etc.
class GapScopeOverlayRegion extends StatefulWidget {

  const GapScopeOverlayRegion({
    super.key,
    required this.child,
    required this.id,
    required this.type,
    this.name,
    this.isVisible = true,
  });
  /// The overlay widget to inspect
  final Widget child;

  /// Unique identifier for this overlay region
  final String id;

  /// Type of overlay for visualization
  final OverlayType type;

  /// Optional name for this overlay
  final String? name;

  /// Whether this overlay is currently visible
  final bool isVisible;

  @override
  State<GapScopeOverlayRegion> createState() => _GapScopeOverlayRegionState();
}

class _GapScopeOverlayRegionState extends State<GapScopeOverlayRegion> {
  /// Global key for accessing render object
  final GlobalKey _renderKey = GlobalKey();

  /// Current overlay info in registry
  OverlayInfo? _currentOverlay;

  @override
  void initState() {
    super.initState();
    _registerOverlay();
  }

  @override
  void didUpdateWidget(GapScopeOverlayRegion oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update registration if key properties changed
    if (oldWidget.id != widget.id ||
        oldWidget.type != widget.type ||
        oldWidget.isVisible != widget.isVisible) {
      _updateOverlayRegistration();
    }
  }

  @override
  void dispose() {
    _unregisterOverlay();
    super.dispose();
  }

  /// Register this overlay in the registry
  void _registerOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOverlayBounds();
    });
  }

  /// Update overlay registration when properties change
  void _updateOverlayRegistration() {
    if (_currentOverlay != null) {
      _unregisterOverlay();
    }
    _registerOverlay();
  }

  /// Unregister this overlay from the registry
  void _unregisterOverlay() {
    OverlayRegistry.instance.unregister(widget.id);
    _currentOverlay = null;
  }

  /// Update overlay bounds from render object
  void _updateOverlayBounds() {
    final renderObject = _renderKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      try {
        final size = renderObject.size;
        final position = renderObject.localToGlobal(Offset.zero);
        final bounds = Rect.fromLTWH(
          position.dx,
          position.dy,
          size.width,
          size.height,
        );

        final overlayInfo = OverlayInfo(
          id: widget.id,
          type: widget.type,
          routeName: widget.name,
          bounds: bounds,
          isVisible: widget.isVisible,
          widgetType: widget.child.runtimeType.toString(),
          createdAt: DateTime.now(),
          depth: _calculateDepth(),
        );

        OverlayRegistry.instance.register(overlayInfo);
        _currentOverlay = overlayInfo;
      } catch (e) {
        // Render object not ready, will retry in next frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateOverlayBounds();
        });
      }
    }
  }

  /// Calculate depth for nested overlays
  int _calculateDepth() {
    final currentInfo = _currentOverlay;
    if (currentInfo == null) return 0;

    int depth = 0;
    String? parentId = currentInfo.parentOverlayId;

    while (parentId != null) {
      depth++;
      final parentOverlay = OverlayRegistry.instance.getOverlay(parentId);
      if (parentOverlay == null) break;
      parentId = parentOverlay.parentOverlayId;
    }

    return depth;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _renderKey,
      child: widget.child,
    );
  }
}