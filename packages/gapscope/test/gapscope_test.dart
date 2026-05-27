import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapscope/gapscope.dart';

void main() {
  group('GapScope Studio Tests', () {
    testWidgets('GapScopeStudio renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GapScopeStudio(
            title: 'Test Studio',
            components: [
              GapScopeComponent(
                id: 'test_component',
                name: 'Test Component',
                stories: [],
              ),
            ],
          ),
        ),
      );

      expect(find.byType(GapScopeStudio), findsOneWidget);
    });

    testWidgets('GapScopeStudio displays components in sidebar', (WidgetTester tester) async {
      const component = GapScopeComponent(
        id: 'test_button',
        name: 'Test Button',
        stories: [],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: GapScopeStudio(
            title: 'Test Studio',
            components: [component],
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('GapScopeInspector toggles modes correctly', (WidgetTester tester) async {
      final inspectorController = GapScopeController();

      await tester.pumpWidget(
        MaterialApp(
          home: GapScopeInspector(
            controller: inspectorController,
            child: const SizedBox(),
          ),
        ),
      );

      // Test initial state
      expect(inspectorController.mode, GapScopeMode.off);

      // Test mode change
      inspectorController.setMode(GapScopeMode.bounds);
      await tester.pump();

      expect(inspectorController.mode, GapScopeMode.bounds);
    });
  });

  group('Export System Tests', () {
    test('ExportConfig creates correct file extensions', () {
      const pngConfig = ExportConfig(format: ScreenshotFormat.png);
      const webpConfig = ExportConfig(format: ScreenshotFormat.webp);
      const jpegConfig = ExportConfig(format: ScreenshotFormat.jpeg);

      expect(pngConfig.formatExtension, 'png');
      expect(webpConfig.formatExtension, 'webp');
      expect(jpegConfig.formatExtension, 'jpg');
    });

    test('ExportConfig returns correct MIME types', () {
      const pngConfig = ExportConfig(format: ScreenshotFormat.png);
      const webpConfig = ExportConfig(format: ScreenshotFormat.webp);
      const jpegConfig = ExportConfig(format: ScreenshotFormat.jpeg);

      expect(pngConfig.mimeType, 'image/png');
      expect(webpConfig.mimeType, 'image/webp');
      expect(jpegConfig.mimeType, 'image/jpeg');
    });

    test('ExportConfig checks quality support correctly', () {
      const pngConfig = ExportConfig(format: ScreenshotFormat.png);
      const jpegConfig = ExportConfig(format: ScreenshotFormat.jpeg);
      const webpConfig = ExportConfig(format: ScreenshotFormat.webp);

      expect(pngConfig.supportsQuality, false);
      expect(jpegConfig.supportsQuality, true);
      expect(webpConfig.supportsQuality, true);
    });

    test('ScreenshotResult calculates file sizes correctly', () {
      final result = ScreenshotResult(
        data: Uint8List(1024), // 1KB
        format: 'png',
        size: const Size(100, 100),
        timestamp: DateTime.now(),
        filename: 'test.png',
      );

      expect(result.fileSize, 1024);
      expect(result.fileSizeKB, closeTo(1.0, 0.1));
      expect(result.fileSizeMB, closeTo(0.001, 0.0001));
    });

    test('QAReport counts issues by severity correctly', () {
      final report = QAReport(
        id: 'test_report',
        timestamp: DateTime.now(),
        screenshots: [],
        issues: [
          QAIssue(
            id: 'issue1',
            severity: IssueSeverity.critical,
            category: 'Test',
            description: 'Critical issue',
          ),
          QAIssue(
            id: 'issue2',
            severity: IssueSeverity.warning,
            category: 'Test',
            description: 'Warning issue',
          ),
          QAIssue(
            id: 'issue3',
            severity: IssueSeverity.warning,
            category: 'Test',
            description: 'Another warning',
          ),
        ],
        metrics: {},
        config: const ReportConfig(title: 'Test Report'),
      );

      expect(report.getIssueCount(IssueSeverity.critical), 1);
      expect(report.getIssueCount(IssueSeverity.warning), 2);
      expect(report.getIssueCount(IssueSeverity.error), 0);
      expect(report.hasCriticalIssues, true);
    });
  });

  group('Inspector System Tests', () {
    test('GapScopeMode enum has all expected values', () {
      expect(GapScopeMode.values.length, 8);
      expect(GapScopeMode.values, contains(GapScopeMode.off));
      expect(GapScopeMode.values, contains(GapScopeMode.bounds));
      expect(GapScopeMode.values, contains(GapScopeMode.spacing));
      expect(GapScopeMode.values, contains(GapScopeMode.flex));
      expect(GapScopeMode.values, contains(GapScopeMode.whitespace));
      expect(GapScopeMode.values, contains(GapScopeMode.overlay));
      expect(GapScopeMode.values, contains(GapScopeMode.constraints));
      expect(GapScopeMode.values, contains(GapScopeMode.tapTarget));
    });

    test('GapScopeController initializes correctly', () {
      final controller = GapScopeController();

      expect(controller.mode, GapScopeMode.off);
    });

    test('GeometrySnapshot creates valid snapshot', () {
      final snapshot = GeometrySnapshot(
        id: 'test_widget',
        bounds: const Rect.fromLTWH(10, 10, 100, 50),
        widgetType: 'Container',
        depth: 2,
        visible: true,
      );

      expect(snapshot.id, 'test_widget');
      expect(snapshot.bounds, const Rect.fromLTWH(10, 10, 100, 50));
      expect(snapshot.depth, 2);
      expect(snapshot.visible, true);
      expect(snapshot.widgetType, 'Container');
    });
  });

  group('Overlay System Tests', () {
    test('OverlayType enum has all expected values', () {
      expect(OverlayType.values.length, 8);
      expect(OverlayType.values, contains(OverlayType.dialog));
      expect(OverlayType.values, contains(OverlayType.bottomSheet));
      expect(OverlayType.values, contains(OverlayType.dropdown));
      expect(OverlayType.values, contains(OverlayType.tooltip));
      expect(OverlayType.values, contains(OverlayType.popupMenu));
      expect(OverlayType.values, contains(OverlayType.overlayEntry));
      expect(OverlayType.values, contains(OverlayType.overlayPortal));
      expect(OverlayType.values, contains(OverlayType.other));
    });

    test('OverlayInfo creates valid info', () {
      final info = OverlayInfo(
        id: 'test_overlay',
        type: OverlayType.dialog,
        bounds: const Rect.fromLTWH(0, 0, 400, 300),
        widgetType: 'Dialog',
        isVisible: true,
        createdAt: DateTime.now(),
      );

      expect(info.id, 'test_overlay');
      expect(info.type, OverlayType.dialog);
      expect(info.bounds, const Rect.fromLTWH(0, 0, 400, 300));
    });
  });

  group('CI/CD System Tests', () {
    test('CiExitCode has correct values', () {
      expect(CiExitCode.success.code, 0);
      expect(CiExitCode.partialSuccess.code, 1);
      expect(CiExitCode.failure.code, 2);
      expect(CiExitCode.error.code, 3);
    });

    test('CiConfig creates default configuration', () {
      final config = CiAutomation.createSampleConfig();

      expect(config.projectName, 'GapScope Sample Project');
      expect(config.outputDirectory, './gapscope_reports');
      expect(config.failOnCritical, true);
      expect(config.failOnError, false);
    });

    test('CiResult generates correct summary message', () {
      const successResult = CiResult(
        success: true,
        exitCode: CiExitCode.success,
        executionTimeMs: 1000,
      );

      expect(successResult.summaryMessage, contains('✓ CI PASSED'));
      expect(successResult.executionTimeMs, 1000);

      const failureResult = CiResult(
        success: false,
        exitCode: CiExitCode.error,
        executionTimeMs: 500,
        errors: ['Test error'],
      );

      expect(failureResult.summaryMessage, contains('✗ CI FAILED'));
      expect(failureResult.errors, ['Test error']);
    });
  });
}