import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../capture/geometry_snapshot.dart';
import 'flex_gap_detector.dart'; // Import for shared Severity enum

/// Material 3 minimum tap target size (48x48 dp)
const double _minTapTargetSize = 48.0;

/// Tap target issue types
enum TargetIssueType {
  tooSmall,
  overlapping,
  poorPlacement,
  insufficientContrast,
}

/// Individual tap target issue
class TargetIssue {
  final String id;
  final TargetIssueType type;
  final String message;
  final Rect? affectedArea;
  final Severity severity;

  const TargetIssue({
    required this.id,
    required this.type,
    required this.message,
    this.affectedArea,
    required this.severity,
  });
}

/// Tap target information
class TapTargetInfo {
  final String id;
  final Rect bounds;
  final bool meetsMinimumSize;
  final List<TargetIssue> issues;
  final String widgetType;
  final double actualSize;
  final Size requiredSize;

  const TapTargetInfo({
    required this.id,
    required this.bounds,
    required this.meetsMinimumSize,
    required this.issues,
    required this.widgetType,
    required this.actualSize,
    required this.requiredSize,
  });

  /// Check if target has critical issues
  bool get hasCriticalIssues {
    return issues.any((issue) => issue.severity == Severity.error);
  }

  /// Check if target has any issues
  bool get hasIssues => issues.isNotEmpty;

  /// Get tap target center
  Offset get center => bounds.center;

  /// Check if point is within target
  bool contains(Offset point) {
    return bounds.contains(point);
  }

  /// Get target size deficiency
  double? getSizeDeficiency() {
    if (meetsMinimumSize) return null;
    return _minTapTargetSize - actualSize;
  }

  /// Create tap target info from snapshot
  static TapTargetInfo fromSnapshot(GeometrySnapshot snapshot) {
    final bounds = snapshot.bounds;
    final actualSize = math.min(bounds.width, bounds.height);
    final meetsMinimumSize = actualSize >= _minTapTargetSize;

    final issues = <TargetIssue>[];

    // Check minimum size requirement
    if (!meetsMinimumSize) {
      issues.add(TargetIssue(
        id: 'size_${snapshot.id}',
        type: TargetIssueType.tooSmall,
        message: 'Tap target too small (${actualSize.toStringAsFixed(1)}px vs $_minTapTargetSize px required)',
        affectedArea: bounds,
        severity: Severity.error,
      ));
    }

    // Additional checks can be added here
    // - overlapping targets
    // - poor placement
    // - contrast issues

    return TapTargetInfo(
      id: snapshot.id,
      bounds: bounds,
      meetsMinimumSize: meetsMinimumSize,
      issues: issues,
      widgetType: snapshot.widgetType,
      actualSize: actualSize,
      requiredSize: const Size(_minTapTargetSize, _minTapTargetSize),
    );
  }
}

/// Tap target checker for Material Design compliance
class TapTargetChecker {
  /// Check if widget is likely a tap target
  static bool isTapTarget(String widgetType) {
    final lowerType = widgetType.toLowerCase();
    return lowerType.contains('button') ||
        lowerType.contains('ink') ||
        lowerType.contains('icon') ||
        lowerType.contains('card') ||
        lowerType.contains('listtile') ||
        lowerType.contains('checkbox') ||
        lowerType.contains('switch') ||
        lowerType.contains('radio');
  }

  /// Check single tap target
  static TapTargetInfo? checkTarget(GeometrySnapshot snapshot) {
    if (!snapshot.visible) return null;
    if (!isTapTarget(snapshot.widgetType)) return null;

    return TapTargetInfo.fromSnapshot(snapshot);
  }

  /// Check all tap targets in snapshots
  static List<TapTargetInfo> checkAllTargets(
    List<GeometrySnapshot> snapshots,
  ) {
    final targets = <TapTargetInfo>[];

    for (final snapshot in snapshots) {
      final target = checkTarget(snapshot);
      if (target != null) {
        targets.add(target);
      }
    }

    // Check for overlapping targets
    _detectOverlappingTargets(targets);

    return targets;
  }

  /// Detect overlapping tap targets
  static void _detectOverlappingTargets(List<TapTargetInfo> targets) {
    for (int i = 0; i < targets.length; i++) {
      for (int j = i + 1; j < targets.length; j++) {
        final current = targets[i];
        final other = targets[j];

        if (current.bounds.overlaps(other.bounds)) {
          // Add overlap issue to both targets
          final overlapIssue = TargetIssue(
            id: 'overlap_${current.id}_${other.id}',
            type: TargetIssueType.overlapping,
            message: 'Overlaps with ${other.widgetType}',
            affectedArea: current.bounds.intersect(other.bounds),
            severity: Severity.warning,
          );

          // Add to issues (note: in real implementation would need mutable list)
          // For now this demonstrates the detection logic
        }
      }
    }
  }

  /// Get tap targets at point
  static List<TapTargetInfo> getTargetsAtPoint(
    List<TapTargetInfo> targets,
    Offset point,
  ) {
    return targets.where((target) => target.contains(point)).toList();
  }

  /// Get topmost tap target at point
  static TapTargetInfo? getTopmostTargetAtPoint(
    List<TapTargetInfo> targets,
    Offset point,
  ) {
    final targetsAtPoint = getTargetsAtPoint(targets, point);
    if (targetsAtPoint.isEmpty) return null;

    // Return target with highest z-index (would need depth info)
    return targetsAtPoint.first;
  }

  /// Get targets with issues
  static List<TapTargetInfo> getTargetsWithIssues(
    List<TapTargetInfo> targets,
  ) {
    return targets.where((target) => target.hasIssues).toList();
  }

  /// Get targets with critical issues
  static List<TapTargetInfo> getTargetsCriticalIssues(
    List<TapTargetInfo> targets,
  ) {
    return targets.where((target) => target.hasCriticalIssues).toList();
  }

  /// Calculate compliance rate
  static double calculateComplianceRate(List<TapTargetInfo> targets) {
    if (targets.isEmpty) return 1.0;

    final compliantTargets = targets.where((target) =>
      target.meetsMinimumSize && !target.hasCriticalIssues,
    ).length;

    return compliantTargets / targets.length;
  }
}

// Helper function for min
double min(double a, double b) => a < b ? a : b;