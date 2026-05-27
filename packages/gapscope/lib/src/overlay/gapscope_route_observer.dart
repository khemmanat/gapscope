import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'overlay_info.dart';
import 'overlay_registry.dart';
import 'overlay_type.dart';

/// Route observer for tracking navigation-based overlays
///
/// Monitors Navigator 2.0 route transitions to automatically
/// detect and register overlay routes like dialogs and bottom sheets.
class GapScopeRouteObserver extends NavigatorObserver {
  /// Private constructor for singleton pattern
  GapScopeRouteObserver._internal();

  /// Singleton instance
  static GapScopeRouteObserver? _instance;

  /// Get the singleton instance
  static GapScopeRouteObserver get instance {
    _instance ??= GapScopeRouteObserver._internal();
    return _instance!;
  }

  /// Unique ID generator for routes
  int _routeIdCounter = 0;

  /// Generate unique ID for a route
  String _generateRouteId(Route route) {
    return 'route_${_routeIdCounter++}_${route.runtimeType}';
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _registerRouteIfOverlay(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _unregisterRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      _unregisterRoute(oldRoute);
    }
    if (newRoute != null) {
      _registerRouteIfOverlay(newRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _unregisterRoute(route);
  }

  /// Register route as overlay if it matches overlay patterns
  void _registerRouteIfOverlay(Route<dynamic> route) {
    final overlayType = _detectOverlayType(route);
    if (overlayType == null) return;

    final routeId = _generateRouteId(route);
    final routeName = _getRouteName(route);

    // Create initial overlay info (bounds will be updated later)
    final overlayInfo = OverlayInfo.now(
      id: routeId,
      type: overlayType,
      routeName: routeName,
      bounds: Rect.zero, // Will be updated when route renders
      widgetType: route.runtimeType.toString(),
    );

    OverlayRegistry.instance.register(overlayInfo);
  }

  /// Unregister a route overlay
  void _unregisterRoute(Route<dynamic> route) {
    // Find and remove overlay by searching through current overlays
    final registry = OverlayRegistry.instance;
    final currentOverlays = registry.overlays.value;

    for (final overlay in currentOverlays) {
      if (overlay.routeName != null &&
          overlay.routeName == _getRouteName(route)) {
        registry.unregister(overlay.id);
        break;
      }
    }
  }

  /// Detect overlay type from route
  OverlayType? _detectOverlayType(Route<dynamic> route) {
    // Material dialogs
    if (route is MaterialPageRoute) {
      return OverlayType.dialog;
    }

    // Cupertino dialogs
    if (route is CupertinoPageRoute) {
      return OverlayType.dialog;
    }

    // Popup routes (dropdowns, menus)
    if (route.runtimeType.toString().contains('PopupRoute')) {
      return OverlayType.popupMenu;
    }

    // Bottom sheet routes
    if (route.runtimeType.toString().contains('BottomSheet')) {
      return OverlayType.bottomSheet;
    }

    // Dialog routes
    if (route.runtimeType.toString().contains('Dialog')) {
      return OverlayType.dialog;
    }

    return null;
  }

  /// Get route name for identification
  String? _getRouteName(Route<dynamic> route) {
    // Try to get name from route settings
    final settings = route.settings;
    if (settings.name != null) {
      return settings.name;
    }

    // Generate name from runtime type
    return route.runtimeType.toString();
  }

  /// Update route overlay bounds when rendered
  void updateRouteBounds(Route<dynamic> route, Rect newBounds) {
    final routeName = _getRouteName(route);
    final registry = OverlayRegistry.instance;

    try {
      final overlay = registry.overlays.value.firstWhere(
        (overlay) => overlay.routeName == routeName,
      );

      registry.updateBounds(overlay.id, newBounds);
    } catch (e) {
      // Overlay not found, ignore
    }
  }

  /// Reset the singleton instance (for testing purposes)
  static void reset() {
    _instance = null;
  }
}