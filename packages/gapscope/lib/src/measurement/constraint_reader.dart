import 'package:flutter/material.dart';
import '../capture/geometry_snapshot.dart';

/// Constraint information for render objects
class ConstraintInfo {

  const ConstraintInfo({
    required this.id,
    required this.constraints,
    required this.actualSize,
    required this.isTight,
    required this.isBounded,
    required this.widgetType,
  });
  final String id;
  final BoxConstraints constraints;
  final Size actualSize;
  final bool isTight;
  final bool isBounded;
  final String widgetType;

  /// Check if widget respects constraints
  bool get respectsConstraints {
    if (constraints.hasBoundedWidth && actualSize.width > constraints.maxWidth) {
      return false;
    }
    if (constraints.hasBoundedHeight && actualSize.height > constraints.maxHeight) {
      return false;
    }
    return true;
  }

  /// Get constraint violation details
  String? getViolationDetails() {
    if (!respectsConstraints) {
      if (constraints.hasBoundedWidth && actualSize.width > constraints.maxWidth) {
        return 'Width violation: ${actualSize.width} > ${constraints.maxWidth}';
      }
      if (constraints.hasBoundedHeight && actualSize.height > constraints.maxHeight) {
        return 'Height violation: ${actualSize.height} > ${constraints.maxHeight}';
      }
    }
    return null;
  }

  /// Calculate constraint slack
  double get widthSlack {
    if (!constraints.hasBoundedWidth) return double.infinity;
    return constraints.maxWidth - actualSize.width;
  }

  double get heightSlack {
    if (!constraints.hasBoundedHeight) return double.infinity;
    return constraints.maxHeight - actualSize.height;
  }

  /// Create constraint info from snapshot (mock implementation)
  static ConstraintInfo? fromSnapshot(GeometrySnapshot snapshot) {
    // In real implementation, would access render object's constraints
    // For now, create inferred constraints from actual size
    final actualSize = Size(snapshot.bounds.width, snapshot.bounds.height);

    // Create tight constraints (widget determines its own size)
    final constraints = BoxConstraints.tight(actualSize);

    return ConstraintInfo(
      id: snapshot.id,
      constraints: constraints,
      actualSize: actualSize,
      isTight: true,
      isBounded: true,
      widgetType: snapshot.widgetType,
    );
  }
}

/// Constraint reader for Flutter layout analysis
class ConstraintReader {
  /// Read constraints from geometry snapshots
  static List<ConstraintInfo> readConstraints(
    List<GeometrySnapshot> snapshots,
  ) {
    final constraints = <ConstraintInfo>[];

    for (final snapshot in snapshots) {
      if (!snapshot.visible) continue;

      final constraint = ConstraintInfo.fromSnapshot(snapshot);
      if (constraint != null) {
        constraints.add(constraint);
      }
    }

    return constraints;
  }

  /// Find constraint violations
  static List<ConstraintInfo> findViolations(
    List<ConstraintInfo> constraints,
  ) {
    return constraints.where((constraint) =>
      !constraint.respectsConstraints,
    ).toList();
  }

  /// Get constraint statistics
  static Map<String, dynamic> getStatistics(
    List<ConstraintInfo> constraints,
  ) {
    int tightCount = 0;
    int looseCount = 0;
    int unboundedCount = 0;
    int violationCount = 0;

    for (final constraint in constraints) {
      if (constraint.isTight) {
        tightCount++;
      } else {
        looseCount++;
      }

      if (!constraint.isBounded) unboundedCount++;
      if (!constraint.respectsConstraints) violationCount++;
    }

    return {
      'total': constraints.length,
      'tight': tightCount,
      'loose': looseCount,
      'unbounded': unboundedCount,
      'violations': violationCount,
      'compliance_rate': constraints.isEmpty
          ? 1.0
          : (constraints.length - violationCount) / constraints.length,
    };
  }

  /// Get widgets with unbounded constraints
  static List<ConstraintInfo> getUnboundedConstraints(
    List<ConstraintInfo> constraints,
  ) {
    return constraints.where((constraint) =>
      !constraint.isBounded,
    ).toList();
  }

  /// Get widgets with tight constraints
  static List<ConstraintInfo> getTightConstraints(
    List<ConstraintInfo> constraints,
  ) {
    return constraints.where((constraint) =>
      constraint.isTight,
    ).toList();
  }

  /// Analyze constraint patterns
  static Map<String, int> analyzePatterns(
    List<ConstraintInfo> constraints,
  ) {
    final patterns = <String, int>{
      'tight_fixed': 0,
      'tight_loose': 0,
      'loose_bounded': 0,
      'loose_unbounded': 0,
    };

    for (final constraint in constraints) {
      if (constraint.isTight) {
        if (constraint.constraints.hasBoundedWidth &&
            constraint.constraints.hasBoundedHeight) {
          patterns['tight_fixed'] = patterns['tight_fixed']! + 1;
        } else {
          patterns['tight_loose'] = patterns['tight_loose']! + 1;
        }
      } else {
        if (constraint.isBounded) {
          patterns['loose_bounded'] = patterns['loose_bounded']! + 1;
        } else {
          patterns['loose_unbounded'] = patterns['loose_unbounded']! + 1;
        }
      }
    }

    return patterns;
  }
}