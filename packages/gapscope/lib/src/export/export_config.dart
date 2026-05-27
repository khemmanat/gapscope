import 'package:flutter/material.dart';

/// Screenshot format options
enum ScreenshotFormat {
  png,
  webp,
  jpeg,
}

/// Export configuration for screenshots and reports
class ExportConfig {
  /// Screenshot format
  final ScreenshotFormat format;

  /// Image quality (0.0 - 1.0, only for lossy formats)
  final double quality;

  /// Include inspector overlays in screenshot
  final bool includeInspector;

  /// Device pixel ratio for screenshot
  final double pixelRatio;

  /// Custom size for screenshot (null = use widget size)
  final Size? customSize;

  /// Background color for transparent areas
  final Color? backgroundColor;

  const ExportConfig({
    this.format = ScreenshotFormat.png,
    this.quality = 0.9,
    this.includeInspector = true,
    this.pixelRatio = 1.0,
    this.customSize,
    this.backgroundColor,
  });

  /// Get format string for file extension
  String get formatExtension {
    switch (format) {
      case ScreenshotFormat.png:
        return 'png';
      case ScreenshotFormat.webp:
        return 'webp';
      case ScreenshotFormat.jpeg:
        return 'jpg';
    }
  }

  /// Get MIME type for format
  String get mimeType {
    switch (format) {
      case ScreenshotFormat.png:
        return 'image/png';
      case ScreenshotFormat.webp:
        return 'image/webp';
      case ScreenshotFormat.jpeg:
        return 'image/jpeg';
    }
  }

  /// Check if format supports quality setting
  bool get supportsQuality {
    return format == ScreenshotFormat.jpeg || format == ScreenshotFormat.webp;
  }

  /// Create default config for high quality export
  static ExportConfig get highQuality => const ExportConfig(
    format: ScreenshotFormat.png,
    quality: 1.0,
    includeInspector: true,
    pixelRatio: 2.0,
  );

  /// Create default config for web export
  static ExportConfig get webExport => const ExportConfig(
    format: ScreenshotFormat.webp,
    quality: 0.85,
    includeInspector: false,
    pixelRatio: 1.0,
  );

  /// Create config for CI/CD automation
  static ExportConfig get ciAutomation => const ExportConfig(
    format: ScreenshotFormat.png,
    quality: 0.95,
    includeInspector: true,
    pixelRatio: 1.0,
  );
}

/// Report export configuration
class ReportConfig {
  /// Report format
  final ReportFormat format;

  /// Include screenshots in report
  final bool includeScreenshots;

  /// Include detailed metrics
  final bool includeMetrics;

  /// Include issue details
  final bool includeIssueDetails;

  /// Report title
  final String title;

  /// Report description
  final String? description;

  const ReportConfig({
    this.format = ReportFormat.html,
    this.includeScreenshots = true,
    this.includeMetrics = true,
    this.includeIssueDetails = true,
    required this.title,
    this.description,
  });
}

/// Report format options
enum ReportFormat {
  json,
  html,
  markdown,
  pdf,
}