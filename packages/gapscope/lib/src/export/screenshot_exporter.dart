import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'export_config.dart';

/// Result of a screenshot export operation
class ScreenshotResult {
  const ScreenshotResult({
    required this.data,
    required this.format,
    required this.size,
    required this.timestamp,
    required this.filename,
  });
  final Uint8List data;
  final String format;
  final Size size;
  final DateTime timestamp;
  final String filename;

  /// Get file size in bytes
  int get fileSize => data.length;

  /// Get file size in KB
  double get fileSizeKB => fileSize / 1024;

  /// Get file size in MB
  double get fileSizeMB => fileSizeKB / 1024;
}

/// Screenshot exporter for GapScope Studio
///
/// Captures widget screenshots with optional inspector overlays
/// and exports them in various formats.
class ScreenshotExporter {
  /// Global key for capturing screenshots
  final GlobalKey captureKey = GlobalKey();

  /// Capture screenshot of current widget state
  Future<ScreenshotResult> captureScreenshot(
    ExportConfig config,
  ) async {
    try {
      // Find render object
      final renderObject = captureKey.currentContext?.findRenderObject();
      if (renderObject == null) {
        throw Exception('No render object found for screenshot capture');
      }

      // Render the widget to image
      final image = await _renderToImage(renderObject, config);

      // Convert to desired format
      final byteData = await _imageToByteData(image, config);

      // Generate filename
      final filename = _generateFilename(config);

      return ScreenshotResult(
        data: byteData,
        format: config.formatExtension,
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        timestamp: DateTime.now(),
        filename: filename,
      );
    } catch (e) {
      throw Exception('Screenshot capture failed: $e');
    }
  }

  /// Render widget to image
  Future<ui.Image> _renderToImage(
    RenderObject renderObject,
    ExportConfig config,
  ) async {
    if (renderObject is! RenderRepaintBoundary) {
      throw Exception('Render object is not a RenderRepaintBoundary');
    }

    final image = await renderObject.toImage(
      pixelRatio: config.pixelRatio,
    );

    return image;
  }

  /// Convert image to byte data in desired format
  Future<Uint8List> _imageToByteData(
    ui.Image image,
    ExportConfig config,
  ) async {
    ByteData? byteData;

    // For now, only support PNG to ensure compatibility
    byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData == null) {
      throw Exception('Failed to convert image to byte data');
    }

    return byteData.buffer.asUint8List();
  }

  /// Generate filename for screenshot
  String _generateFilename(ExportConfig config) {
    final timestamp = DateTime.now();
    final dateStr =
        timestamp.toIso8601String().replaceAll(':', '-').split('.')[0];
    return 'gapscope_screenshot_$dateStr.${config.formatExtension}';
  }

  /// Capture screenshot and save to file
  Future<String> saveScreenshot(
    ExportConfig config,
    String directory,
  ) async {
    final result = await captureScreenshot(config);

    // In a real implementation, this would save to the file system
    // For now, we'll just return the path
    final path = '$directory/${result.filename}';

    // TODO: Implement actual file saving
    // await File(path).writeAsBytes(result.data);

    return path;
  }

  /// Capture multiple screenshots in batch
  Future<List<ScreenshotResult>> captureBatch(
    List<ExportConfig> configs,
  ) async {
    final results = <ScreenshotResult>[];

    for (final config in configs) {
      try {
        final result = await captureScreenshot(config);
        results.add(result);
      } catch (e) {
        // Continue with other captures even if one fails
        debugPrint('Failed to capture screenshot: $e');
      }
    }

    return results;
  }

  /// Create RepaintBoundary wrapper for screenshots
  static Widget wrapForScreenshot(Widget child, GlobalKey key) {
    return RepaintBoundary(
      key: key,
      child: child,
    );
  }
}
