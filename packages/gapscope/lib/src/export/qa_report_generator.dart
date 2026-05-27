import 'dart:convert';

import 'export_config.dart';
import 'screenshot_exporter.dart';

/// Issue severity levels
enum IssueSeverity {
  info,
  warning,
  error,
  critical,
}

/// QA issue from analysis
class QAIssue {
  const QAIssue({
    required this.id,
    required this.severity,
    required this.category,
    required this.description,
    this.screenshotId,
    this.metadata,
  });
  final String id;
  final IssueSeverity severity;
  final String category;
  final String description;
  final String? screenshotId;
  final Map<String, dynamic>? metadata;

  /// Convert issue to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'severity': severity.name,
      'category': category,
      'description': description,
      'screenshotId': screenshotId,
      'metadata': metadata,
    };
  }
}

/// QA report with screenshots, issues, and metrics
class QAReport {
  const QAReport({
    required this.id,
    required this.timestamp,
    required this.screenshots,
    required this.issues,
    required this.metrics,
    required this.config,
  });
  final String id;
  final DateTime timestamp;
  final List<ScreenshotResult> screenshots;
  final List<QAIssue> issues;
  final Map<String, dynamic> metrics;
  final ReportConfig config;

  /// Get issue count by severity
  int getIssueCount(IssueSeverity severity) {
    return issues.where((issue) => issue.severity == severity).length;
  }

  /// Get critical issues
  List<QAIssue> get criticalIssues {
    return issues
        .where(
          (issue) =>
              issue.severity == IssueSeverity.critical ||
              issue.severity == IssueSeverity.error,
        )
        .toList();
  }

  /// Check if report has critical issues
  bool get hasCriticalIssues {
    return criticalIssues.isNotEmpty;
  }

  /// Generate report in specified format
  Future<String> generateReport() async {
    switch (config.format) {
      case ReportFormat.json:
        return _generateJsonReport();
      case ReportFormat.html:
        return _generateHtmlReport();
      case ReportFormat.markdown:
        return _generateMarkdownReport();
      case ReportFormat.pdf:
        return _generatePdfReport();
    }
  }

  /// Generate JSON report
  String _generateJsonReport() {
    final reportData = {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'title': config.title,
      'description': config.description,
      'screenshots': screenshots
          .map(
            (screenshot) => {
              'filename': screenshot.filename,
              'format': screenshot.format,
              'size': '${screenshot.size.width}x${screenshot.size.height}',
              'fileSize': screenshot.fileSizeKB,
              'timestamp': screenshot.timestamp.toIso8601String(),
            },
          )
          .toList(),
      'issues': issues.map((issue) => issue.toJson()).toList(),
      'metrics': metrics,
      'summary': {
        'totalIssues': issues.length,
        'criticalIssues': getIssueCount(IssueSeverity.critical),
        'errorIssues': getIssueCount(IssueSeverity.error),
        'warningIssues': getIssueCount(IssueSeverity.warning),
        'infoIssues': getIssueCount(IssueSeverity.info),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(reportData);
  }

  /// Generate HTML report
  String _generateHtmlReport() {
    final buffer = StringBuffer();

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="en">');
    buffer.writeln('<head>');
    buffer.writeln('  <meta charset="UTF-8">');
    buffer.writeln(
      '  <meta name="viewport" content="width=device-width, initial-scale=1.0">',
    );
    buffer.writeln('  <title>${config.title}</title>');
    buffer.writeln('  <style>');
    buffer.writeln(
      '    body { font-family: Arial, sans-serif; margin: 20px; }',
    );
    buffer.writeln(
      '    .header { background: #2196F3; color: white; padding: 20px; border-radius: 8px; }',
    );
    buffer.writeln('    .section { margin: 20px 0; }');
    buffer.writeln(
      '    .issue { padding: 10px; margin: 5px 0; border-radius: 4px; }',
    );
    buffer.writeln(
      '    .critical { background: #ffebee; border-left: 4px solid #f44336; }',
    );
    buffer.writeln(
      '    .error { background: #fff3e0; border-left: 4px solid #ff9800; }',
    );
    buffer.writeln(
      '    .warning { background: #e8f5e8; border-left: 4px solid #4caf50; }',
    );
    buffer.writeln(
      '    .info { background: #e3f2fd; border-left: 4px solid #2196f3; }',
    );
    buffer.writeln(
      '    .screenshot-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 10px; }',
    );
    buffer.writeln(
      '    .screenshot { border: 1px solid #ddd; border-radius: 4px; padding: 10px; }',
    );
    buffer.writeln('  </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');
    buffer.writeln('  <div class="header">');
    buffer.writeln('    <h1>${config.title}</h1>');
    buffer.writeln('    <p>Generated: ${timestamp.toIso8601String()}</p>');
    if (config.description != null) {
      buffer.writeln('    <p>${config.description}</p>');
    }
    buffer.writeln('  </div>');

    // Summary section
    buffer.writeln('  <div class="section">');
    buffer.writeln('    <h2>Summary</h2>');
    buffer.writeln(
      '    <p><strong>Total Issues:</strong> ${issues.length}</p>',
    );
    buffer.writeln(
      '    <p><strong>Critical:</strong> ${getIssueCount(IssueSeverity.critical)}</p>',
    );
    buffer.writeln(
      '    <p><strong>Errors:</strong> ${getIssueCount(IssueSeverity.error)}</p>',
    );
    buffer.writeln(
      '    <p><strong>Warnings:</strong> ${getIssueCount(IssueSeverity.warning)}</p>',
    );
    buffer.writeln('  </div>');

    // Issues section
    if (config.includeIssueDetails && issues.isNotEmpty) {
      buffer.writeln('  <div class="section">');
      buffer.writeln('    <h2>Issues</h2>');
      for (final issue in issues) {
        final severityClass = issue.severity.name.toLowerCase();
        buffer.writeln('    <div class="issue $severityClass">');
        buffer.writeln(
          '      <strong>[${issue.severity.name.toUpperCase()}]</strong> ${issue.category}',
        );
        buffer.writeln('      <p>${issue.description}</p>');
        buffer.writeln('    </div>');
      }
      buffer.writeln('  </div>');
    }

    // Screenshots section
    if (config.includeScreenshots && screenshots.isNotEmpty) {
      buffer.writeln('  <div class="section">');
      buffer.writeln('    <h2>Screenshots</h2>');
      buffer.writeln('    <div class="screenshot-grid">');
      for (final screenshot in screenshots) {
        buffer.writeln('      <div class="screenshot">');
        buffer.writeln(
          '        <p><strong>${screenshot.filename}</strong></p>',
        );
        buffer.writeln(
          '        <p>Size: ${screenshot.size.width.toInt()}x${screenshot.size.height.toInt()}</p>',
        );
        buffer.writeln(
          '        <p>File: ${screenshot.fileSizeKB.toStringAsFixed(1)} KB</p>',
        );
        buffer.writeln('      </div>');
      }
      buffer.writeln('    </div>');
      buffer.writeln('  </div>');
    }

    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  /// Generate Markdown report
  String _generateMarkdownReport() {
    final buffer = StringBuffer();

    buffer.writeln('# ${config.title}');
    buffer.writeln('');
    buffer.writeln('**Generated:** ${timestamp.toIso8601String()}');
    if (config.description != null) {
      buffer.writeln('\n${config.description}');
    }
    buffer.writeln('\n## Summary');
    buffer.writeln('- **Total Issues:** ${issues.length}');
    buffer.writeln('- **Critical:** ${getIssueCount(IssueSeverity.critical)}');
    buffer.writeln('- **Errors:** ${getIssueCount(IssueSeverity.error)}');
    buffer.writeln('- **Warnings:** ${getIssueCount(IssueSeverity.warning)}');

    if (config.includeIssueDetails && issues.isNotEmpty) {
      buffer.writeln('\n## Issues');
      for (final issue in issues) {
        buffer.writeln(
          '### [${issue.severity.name.toUpperCase()}] ${issue.category}',
        );
        buffer.writeln(issue.description);
        buffer.writeln('');
      }
    }

    if (config.includeScreenshots && screenshots.isNotEmpty) {
      buffer.writeln('## Screenshots');
      for (final screenshot in screenshots) {
        buffer.writeln('### ${screenshot.filename}');
        buffer.writeln(
          '- Size: ${screenshot.size.width.toInt()}x${screenshot.size.height.toInt()}',
        );
        buffer.writeln(
          '- File: ${screenshot.fileSizeKB.toStringAsFixed(1)} KB',
        );
        buffer.writeln('');
      }
    }

    return buffer.toString();
  }

  /// Generate PDF report (simplified version)
  String _generatePdfReport() {
    // For a real implementation, this would use a PDF generation package
    // For now, we'll return a placeholder
    return '# ${config.title}\n\nPDF export requires additional dependencies.\nPlease use JSON or HTML format instead.';
  }
}

/// QA Report generator for GapScope Studio
class QAReportGenerator {
  /// Generate comprehensive QA report
  static Future<QAReport> generateReport({
    required String title,
    required List<ScreenshotResult> screenshots,
    required List<QAIssue> issues,
    required Map<String, dynamic> metrics,
    ReportFormat format = ReportFormat.html,
    String? description,
    bool includeScreenshots = true,
    bool includeMetrics = true,
    bool includeIssueDetails = true,
  }) async {
    final config = ReportConfig(
      title: title,
      format: format,
      description: description,
      includeScreenshots: includeScreenshots,
      includeMetrics: includeMetrics,
      includeIssueDetails: includeIssueDetails,
    );

    return QAReport(
      id: 'qa_report_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      screenshots: screenshots,
      issues: issues,
      metrics: metrics,
      config: config,
    );
  }

  /// Create sample issues from analysis data
  static List<QAIssue> createSampleIssues() {
    return [
      const QAIssue(
        id: 'issue_1',
        severity: IssueSeverity.warning,
        category: 'Tap Target',
        description: 'Button "Submit" is too small (35x35px, minimum 48x48px)',
      ),
      const QAIssue(
        id: 'issue_2',
        severity: IssueSeverity.info,
        category: 'Whitespace',
        description: 'Inconsistent spacing detected in flex container',
      ),
      const QAIssue(
        id: 'issue_3',
        severity: IssueSeverity.error,
        category: 'Overlay',
        description: 'Dialog overlaps with bottom sheet',
      ),
    ];
  }

  /// Create sample metrics for testing
  static Map<String, dynamic> createSampleMetrics() {
    return {
      'widgets_analyzed': 15,
      'tap_targets_checked': 8,
      'compliance_rate': 0.75,
      'total_issues': 3,
      'flex_layouts': 5,
      'overlays_detected': 2,
    };
  }
}
