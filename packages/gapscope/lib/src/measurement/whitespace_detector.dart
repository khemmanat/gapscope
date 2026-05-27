import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../capture/geometry_snapshot.dart';

/// Whitespace type classification
enum WhitespaceType {
  padding,
  margin,
  empty,
  spacing,
}

/// Detected whitespace region in UI
class WhitespaceRegion {
  final String id;
  final Rect bounds;
  final WhitespaceType type;
  final double area;
  final String? source;
  final String? parentId;

  const WhitespaceRegion({
    required this.id,
    required this.bounds,
    required this.type,
    required this.area,
    this.source,
    this.parentId,
  });

  /// Check if whitespace is excessive (> 25% of parent area)
  bool isExcessive(double parentArea) {
    return area > (parentArea * 0.25);
  }

  /// Get whitespace center point
  Offset get center => bounds.center;

  /// Check if point is within this whitespace region
  bool contains(Offset point) {
    return bounds.contains(point);
  }

  /// Create whitespace region from bounds and type
  factory WhitespaceRegion.fromBounds(
    Rect bounds,
    WhitespaceType type,
    String source,
  ) {
    return WhitespaceRegion(
      id: 'whitespace_${bounds.hashCode}_$type',
      bounds: bounds,
      type: type,
      area: bounds.width * bounds.height,
      source: source,
    );
  }

  /// Calculate area ratio relative to parent
  double areaRatio(double parentArea) {
    if (parentArea <= 0) return 0.0;
    return area / parentArea;
  }
}

/// Whitespace detection result
class WhitespaceAnalysis {
  final List<WhitespaceRegion> regions;
  final double totalWhitespace;
  final double totalArea;
  final Map<WhitespaceType, double> typeDistribution;

  const WhitespaceAnalysis({
    required this.regions,
    required this.totalWhitespace,
    required this.totalArea,
    required this.typeDistribution,
  });

  /// Get whitespace percentage
  double get whitespacePercentage {
    if (totalArea <= 0) return 0.0;
    return (totalWhitespace / totalArea) * 100;
  }

  /// Get regions by type
  List<WhitespaceRegion> getRegionsByType(WhitespaceType type) {
    return regions.where((region) => region.type == type).toList();
  }

  /// Get excessive whitespace regions
  List<WhitespaceRegion> getExcessiveRegions() {
    return regions.where((region) =>
      region.isExcessive(totalArea / regions.length),
    ).toList();
  }

  /// Create analysis from detected regions
  factory WhitespaceAnalysis.fromRegions(
    List<WhitespaceRegion> detectedRegions,
    double totalAnalysisArea,
  ) {
    final totalSpace = detectedRegions.fold(
      0.0,
      (sum, region) => sum + region.area,
    );

    final distribution = <WhitespaceType, double>{};
    for (final region in detectedRegions) {
      distribution[region.type] =
        (distribution[region.type] ?? 0.0) + region.area;
    }

    return WhitespaceAnalysis(
      regions: detectedRegions,
      totalWhitespace: totalSpace,
      totalArea: totalAnalysisArea,
      typeDistribution: distribution,
    );
  }
}

/// Whitespace detector for Flutter UI analysis
class WhitespaceDetector {
  /// Minimum whitespace area to detect (in pixels)
  static const double minWhitespaceArea = 100.0;

  /// Minimum whitespace dimension to detect (in pixels)
  static const double minWhitespaceDimension = 10.0;

  /// Detect whitespace regions in snapshot list
  static WhitespaceAnalysis detectWhitespace(
    List<GeometrySnapshot> snapshots,
  ) {
    final regions = <WhitespaceRegion>[];
    double totalArea = 0.0;

    // Calculate total area from visible snapshots
    for (final snapshot in snapshots) {
      if (snapshot.visible) {
        totalArea += snapshot.bounds.width * snapshot.bounds.height;
      }
    }

    // Detect empty spaces between widgets
    regions.addAll(_detectInterWidgetGaps(snapshots));

    // Detect padding regions
    regions.addAll(_detectPaddingRegions(snapshots));

    // Detect margin regions
    regions.addAll(_detectMarginRegions(snapshots));

    return WhitespaceAnalysis.fromRegions(regions, totalArea);
  }

  /// Detect gaps between widgets
  static List<WhitespaceRegion> _detectInterWidgetGaps(
    List<GeometrySnapshot> snapshots,
  ) {
    final gaps = <WhitespaceRegion>[];

    final visibleSnapshots = snapshots.where((s) => s.visible).toList();

    for (int i = 0; i < visibleSnapshots.length - 1; i++) {
      final current = visibleSnapshots[i];
      final next = visibleSnapshots[i + 1];

      // Calculate gap bounds
      final gapBounds = _calculateGapBounds(current, next);
      if (gapBounds != null) {
        final region = WhitespaceRegion.fromBounds(
          gapBounds,
          WhitespaceType.spacing,
          'Gap between ${current.widgetType} and ${next.widgetType}',
        );
        gaps.add(region);
      }
    }

    return gaps;
  }

  /// Calculate gap bounds between two widgets
  static Rect? _calculateGapBounds(
    GeometrySnapshot current,
    GeometrySnapshot next,
  ) {
    // Check for horizontal gap
    if (next.bounds.left > current.bounds.right) {
      final gapWidth = next.bounds.left - current.bounds.right;
      if (gapWidth >= minWhitespaceDimension) {
        final verticalOverlap = _calculateVerticalOverlap(current, next);
        if (verticalOverlap > minWhitespaceDimension) {
          return Rect.fromLTWH(
            current.bounds.right,
            verticalOverlap > 0
              ? math.max(current.bounds.top, next.bounds.top)
              : current.bounds.top,
            gapWidth,
            verticalOverlap > 0 ? verticalOverlap : minWhitespaceDimension,
          );
        }
      }
    }

    // Check for vertical gap
    if (next.bounds.top > current.bounds.bottom) {
      final gapHeight = next.bounds.top - current.bounds.bottom;
      if (gapHeight >= minWhitespaceDimension) {
        final horizontalOverlap = _calculateHorizontalOverlap(current, next);
        if (horizontalOverlap > minWhitespaceDimension) {
          return Rect.fromLTWH(
            horizontalOverlap > 0
              ? math.max(current.bounds.left, next.bounds.left)
              : current.bounds.left,
            current.bounds.bottom,
            horizontalOverlap > 0 ? horizontalOverlap : minWhitespaceDimension,
            gapHeight,
          );
        }
      }
    }

    return null;
  }

  /// Calculate vertical overlap between two widgets
  static double _calculateVerticalOverlap(
    GeometrySnapshot current,
    GeometrySnapshot next,
  ) {
    final top = math.max(current.bounds.top, next.bounds.top);
    final bottom = math.min(current.bounds.bottom, next.bounds.bottom);
    return math.max(0.0, bottom - top);
  }

  /// Calculate horizontal overlap between two widgets
  static double _calculateHorizontalOverlap(
    GeometrySnapshot current,
    GeometrySnapshot next,
  ) {
    final left = math.max(current.bounds.left, next.bounds.left);
    final right = math.min(current.bounds.right, next.bounds.right);
    return math.max(0.0, right - left);
  }

  /// Detect padding regions around widgets
  static List<WhitespaceRegion> _detectPaddingRegions(
    List<GeometrySnapshot> snapshots,
  ) {
    final paddingRegions = <WhitespaceRegion>[];

    for (final snapshot in snapshots) {
      if (!snapshot.visible) continue;

      // Check for internal padding in containers
      if (_isContainerWidget(snapshot.widgetType)) {
        final children = snapshots.where((child) =>
          child.visible &&
          snapshot.bounds.contains(child.bounds.center) &&
          child.id != snapshot.id,
        ).toList();

        if (children.isNotEmpty) {
          final paddingBounds = _calculatePaddingBounds(snapshot, children);
          if (paddingBounds != null) {
            paddingRegions.add(WhitespaceRegion.fromBounds(
              paddingBounds,
              WhitespaceType.padding,
              'Padding in ${snapshot.widgetType}',
            ));
          }
        }
      }
    }

    return paddingRegions;
  }

  /// Check if widget is a container type
  static bool _isContainerWidget(String widgetType) {
    final lowerType = widgetType.toLowerCase();
    return lowerType.contains('container') ||
        lowerType.contains('padding') ||
        lowerType.contains('card') ||
        lowerType.contains('scaffold');
  }

  /// Calculate padding bounds within a container
  static Rect? _calculatePaddingBounds(
    GeometrySnapshot container,
    List<GeometrySnapshot> children,
  ) {
    if (children.isEmpty) return null;

    // Find bounds of all children
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final child in children) {
      minX = math.min(minX, child.bounds.left);
      minY = math.min(minY, child.bounds.top);
      maxX = math.max(maxX, child.bounds.right);
      maxY = math.max(maxY, child.bounds.bottom);
    }

    // Calculate padding as space between container and content bounds
    final topPadding = minY - container.bounds.top;
    final leftPadding = minX - container.bounds.left;
    final bottomPadding = container.bounds.bottom - maxY;
    final rightPadding = container.bounds.right - maxX;

    // Check if any significant padding exists
    if (topPadding > minWhitespaceDimension) {
      return Rect.fromLTWH(
        container.bounds.left,
        container.bounds.top,
        container.bounds.width,
        topPadding,
      );
    }

    if (leftPadding > minWhitespaceDimension) {
      return Rect.fromLTWH(
        container.bounds.left,
        container.bounds.top,
        leftPadding,
        container.bounds.height,
      );
    }

    return null;
  }

  /// Detect margin regions around widgets
  static List<WhitespaceRegion> _detectMarginRegions(
    List<GeometrySnapshot> snapshots,
  ) {
    final marginRegions = <WhitespaceRegion>[];

    // Find potential margin regions by looking for empty space
    // around widgets that aren't padding or spacing
    for (final snapshot in snapshots) {
      if (!snapshot.visible) continue;

      // Check if widget has significant margin
      final marginRegion = _detectWidgetMargins(snapshot, snapshots);
      if (marginRegion != null) {
        marginRegions.add(marginRegion);
      }
    }

    return marginRegions;
  }

  /// Detect margin regions around a specific widget
  static WhitespaceRegion? _detectWidgetMargins(
    GeometrySnapshot widget,
    List<GeometrySnapshot> allSnapshots,
  ) {
    // Check for empty space around widget
    final surroundingWidgets = allSnapshots.where((other) =>
      other.visible &&
      other.id != widget.id &&
      widget.bounds.inflate(20).overlaps(other.bounds),
    ).toList();

    if (surroundingWidgets.isEmpty) {
      // Widget is isolated, potential margin region
      final marginBounds = widget.bounds.inflate(16);
      return WhitespaceRegion.fromBounds(
        marginBounds,
        WhitespaceType.margin,
        'Margin around ${widget.widgetType}',
      );
    }

    return null;
  }
}

// Helper functions are now replaced with dart:math imports