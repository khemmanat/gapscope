import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'overlay_info.dart';
import 'overlay_type.dart';

/// Central registry for tracking active overlays in GapScope
///
/// Uses singleton pattern to provide global access while maintaining
/// thread-safe operations and efficient change notifications.
class OverlayRegistry {
  /// Private constructor for singleton pattern
  OverlayRegistry._internal();

  /// Singleton instance
  static OverlayRegistry? _instance;

  /// Get the singleton instance
  static OverlayRegistry get instance {
    _instance ??= OverlayRegistry._internal();
    return _instance!;
  }

  /// Current active overlays
  final ValueNotifier<List<OverlayInfo>> overlays = ValueNotifier([]);

  /// Internal storage for overlays
  final List<OverlayInfo> _internalOverlays = [];

  /// Register a new overlay
  void register(OverlayInfo info) {
    if (_internalOverlays.any((overlay) => overlay.id == info.id)) {
      // Update existing overlay
      final index = _internalOverlays.indexWhere((overlay) => overlay.id == info.id);
      _internalOverlays[index] = info;
    } else {
      // Add new overlay
      _internalOverlays.add(info);
    }

    _notifyListeners();
  }

  /// Unregister an overlay by ID
  void unregister(String id) {
    final initialLength = _internalOverlays.length;
    _internalOverlays.removeWhere((overlay) => overlay.id == id);
    if (_internalOverlays.length < initialLength) {
      _notifyListeners();
    }
  }

  /// Update overlay bounds
  void updateBounds(String id, Rect newBounds) {
    try {
      final overlay = _internalOverlays.firstWhere((overlay) => overlay.id == id);
      final index = _internalOverlays.indexOf(overlay);
      _internalOverlays[index] = overlay.copyWith(bounds: newBounds);
      _notifyListeners();
    } catch (e) {
      // Overlay not found, ignore
    }
  }

  /// Get overlay by ID
  OverlayInfo? getOverlay(String id) {
    try {
      return _internalOverlays.firstWhere((overlay) => overlay.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all overlays of a specific type
  List<OverlayInfo> getOverlaysByType(OverlayType type) {
    return _internalOverlays.where((overlay) => overlay.type == type).toList();
  }

  /// Get visible overlays only
  List<OverlayInfo> getVisibleOverlays() {
    return _internalOverlays.where((overlay) => overlay.isVisible).toList();
  }

  /// Get child overlays of a parent overlay
  List<OverlayInfo> getChildOverlays(String parentId) {
    return _internalOverlays
        .where((overlay) => overlay.parentOverlayId == parentId)
        .toList();
  }

  /// Clear all overlays
  void clear() {
    if (_internalOverlays.isNotEmpty) {
      _internalOverlays.clear();
      _notifyListeners();
    }
  }

  /// Get current overlay count
  int get count => _internalOverlays.length;

  /// Check if registry is empty
  bool get isEmpty => _internalOverlays.isEmpty;

  /// Check if registry has overlays
  bool get isNotEmpty => _internalOverlays.isNotEmpty;

  /// Notify listeners of changes
  void _notifyListeners() {
    overlays.value = List.unmodifiable(_internalOverlays);
  }

  /// Reset the singleton instance (for testing purposes)
  static void reset() {
    _instance?.clear();
    _instance = null;
  }

  /// Get overlays that contain a specific point
  List<OverlayInfo> getOverlaysAtPoint(Offset point) {
    return _internalOverlays
        .where((overlay) =>
            overlay.isVisible && overlay.bounds.contains(point),
        )
        .toList();
  }

  /// Get topmost overlay at a specific point
  OverlayInfo? getTopmostOverlayAtPoint(Offset point) {
    final overlaysAtPoint = getOverlaysAtPoint(point);
    if (overlaysAtPoint.isEmpty) return null;

    // Return the overlay with highest depth (most nested)
    overlaysAtPoint.sort((a, b) => b.depth.compareTo(a.depth));
    return overlaysAtPoint.first;
  }
}