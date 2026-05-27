import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../capture/geometry_snapshot.dart';
import '../measurement/measurement_engine.dart';

/// Paints spacing gaps and distance measurements
class GapPainter {
  /// Paint spacing distance between two snapshots
  static void paintSpacingDistance(
    Canvas canvas,
    SpacingDistance distance, {
    Color lineColor = const Color(0xFF4CAF50),
    Color textColor = const Color(0xFF4CAF50),
    double strokeWidth = 1.5,
    bool showLabel = true,
  }) {
    if (!distance.isMeaningful) return;

    // Draw dimension line
    _drawDimensionLine(
      canvas,
      distance.from,
      distance.to,
      lineColor,
      strokeWidth,
    );

    // Draw distance label
    if (showLabel) {
      _drawDistanceLabel(
        canvas,
        distance.from,
        distance.to,
        distance.formatted,
        textColor,
      );
    }
  }

  /// Draw dimension line with arrows
  static void _drawDimensionLine(
    Canvas canvas,
    Offset from,
    Offset to,
    Color color,
    double strokeWidth,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw main line
    canvas.drawLine(from, to, paint);

    // Draw arrowheads
    _drawArrowHead(canvas, from, to, paint);
    _drawArrowHead(canvas, to, from, paint);
  }

  /// Draw arrow head at end of line
  static void _drawArrowHead(
    Canvas canvas,
    Offset tip,
    Offset from,
    Paint paint,
  ) {
    const arrowSize = 8.0;
    final direction = (tip - from).direction;
    final angle = direction;

    // Calculate arrow points
    final arrowPoint1 = Offset(
      tip.dx - arrowSize * cos(angle + 2.6),
      tip.dy - arrowSize * sin(angle + 2.6),
    );

    final arrowPoint2 = Offset(
      tip.dx - arrowSize * cos(angle - 2.6),
      tip.dy - arrowSize * sin(angle - 2.6),
    );

    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..close();

    final arrowPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, arrowPaint);
  }

  /// Draw distance label centered on line
  static void _drawDistanceLabel(
    Canvas canvas,
    Offset from,
    Offset to,
    String text,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Calculate center position
    final center = Offset(
      (from.dx + to.dx) / 2,
      (from.dy + to.dy) / 2,
    );

    final labelPosition = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    // Draw background for readability
    final bgPaint = Paint()
      ..color = const Color(0xCCFFFFFF)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        labelPosition.dx - 3,
        labelPosition.dy - 2,
        textPainter.width + 6,
        textPainter.height + 4,
      ),
      bgPaint,
    );

    // Draw text
    textPainter.paint(canvas, labelPosition);
  }

  /// Paint parent-child spacing with special styling
  static void paintParentChildSpacing(
    Canvas canvas,
    SpacingDistance distance, {
    Color lineColor = const Color(0xFF4CAF50),
    Color textColor = const Color(0xFF4CAF50),
  }) {
    if (!distance.isMeaningful) return;

    paintSpacingDistance(
      canvas,
      distance,
      lineColor: lineColor,
      textColor: textColor,
      strokeWidth: 2.0,
      showLabel: true,
    );
  }

  /// Paint sibling spacing with special styling
  static void paintSiblingSpacing(
    Canvas canvas,
    SpacingDistance distance, {
    Color lineColor = const Color(0xFFFF9800),
    Color textColor = const Color(0xFFFF9800),
  }) {
    if (!distance.isMeaningful) return;

    paintSpacingDistance(
      canvas,
      distance,
      lineColor: lineColor,
      textColor: textColor,
      strokeWidth: 1.5,
      showLabel: true,
    );
  }

  /// Paint all distances for a snapshot
  static void paintAllDistances(
    Canvas canvas,
    List<SpacingDistance> distances, {
    bool showParentChild = true,
    bool showSiblings = true,
  }) {
    for (final distance in distances) {
      if (!distance.isMeaningful) continue;

      switch (distance.type) {
        case SpacingType.parentChild:
          if (showParentChild) {
            paintParentChildSpacing(canvas, distance);
          }
          break;
        case SpacingType.sibling:
          if (showSiblings) {
            paintSiblingSpacing(canvas, distance);
          }
          break;
        default:
          paintSpacingDistance(canvas, distance);
      }
    }
  }

  /// Paint spacing indicator for overlapping widgets
  static void paintOverlapIndicator(
    Canvas canvas,
    GeometrySnapshot snapshot1,
    GeometrySnapshot snapshot2, {
    Color color = const Color(0xFFF44336),
    double patternSize = 4.0,
  }) {
    if (!snapshot1.intersects(snapshot2)) return;

    final intersection = snapshot1.bounds.intersect(snapshot2.bounds);
    if (intersection.isEmpty) return;

    // Draw hatched pattern
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double x = intersection.left; x < intersection.right; x += patternSize * 2) {
      canvas.drawLine(
        Offset(x, intersection.top),
        Offset(x + patternSize, intersection.bottom),
        paint,
      );
    }
  }

  /// Paint spacing guides (extension lines)
  static void paintSpacingGuides(
    Canvas canvas,
    GeometrySnapshot snapshot1,
    GeometrySnapshot snapshot2, {
    Color guideColor = const Color(0xFF9E9E9E),
    double strokeWidth = 1.0,
    double guideExtension = 10.0,
  }) {
    final paint = Paint()
      ..color = guideColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw extension lines from bounds
    final bounds1 = snapshot1.bounds;
    final bounds2 = snapshot2.bounds;

    // Horizontal guides
    if (bounds1.right < bounds2.left) {
      // Right edge of snapshot1 to left edge of snapshot2
      canvas.drawLine(
        Offset(bounds1.right, bounds1.center.dy),
        Offset(bounds1.right + guideExtension, bounds1.center.dy),
        paint,
      );
      canvas.drawLine(
        Offset(bounds2.left - guideExtension, bounds2.center.dy),
        Offset(bounds2.left, bounds2.center.dy),
        paint,
      );
    }

    // Vertical guides
    if (bounds1.bottom < bounds2.top) {
      // Bottom edge of snapshot1 to top edge of snapshot2
      canvas.drawLine(
        Offset(bounds1.center.dx, bounds1.bottom),
        Offset(bounds1.center.dx, bounds1.bottom + guideExtension),
        paint,
      );
      canvas.drawLine(
        Offset(bounds2.center.dx, bounds2.top - guideExtension),
        Offset(bounds2.center.dx, bounds2.top),
        paint,
      );
    }
  }

  /// Calculate optimal label position to avoid overlap
  static Offset calculateLabelPosition(Offset from, Offset to, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 11.0),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Default to midpoint
    return Offset(
      (from.dx + to.dx) / 2 - textPainter.width / 2,
      (from.dy + to.dy) / 2 - textPainter.height / 2 - 20, // Offset slightly upward
    );
  }

  /// Helper function for cosine
  static double cos(double angle) => _cos(angle);

  /// Helper function for sine
  static double sin(double angle) => _sin(angle);

  static double _cos(double angle) {
    // Simple cosine approximation
    return 1.0 - angle * angle / 2.0;
  }

  static double _sin(double angle) {
    // Simple sine approximation
    return angle;
  }
}