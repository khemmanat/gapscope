import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapscope/gapscope.dart';

void main() {
  group('Screenshot Export Tests', () {
    test('ScreenshotExporter creates instance correctly', () {
      final exporter = ScreenshotExporter();

      expect(exporter.captureKey, isNotNull);
      expect(exporter.captureKey, isA<GlobalKey>());
    });

    test('ExportConfig.highQuality has correct settings', () {
      final config = ExportConfig.highQuality;

      expect(config.format, ScreenshotFormat.png);
      expect(config.quality, 1.0);
      expect(config.includeInspector, true);
      expect(config.pixelRatio, 2.0);
    });

    test('ExportConfig.webExport has correct settings', () {
      final config = ExportConfig.webExport;

      expect(config.format, ScreenshotFormat.webp);
      expect(config.quality, 0.85);
      expect(config.includeInspector, false);
      expect(config.pixelRatio, 1.0);
    });

    test('ExportConfig.ciAutomation has correct settings', () {
      final config = ExportConfig.ciAutomation;

      expect(config.format, ScreenshotFormat.png);
      expect(config.quality, 0.95);
      expect(config.includeInspector, true);
    });

    test('ScreenshotResult generates correct filename', () {
      final result = ScreenshotResult(
        data: Uint8List(0),
        format: 'png',
        size: const Size(100, 100),
        timestamp: DateTime(2026, 5, 27, 12, 0, 0),
        filename: 'gapscope_screenshot_2026-05-27T12-00-00.png',
      );

      expect(result.filename, contains('gapscope_screenshot'));
      expect(result.filename, contains('2026-05-27'));
      expect(result.filename, endsWith('.png'));
    });
  });

  group('QA Report Generator Tests', () {
    test('QAIssue converts to JSON correctly', () {
      const issue = QAIssue(
        id: 'test_issue',
        severity: IssueSeverity.error,
        category: 'Test Category',
        description: 'Test description',
        screenshotId: 'test_screenshot',
        metadata: {'key': 'value'},
      );

      final json = issue.toJson();

      expect(json['id'], 'test_issue');
      expect(json['severity'], 'error');
      expect(json['category'], 'Test Category');
      expect(json['description'], 'Test description');
      expect(json['screenshotId'], 'test_screenshot');
      expect(json['metadata'], {'key': 'value'});
    });

    test('QAReportGenerator creates sample issues', () {
      final issues = QAReportGenerator.createSampleIssues();

      expect(issues.length, 3);
      expect(issues[0].category, 'Tap Target');
      expect(issues[1].category, 'Whitespace');
      expect(issues[2].category, 'Overlay');
    });

    test('QAReportGenerator creates sample metrics', () {
      final metrics = QAReportGenerator.createSampleMetrics();

      expect(metrics.length, greaterThan(0));
      expect(metrics.containsKey('widgets_analyzed'), true);
      expect(metrics.containsKey('tap_targets_checked'), true);
    });

    test('QAReport generates JSON format correctly', () async {
      final report = QAReport(
        id: 'test_report',
        timestamp: DateTime.now(),
        screenshots: [],
        issues: [],
        metrics: {'total_tests': 10},
        config: const ReportConfig(
          title: 'Test Report',
          format: ReportFormat.json,
        ),
      );

      final jsonReport = await report.generateReport();

      expect(jsonReport, contains('"id": "test_report"'));
      expect(jsonReport, contains('"title": "Test Report"'));
      expect(jsonReport, contains('"total_tests": 10'));
    });

    test('QAReport generates Markdown format correctly', () async {
      final report = QAReport(
        id: 'test_report',
        timestamp: DateTime.now(),
        screenshots: [],
        issues: [],
        metrics: {},
        config: const ReportConfig(
          title: 'Test Report',
          format: ReportFormat.markdown,
        ),
      );

      final markdownReport = await report.generateReport();

      expect(markdownReport, startsWith('# Test Report'));
      expect(markdownReport, contains('## Summary'));
    });

    test('QAReport identifies critical issues correctly', () {
      final report = QAReport(
        id: 'test_report',
        timestamp: DateTime.now(),
        screenshots: [],
        issues: [
          const QAIssue(
            id: 'critical1',
            severity: IssueSeverity.critical,
            category: 'Critical',
            description: 'Critical issue',
          ),
          const QAIssue(
            id: 'warning1',
            severity: IssueSeverity.warning,
            category: 'Warning',
            description: 'Warning issue',
          ),
        ],
        metrics: {},
        config: const ReportConfig(title: 'Test Report'),
      );

      expect(report.hasCriticalIssues, true);
      expect(report.criticalIssues.length, 1);
      expect(report.criticalIssues[0].id, 'critical1');
    });
  });

  group('Golden Testing Tests', () {
    test('GoldenTestConfig creates default configuration', () {
      final config = GoldenTestConfig(
        testName: 'test_golden',
        widget: const Text('Test'),
      );

      expect(config.testName, 'test_golden');
      expect(config.includeInspector, false);
      expect(config.exportConfig.format, ScreenshotFormat.png);
    });

    test('GoldenTestResult generates status message correctly', () {
      final passedResult = GoldenTestResult(
        testName: 'test1',
        passed: true,
        timestamp: DateTime.now(),
      );

      expect(passedResult.statusMessage, contains('✓ Passed'));
      expect(passedResult.statusMessage, contains('test1'));

      final failedResult = GoldenTestResult(
        testName: 'test2',
        passed: false,
        errorMessage: 'Test failed',
        timestamp: DateTime.now(),
      );

      expect(failedResult.statusMessage, contains('✗ Failed'));
      expect(failedResult.statusMessage, contains('Test failed'));
    });

    test('GoldenTestIntegration generates filename correctly', () {
      final filename = GoldenTestIntegration.generateGoldenFileName('my_test');

      expect(filename, contains('my_test'));
      expect(filename, endsWith('.png'));
    });
  });

  group('CI Automation Tests', () {
    test('CiConfig has correct default values', () {
      const config = CiConfig(
        projectName: 'Test Project',
      );

      expect(config.projectName, 'Test Project');
      expect(config.outputDirectory, './gapscope_reports');
      expect(config.failOnCritical, true);
      expect(config.failOnError, false);
      expect(config.maxIssuesBySeverity['critical'], 0);
      expect(config.maxIssuesBySeverity['error'], 10);
    });

    test('CiResult handles success case correctly', () {
      const result = CiResult(
        success: true,
        exitCode: CiExitCode.success,
        executionTimeMs: 1500,
        screenshotPaths: ['screenshot1.png', 'screenshot2.png'],
      );

      expect(result.success, true);
      expect(result.exitCode, CiExitCode.success);
      expect(result.screenshotPaths.length, 2);
      expect(result.summaryMessage, contains('✓ CI PASSED'));
    });

    test('CiResult handles error case correctly', () {
      const result = CiResult(
        success: false,
        exitCode: CiExitCode.error,
        executionTimeMs: 500,
        errors: ['Build failed', 'Test timeout'],
      );

      expect(result.success, false);
      expect(result.exitCode, CiExitCode.error);
      expect(result.errors.length, 2);
      expect(result.summaryMessage, contains('✗ CI FAILED'));
    });

    test('ReportFormat enum has all expected values', () {
      expect(ReportFormat.values.length, 4);
      expect(ReportFormat.values, contains(ReportFormat.json));
      expect(ReportFormat.values, contains(ReportFormat.html));
      expect(ReportFormat.values, contains(ReportFormat.markdown));
      expect(ReportFormat.values, contains(ReportFormat.pdf));
    });
  });
}