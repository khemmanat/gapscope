import 'package:flutter/material.dart';
import 'overlay_type.dart';
import 'gapscope_overlay_region.dart';

/// Internal host widget for automatic overlay detection
///
/// Provides parent tracking and lifecycle management for nested overlays.
/// Used internally by GapScope overlay system for managing overlay hierarchies.
class GapScopeOverlayHost extends StatelessWidget {
  /// Child widget to host
  final Widget child;

  /// Optional parent overlay ID for nested overlays
  final String? parentOverlayId;

  const GapScopeOverlayHost({
    super.key,
    required this.child,
    this.parentOverlayId,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Builder widget for creating custom overlay regions
///
/// Provides a flexible API for creating overlay regions with dynamic content.
class GapScopeOverlayBuilder extends StatefulWidget {
  /// Builder function that creates the overlay content
  final Widget Function(BuildContext context) builder;

  /// Unique identifier for this overlay
  final String id;

  /// Type of overlay
  final OverlayType type;

  /// Optional name for this overlay
  final String? name;

  /// Whether this overlay is initially visible
  final bool initiallyVisible;

  const GapScopeOverlayBuilder({
    super.key,
    required this.builder,
    required this.id,
    required this.type,
    this.name,
    this.initiallyVisible = true,
  });

  @override
  State<GapScopeOverlayBuilder> createState() =>
      _GapScopeOverlayBuilderState();
}

class _GapScopeOverlayBuilderState extends State<GapScopeOverlayBuilder> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.initiallyVisible;
  }

  /// Toggle overlay visibility
  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  /// Set overlay visibility
  void setVisibility(bool visible) {
    setState(() {
      _isVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return GapScopeOverlayRegion(
      id: widget.id,
      type: widget.type,
      name: widget.name,
      isVisible: true,
      child: widget.builder(context),
    );
  }
}

/// Convenience widget for dialog overlays
class GapScopeDialogRegion extends StatelessWidget {
  /// Dialog content
  final Widget child;

  /// Unique identifier
  final String id;

  /// Optional dialog name
  final String? name;

  const GapScopeDialogRegion({
    super.key,
    required this.child,
    required this.id,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GapScopeOverlayRegion(
      id: id,
      type: OverlayType.dialog,
      name: name ?? 'Dialog',
      child: child,
    );
  }
}

/// Convenience widget for bottom sheet overlays
class GapScopeBottomSheetRegion extends StatelessWidget {
  /// Bottom sheet content
  final Widget child;

  /// Unique identifier
  final String id;

  /// Optional bottom sheet name
  final String? name;

  const GapScopeBottomSheetRegion({
    super.key,
    required this.child,
    required this.id,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GapScopeOverlayRegion(
      id: id,
      type: OverlayType.bottomSheet,
      name: name ?? 'BottomSheet',
      child: child,
    );
  }
}

/// Convenience widget for dropdown overlays
class GapScopeDropdownRegion extends StatelessWidget {
  /// Dropdown content
  final Widget child;

  /// Unique identifier
  final String id;

  /// Optional dropdown name
  final String? name;

  const GapScopeDropdownRegion({
    super.key,
    required this.child,
    required this.id,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GapScopeOverlayRegion(
      id: id,
      type: OverlayType.dropdown,
      name: name ?? 'Dropdown',
      child: child,
    );
  }
}

/// Convenience widget for custom popup overlays
class GapScopePopupRegion extends StatelessWidget {
  /// Popup content
  final Widget child;

  /// Unique identifier
  final String id;

  /// Optional popup name
  final String? name;

  const GapScopePopupRegion({
    super.key,
    required this.child,
    required this.id,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GapScopeOverlayRegion(
      id: id,
      type: OverlayType.popupMenu,
      name: name ?? 'Popup',
      child: child,
    );
  }
}