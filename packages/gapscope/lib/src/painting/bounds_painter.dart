import 'package:flutter/widgets.dart';
import '../capture/geometry_snapshot.dart';

/// Paints widget bounds for runtime inspection
class BoundsPainter {
  /// Paint bounds for a single snapshot
  static void paintBounds(
    Canvas canvas,
    GeometrySnapshot snapshot, {
    Color color = const Color(0xFF2196F3),
    double strokeWidth = 1.0,
    bool fill = false,
  }) {
    final bounds = snapshot.bounds;
    final paint = Paint()
      ..color = fill ? color.withAlpha(51) : color // 20% opacity for fill
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRect(bounds, paint);
  }

  /// Paint bounds for selected snapshot
  static void paintSelectedBounds(
    Canvas canvas,
    GeometrySnapshot snapshot, {
    Color color = const Color(0xFF2196F3),
    double strokeWidth = 2.0,
  }) {
    paintBounds(
      canvas,
      snapshot,
      color: color,
      strokeWidth: strokeWidth,
      fill: true,
    );
  }

  /// Paint bounds for multiple snapshots
  static void paintMultipleBounds(
    Canvas canvas,
    List<GeometrySnapshot> snapshots, {
    Color normalColor = const Color(0xFF2196F3),
    Color selectedColor = const Color(0xFF1976D2),
    String? selectedId,
  }) {
    for (final snapshot in snapshots) {
      if (!snapshot.visible) continue;

      final isSelected = selectedId != null && snapshot.id == selectedId;
      final color = isSelected ? selectedColor : normalColor;
      final strokeWidth = isSelected ? 2.0 : 1.0;

      paintBounds(
        canvas,
        snapshot,
        color: color,
        strokeWidth: strokeWidth,
        fill: isSelected,
      );
    }
  }

  /// Paint bounds with depth-based opacity
  static void paintBoundsWithDepth(
    Canvas canvas,
    List<GeometrySnapshot> snapshots, {
    Color baseColor = const Color(0xFF2196F3),
    int maxDepth = 10,
  }) {
    for (final snapshot in snapshots) {
      if (!snapshot.visible) continue;

      // Calculate opacity based on depth (deeper = more transparent)
      final depthFactor = 1.0 - (snapshot.depth / maxDepth).clamp(0.0, 1.0);
      final color = baseColor.withValues(alpha: baseColor.a * depthFactor);

      paintBounds(canvas, snapshot, color: color);
    }
  }

  /// Paint widget type label for snapshot
  static void paintWidgetLabel(
    Canvas canvas,
    GeometrySnapshot snapshot, {
    Color backgroundColor = const Color(0xFF2196F3),
    Color textColor = const Color(0xFFFFFFFF),
    double fontSize = 12.0,
  }) {
    final bounds = snapshot.bounds;
    final textPainter = TextPainter(
      text: TextSpan(
        text: _shortenWidgetType(snapshot.widgetType),
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Position label above bounds
    final labelPosition = Offset(
      bounds.left,
      bounds.top - textPainter.height - 4,
    );

    // Draw background
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        labelPosition.dx - 4,
        labelPosition.dy - 2,
        textPainter.width + 8,
        textPainter.height + 4,
      ),
      backgroundPaint,
    );

    // Draw text
    textPainter.paint(canvas, labelPosition);
  }

  /// Shorten widget type name for display
  static String _shortenWidgetType(String widgetType) {
    // Remove common prefixes and suffixes
    return widgetType
        .replaceAll('Render', '')
        .replaceAll('Widget', '')
        .replaceAll('_', '');
  }

  /// Paint corner handles for selected widget
  static void paintCornerHandles(
    Canvas canvas,
    GeometrySnapshot snapshot, {
    Color color = const Color(0xFF2196F3),
    double handleSize = 6.0,
  }) {
    final bounds = snapshot.bounds;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Top-left
    canvas.drawRect(
      Rect.fromLTWH(
        bounds.left - handleSize / 2,
        bounds.top - handleSize / 2,
        handleSize,
        handleSize,
      ),
      paint,
    );

    // Top-right
    canvas.drawRect(
      Rect.fromLTWH(
        bounds.right - handleSize / 2,
        bounds.top - handleSize / 2,
        handleSize,
        handleSize,
      ),
      paint,
    );

    // Bottom-left
    canvas.drawRect(
      Rect.fromLTWH(
        bounds.left - handleSize / 2,
        bounds.bottom - handleSize / 2,
        handleSize,
        handleSize,
      ),
      paint,
    );

    // Bottom-right
    canvas.drawRect(
      Rect.fromLTWH(
        bounds.right - handleSize / 2,
        bounds.bottom - handleSize / 2,
        handleSize,
        handleSize,
      ),
      paint,
    );
  }

  /// Paint size information for widget
  static void paintSizeInfo(
    Canvas canvas,
    GeometrySnapshot snapshot, {
    Color backgroundColor = const Color(0xAA000000),
    Color textColor = const Color(0xFFFFFFFF),
    double fontSize = 11.0,
  }) {
    final bounds = snapshot.bounds;
    final sizeText =
        '${snapshot.size.width.toInt()}×${snapshot.size.height.toInt()}';

    final textPainter = TextPainter(
      text: TextSpan(
        text: sizeText,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Position label at center of bounds
    final labelPosition = Offset(
      bounds.center.dx - textPainter.width / 2,
      bounds.center.dy - textPainter.height / 2,
    );

    // Draw background
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        labelPosition.dx - 4,
        labelPosition.dy - 2,
        textPainter.width + 8,
        textPainter.height + 4,
      ),
      backgroundPaint,
    );

    // Draw text
    textPainter.paint(canvas, labelPosition);
  }
}
