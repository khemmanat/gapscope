import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Enumeration of all supported overlay types in GapScope
enum OverlayType {
  /// Modal dialog overlays
  dialog,

  /// Bottom sheet overlays
  bottomSheet,

  /// Dropdown menus
  dropdown,

  /// Tooltip overlays
  tooltip,

  /// Popup menu overlays
  popupMenu,

  /// Custom OverlayEntry widgets
  overlayEntry,

  /// OverlayPortal widgets
  overlayPortal,

  /// Other uncategorized overlays
  other,
}

/// Extension providing overlay type metadata and styling
extension OverlayTypeExtension on OverlayType {
  /// Get display name for the overlay type
  String get displayName {
    switch (this) {
      case OverlayType.dialog:
        return 'Dialog';
      case OverlayType.bottomSheet:
        return 'BottomSheet';
      case OverlayType.dropdown:
        return 'Dropdown';
      case OverlayType.tooltip:
        return 'Tooltip';
      case OverlayType.popupMenu:
        return 'PopupMenu';
      case OverlayType.overlayEntry:
        return 'OverlayEntry';
      case OverlayType.overlayPortal:
        return 'OverlayPortal';
      case OverlayType.other:
        return 'Other';
    }
  }

  /// Get preferred color for visualizing this overlay type
  Color get color {
    switch (this) {
      case OverlayType.dialog:
        return const Color(0xFF9C27B0); // Purple
      case OverlayType.bottomSheet:
        return const Color(0xFF009688); // Teal
      case OverlayType.dropdown:
        return const Color(0xFFFFC107); // Amber
      case OverlayType.tooltip:
        return const Color(0xFFE91E63); // Pink
      case OverlayType.popupMenu:
        return const Color(0xFF3F51B5); // Indigo
      case OverlayType.overlayEntry:
        return const Color(0xFFFF5722); // Deep Orange
      case OverlayType.overlayPortal:
        return const Color(0xFF607D8B); // Blue Grey
      case OverlayType.other:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  /// Get icon data for this overlay type
  IconData get icon {
    switch (this) {
      case OverlayType.dialog:
        return Icons.message;
      case OverlayType.bottomSheet:
        return Icons.vertical_align_top;
      case OverlayType.dropdown:
        return Icons.arrow_drop_down;
      case OverlayType.tooltip:
        return Icons.info_outline;
      case OverlayType.popupMenu:
        return Icons.more_vert;
      case OverlayType.overlayEntry:
        return Icons.layers;
      case OverlayType.overlayPortal:
        return Icons.window;
      case OverlayType.other:
        return Icons.extension;
    }
  }

  /// Detect overlay type from a route if possible
  static OverlayType? fromRoute(Route<dynamic> route) {
    if (route is MaterialPageRoute || route is CupertinoPageRoute) {
      return OverlayType.dialog;
    }
    // Add more specific route type detections as needed
    return null;
  }
}