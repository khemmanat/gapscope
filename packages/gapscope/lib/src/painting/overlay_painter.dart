import 'package:flutter/material.dart';
import '../overlay/overlay_info.dart';
import '../overlay/overlay_type.dart';

/// Custom painter for overlay visualization
///
/// Renders overlay bounds with type-specific styling, including
/// dashed borders, semi-transparent fills, and overlay type labels.
class OverlayPainter extends CustomPainter {
  /// List of overlays to render
  final List<OverlayInfo> overlays;

  /// Currently selected overlay
  final OverlayInfo? selectedOverlay;

  /// Create overlay painter
  const OverlayPainter({
    required this.overlays,
    this.selectedOverlay,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final overlay in overlays) {
      _paintOverlay(canvas, overlay);
    }

    // Paint selection on top
    if (selectedOverlay != null) {
      _paintSelection(canvas, selectedOverlay!);
    }
  }

  /// Paint individual overlay
  void _paintOverlay(Canvas canvas, OverlayInfo overlay) {
    if (!overlay.isVisible) return;

    final bounds = overlay.bounds;
    final typeColor = overlay.type.color;

    // Draw semi-transparent fill
    canvas.drawRect(
      bounds,
      Paint()
        ..color = typeColor.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill,
    );

    // Draw dashed border
    _drawDashedBorder(
      canvas,
      bounds,
      typeColor.withValues(alpha: 0.7),
      2.0,
    );

    // Draw overlay label
    _drawOverlayLabel(canvas, overlay, typeColor);
  }

  /// Draw dashed border around overlay
  void _drawDashedBorder(Canvas canvas, Rect bounds, Color color, double strokeWidth) {
    final dashWidth = 8.0;
    final dashSpace = 4.0;
    final path = Path()..addRect(bounds);

    final dashPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final pathLength = pathMetric.length;
      double distance = 0.0;

      while (distance < pathLength) {
        final dashLength = distance + dashWidth;
        if (dashLength > pathLength) {
          canvas.drawPath(
            pathMetric.extractPath(distance, pathLength),
            dashPaint,
          );
        } else {
          canvas.drawPath(
            pathMetric.extractPath(distance, dashLength),
            dashPaint,
          );
        }
        distance += dashWidth + dashSpace;
      }
    }
  }

  /// Draw overlay type label
  void _drawOverlayLabel(Canvas canvas, OverlayInfo overlay, Color typeColor) {
    const labelPadding = 8.0;
    final labelText = '${overlay.type.displayName} - ${overlay.id}';
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: labelText, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final labelWidth = textPainter.width + labelPadding * 2;
    final labelHeight = textPainter.height + labelPadding * 2;

    final labelPosition = Offset(
      overlay.bounds.left + 8,
      overlay.bounds.top - labelHeight - 4,
    );

    // Draw label background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(labelPosition.dx, labelPosition.dy, labelWidth, labelHeight),
        const Radius.circular(4),
      ),
      Paint()..color = typeColor,
    );

    // Draw label text
    textPainter.paint(
      canvas,
      Offset(labelPosition.dx + labelPadding, labelPosition.dy + labelPadding),
    );
  }

  /// Paint selection highlight for selected overlay
  void _paintSelection(Canvas canvas, OverlayInfo overlay) {
    final bounds = overlay.bounds;
    const handleSize = 8.0;
    const cornerRadius = 4.0;

    // Draw enhanced selection border
    canvas.drawRRect(
      RRect.fromRectAndRadius(bounds, const Radius.circular(cornerRadius)),
      Paint()
        ..color = Colors.blue.withValues(alpha: 0.8)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke,
    );

    // Draw corner handles
    _drawCornerHandle(canvas, bounds.topLeft, handleSize);
    _drawCornerHandle(canvas, bounds.topRight, handleSize);
    _drawCornerHandle(canvas, bounds.bottomLeft, handleSize);
    _drawCornerHandle(canvas, bounds.bottomRight, handleSize);
  }

  /// Draw corner selection handle
  void _drawCornerHandle(Canvas canvas, Offset corner, double size) {
    canvas.drawCircle(
      corner,
      size / 2,
      Paint()..color = Colors.blue,
    );
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) {
    return oldDelegate.overlays != overlays ||
        oldDelegate.selectedOverlay != selectedOverlay;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OverlayPainter &&
        other.overlays == overlays &&
        other.selectedOverlay == selectedOverlay;
  }

  @override
  int get hashCode => Object.hash(overlays, selectedOverlay);
}