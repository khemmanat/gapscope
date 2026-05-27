import 'package:flutter/material.dart';
import '../capture/geometry_snapshot.dart';

/// Flex layout type enumeration
enum FlexType {
  row,
  column,
}

/// Gap type in flex layouts
enum GapType {
  spacing,
  padding,
  margin,
  explicit,
}

/// Individual gap between widgets in flex layout
class WidgetGap {

  const WidgetGap({
    required this.position,
    required this.size,
    required this.type,
    required this.value,
    this.description,
  });
  final Offset position;
  final Size size;
  final GapType type;
  final double value;
  final String? description;

  /// Get gap bounds
  Rect get bounds => Rect.fromLTWH(
    position.dx,
    position.dy,
    size.width,
    size.height,
  );

  /// Check if gap is significant (> 4px)
  bool get isSignificant => value > 4.0;
}

/// Flex layout issue or problem
class FlexIssue {

  const FlexIssue({
    required this.id,
    required this.type,
    required this.message,
    this.location,
    required this.severity,
  });
  final String id;
  final FlexIssueType type;
  final String message;
  final Rect? location;
  final Severity severity;
}

/// Flex issue types
enum FlexIssueType {
  inconsistentSpacing,
  overflow,
  unevenDistribution,
  negativeSpace,
  constraintViolation,
}

/// Issue severity levels
enum Severity {
  info,
  warning,
  error,
}

/// Complete flex layout analysis
class FlexGap {

  const FlexGap({
    required this.id,
    required this.flexType,
    required this.gaps,
    required this.issues,
    required this.bounds,
    this.parentId,
  });
  final String id;
  final FlexType flexType;
  final List<WidgetGap> gaps;
  final List<FlexIssue> issues;
  final Rect bounds;
  final String? parentId;

  /// Get total gap space
  double get totalGapSpace {
    return gaps.fold(0.0, (sum, gap) => sum + gap.value);
  }

  /// Get significant gaps only
  List<WidgetGap> get significantGaps {
    return gaps.where((gap) => gap.isSignificant).toList();
  }

  /// Get critical issues
  List<FlexIssue> get criticalIssues {
    return issues.where((issue) => issue.severity != Severity.info).toList();
  }

  /// Check if layout has issues
  bool get hasIssues => criticalIssues.isNotEmpty;

  /// Create flex gap from snapshot analysis
  static FlexGap? fromSnapshots(
    List<GeometrySnapshot> snapshots,
    String parentId,
  ) {
    // Find flex parent
    final parent = snapshots.cast<GeometrySnapshot?>().firstWhere(
      (snapshot) => snapshot?.id == parentId,
      orElse: () => null,
    );

    if (parent == null) return null;

    // Determine flex type from widget type
    final flexType = _determineFlexType(parent.widgetType);
    if (flexType == null) return null;

    // Analyze children for gaps
    final children = snapshots.where((snapshot) =>
      snapshot.visible &&
      parent.bounds.contains(snapshot.bounds.center),
    ).toList();

    final gaps = _analyzeGaps(children, flexType);
    final issues = _detectIssues(children, gaps, flexType);

    return FlexGap(
      id: 'flex_$parentId',
      flexType: flexType,
      gaps: gaps,
      issues: issues,
      bounds: parent.bounds,
      parentId: parentId,
    );
  }

  static FlexType? _determineFlexType(String widgetType) {
    final lowerType = widgetType.toLowerCase();
    if (lowerType.contains('row')) return FlexType.row;
    if (lowerType.contains('column')) return FlexType.column;
    return null;
  }

  static List<WidgetGap> _analyzeGaps(
    List<GeometrySnapshot> children,
    FlexType flexType,
  ) {
    final gaps = <WidgetGap>[];

    if (children.length < 2) return gaps;

    // Sort children based on flex direction
    final sortedChildren = List<GeometrySnapshot>.from(children);
    if (flexType == FlexType.row) {
      sortedChildren.sort((a, b) => a.bounds.left.compareTo(b.bounds.left));
    } else {
      sortedChildren.sort((a, b) => a.bounds.top.compareTo(b.bounds.top));
    }

    // Calculate gaps between consecutive children
    for (int i = 0; i < sortedChildren.length - 1; i++) {
      final current = sortedChildren[i];
      final next = sortedChildren[i + 1];

      final gap = _calculateGap(current, next, flexType, i);
      if (gap != null && gap.isSignificant) {
        gaps.add(gap);
      }
    }

    return gaps;
  }

  static WidgetGap? _calculateGap(
    GeometrySnapshot current,
    GeometrySnapshot next,
    FlexType flexType,
    int index,
  ) {
    double gapValue;
    Offset position;
    Size size;

    if (flexType == FlexType.row) {
      gapValue = next.bounds.left - current.bounds.right;
      if (gapValue <= 0) return null;

      position = Offset(current.bounds.right, current.bounds.top);
      size = Size(gapValue, current.bounds.height);
    } else {
      gapValue = next.bounds.top - current.bounds.bottom;
      if (gapValue <= 0) return null;

      position = Offset(current.bounds.left, current.bounds.bottom);
      size = Size(current.bounds.width, gapValue);
    }

    return WidgetGap(
      position: position,
      size: size,
      type: GapType.spacing,
      value: gapValue,
      description: 'Gap $index',
    );
  }

  static List<FlexIssue> _detectIssues(
    List<GeometrySnapshot> children,
    List<WidgetGap> gaps,
    FlexType flexType,
  ) {
    final issues = <FlexIssue>[];

    // Check for inconsistent spacing
    if (gaps.length >= 2) {
      final gapValues = gaps.map((gap) => gap.value).toList();
      final uniqueValues = gapValues.toSet();

      if (uniqueValues.length > 1) {
        final variance = _calculateVariance(gapValues);
        if (variance > 4.0) {
          issues.add(FlexIssue(
            id: 'inconsistent_spacing',
            type: FlexIssueType.inconsistentSpacing,
            message: 'Inconsistent spacing detected (${variance.toStringAsFixed(1)}px variance)',
            severity: Severity.warning,
          ),);
        }
      }
    }

    // Check for overflow
    for (final child in children) {
      if (child.bounds.width < 0 || child.bounds.height < 0) {
        issues.add(FlexIssue(
          id: 'overflow_${child.id}',
          type: FlexIssueType.overflow,
          message: 'Overflow detected in ${child.widgetType}',
          location: child.bounds,
          severity: Severity.error,
        ),);
      }
    }

    return issues;
  }

  static double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;
    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => (v - mean) * (v - mean));
    return squaredDiffs.reduce((a, b) => a + b) / values.length;
  }
}