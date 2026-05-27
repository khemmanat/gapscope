import 'package:flutter/material.dart';
import '../measurement/flex_gap_detector.dart';

/// Custom painter for flex layout visualization
///
/// Renders flex layouts with axis indicators, gap highlights,
/// and issue warnings for comprehensive layout analysis.
class FlexPainter extends CustomPainter {
  /// Flex layouts to visualize
  final List<FlexGap> flexLayouts;

  /// Currently selected flex layout
  final FlexGap? selectedFlex;

  /// Create flex painter
  const FlexPainter({
    required this.flexLayouts,
    this.selectedFlex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final flexLayout in flexLayouts) {
      _paintFlexLayout(canvas, flexLayout);
    }

    // Paint selection on top
    if (selectedFlex != null) {
      _paintSelection(canvas, selectedFlex!);
    }
  }

  /// Paint individual flex layout
  void _paintFlexLayout(Canvas canvas, FlexGap flexLayout) {
    _paintFlexBounds(canvas, flexLayout);
    _paintFlexAxes(canvas, flexLayout);
    _paintFlexGaps(canvas, flexLayout);
    _paintFlexIssues(canvas, flexLayout);
  }

  /// Paint flex layout bounds
  void _paintFlexBounds(Canvas canvas, FlexGap flexLayout) {
    final bounds = flexLayout.bounds;

    // Draw semi-transparent background
    canvas.drawRect(
      bounds,
      Paint()
        ..color = Colors.blue.withValues(alpha: 0.05)
        ..style = PaintingStyle.fill,
    );

    // Draw border
    canvas.drawRect(
      bounds,
      Paint()
        ..color = Colors.blue.withValues(alpha: 0.3)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );
  }

  /// Paint flex axes indicators
  void _paintFlexAxes(Canvas canvas, FlexGap flexLayout) {
    final bounds = flexLayout.bounds;

    if (flexLayout.flexType == FlexType.row) {
      // Draw horizontal main axis
      _drawArrow(
        canvas,
        bounds.centerLeft - const Offset(10, 0),
        bounds.centerRight + const Offset(10, 0),
        Colors.blue,
      );
    } else {
      // Draw vertical main axis
      _drawArrow(
        canvas,
        bounds.topCenter - const Offset(0, 10),
        bounds.bottomCenter + const Offset(0, 10),
        Colors.blue,
      );
    }
  }

  /// Paint flex gaps between widgets
  void _paintFlexGaps(Canvas canvas, FlexGap flexLayout) {
    for (final gap in flexLayout.gaps) {
      _paintSingleGap(canvas, gap);
    }
  }

  /// Paint individual gap
  void _paintSingleGap(Canvas canvas, WidgetGap gap) {
    final bounds = gap.bounds;

    // Draw gap background
    canvas.drawRect(
      bounds,
      Paint()
        ..color = Colors.orange.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill,
    );

    // Draw gap border
    canvas.drawRect(
      bounds,
      Paint()
        ..color = Colors.orange.withValues(alpha: 0.6)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );

    // Draw gap size label
    _drawGapLabel(canvas, gap);
  }

  /// Draw gap size label
  void _drawGapLabel(Canvas canvas, WidgetGap gap) {
    const labelPadding = 4.0;
    final labelText = '${gap.value.toStringAsFixed(1)}px';
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: labelText, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final labelWidth = textPainter.width + labelPadding * 2;
    final labelHeight = textPainter.height + labelPadding * 2;

    final labelPosition = Offset(
      gap.bounds.center.dx - labelWidth / 2,
      gap.bounds.center.dy - labelHeight / 2,
    );

    // Draw label background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(labelPosition.dx, labelPosition.dy, labelWidth, labelHeight),
        const Radius.circular(3),
      ),
      Paint()..color = Colors.orange,
    );

    // Draw label text
    textPainter.paint(
      canvas,
      Offset(labelPosition.dx + labelPadding, labelPosition.dy + labelPadding),
    );
  }

  /// Paint flex layout issues
  void _paintFlexIssues(Canvas canvas, FlexGap flexLayout) {
    for (final issue in flexLayout.issues) {
      _paintIssue(canvas, issue, flexLayout.bounds);
    }
  }

  /// Paint individual issue
  void _paintIssue(Canvas canvas, FlexIssue issue, Rect flexBounds) {
    final issueColor = _getSeverityColor(issue.severity);
    final iconPosition = (issue.location ?? flexBounds.topLeft) as Offset;

    // Draw issue marker
    canvas.drawCircle(
      iconPosition + const Offset(12, 12),
      10,
      Paint()..color = issueColor,
    );

    // Draw issue icon
    final icon = _getSeverityIcon(issue.severity);
    _drawSimpleIcon(canvas, iconPosition + const Offset(12, 12), icon, issueColor);
  }

  /// Paint selection highlight
  void _paintSelection(Canvas canvas, FlexGap flexLayout) {
    final bounds = flexLayout.bounds;

    // Draw enhanced selection border
    canvas.drawRect(
      bounds,
      Paint()
        ..color = Colors.blue.withValues(alpha: 0.8)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke,
    );

    // Draw corner handles
    _drawCornerHandle(canvas, bounds.topLeft);
    _drawCornerHandle(canvas, bounds.topRight);
    _drawCornerHandle(canvas, bounds.bottomLeft);
    _drawCornerHandle(canvas, bounds.bottomRight);
  }

  /// Draw corner handle
  void _drawCornerHandle(Canvas canvas, Offset corner) {
    canvas.drawCircle(
      corner,
      6,
      Paint()..color = Colors.blue,
    );
  }

  /// Draw arrow between two points
  void _drawArrow(Canvas canvas, Offset start, Offset end, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0;

    // Draw line
    canvas.drawLine(start, end, paint);

    // Draw arrowhead
    final direction = (end - start).normalize();
    final arrowSize = 8.0;

    final arrowPoint1 = end - direction * arrowSize +
      Offset(-direction.dy * 0.5, direction.dx * 0.5) * arrowSize;
    final arrowPoint2 = end - direction * arrowSize -
      Offset(-direction.dy * 0.5, direction.dx * 0.5) * arrowSize;

    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..close();

    canvas.drawPath(arrowPath, paint..style = PaintingStyle.fill);
  }

  /// Draw simple icon
  void _drawSimpleIcon(Canvas canvas, Offset position, String icon, Color color) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: icon, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2),
    );
  }

  /// Get severity color
  Color _getSeverityColor(Severity severity) {
    switch (severity) {
      case Severity.info:
        return Colors.blue;
      case Severity.warning:
        return Colors.orange;
      case Severity.error:
        return Colors.red;
    }
  }

  /// Get severity icon
  String _getSeverityIcon(Severity severity) {
    switch (severity) {
      case Severity.info:
        return 'i';
      case Severity.warning:
        return '!';
      case Severity.error:
        return '✕';
    }
  }

  @override
  bool shouldRepaint(FlexPainter oldDelegate) {
    return oldDelegate.flexLayouts != flexLayouts ||
        oldDelegate.selectedFlex != selectedFlex;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlexPainter &&
        other.flexLayouts == flexLayouts &&
        other.selectedFlex == selectedFlex;
  }

  @override
  int get hashCode => Object.hash(flexLayouts, selectedFlex);
}

// Extension for Offset normalization
extension OffsetExtension on Offset {
  Offset normalize() {
    final length = distance;
    if (length == 0) return Offset.zero;
    return this / length;
  }
}