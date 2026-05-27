import 'dart:io';
import 'export_config.dart';
import 'qa_report_generator.dart';
import 'screenshot_exporter.dart';

/// CI/CD exit codes for automation
enum CiExitCode {
  /// All tests passed
  success(0),

  /// Tests failed but no critical issues
  partialSuccess(1),

  /// Critical issues found
  failure(2),

  /// Error in execution
  error(3);

  /// Creates a CI exit code with its process value.
  const CiExitCode(this.code);

  /// CI process exit code value.
  final int code;
}

/// CI/CD configuration for automated testing
class CiConfig {
  /// CI configuration constructor
  const CiConfig({
    required this.projectName,
    this.outputDirectory = './gapscope_reports',
    ExportConfig? screenshotConfig,
    this.reportFormat = ReportFormat.json,
    this.failOnCritical = true,
    this.failOnError = false,
    this.maxIssuesBySeverity = const {
      'critical': 0,
      'error': 10,
      'warning': 50,
      'info': 100,
    },
  }) : screenshotConfig = screenshotConfig ??
            const ExportConfig(
              format: ScreenshotFormat.png,
              quality: 0.95,
              includeInspector: true,
            );

  /// Project name for reporting
  final String projectName;

  /// Output directory for reports
  final String outputDirectory;

  /// Screenshot configuration
  final ExportConfig screenshotConfig;

  /// Report format
  final ReportFormat reportFormat;

  /// Fail on critical issues
  final bool failOnCritical;

  /// Fail on error issues
  final bool failOnError;

  /// Maximum allowed issues by severity
  final Map<String, int> maxIssuesBySeverity;
}

/// CI/CD pipeline result
class CiResult {
  /// CI Result constructor
  const CiResult({
    required this.success,
    required this.exitCode,
    this.report,
    this.screenshotPaths = const [],
    required this.executionTimeMs,
    this.errors = const [],
  });

  /// Overall success status
  final bool success;

  /// Exit code for CI system
  final CiExitCode exitCode;

  /// Generated QA report
  final QAReport? report;

  /// Screenshots captured
  final List<String> screenshotPaths;

  /// Execution time in milliseconds
  final int executionTimeMs;

  /// Error messages if any
  final List<String> errors;

  /// Get summary message for CI logs
  String get summaryMessage {
    if (success) {
      final issueCount = report?.issues.length ?? 0;
      return '✓ CI PASSED: GapScope QA - $issueCount issues found';
    } else {
      return '✗ CI FAILED: ${errors.join(", ")}';
    }
  }
}

/// CI/CD automation support for GapScope Studio
///
/// Provides command-line interface and CI/CD pipeline integration
/// for automated QA testing and reporting.
class CiAutomation {
  /// Run CI pipeline with given configuration
  static Future<CiResult> runPipeline(
    CiConfig config,
    Future<List<ScreenshotResult>> Function() captureScreenshots,
    Future<List<QAIssue>> Function() collectIssues,
    Future<Map<String, dynamic>> Function() collectMetrics,
  ) async {
    final startTime = DateTime.now();
    final errors = <String>[];
    final screenshotPaths = <String>[];

    try {
      ensureOutputDirectory(config.outputDirectory);

      // Step 1: Capture screenshots
      final screenshots = await captureScreenshots();
      for (final screenshot in screenshots) {
        final path = await _saveScreenshot(screenshot, config.outputDirectory);
        screenshotPaths.add(path);
      }

      // Step 2: Collect QA issues
      final issues = await collectIssues();

      // Step 3: Collect metrics
      final metrics = await collectMetrics();

      // Step 4: Generate report
      final report = await QAReportGenerator.generateReport(
        title: config.projectName,
        screenshots: screenshots,
        issues: issues,
        metrics: metrics,
        format: config.reportFormat,
        description: 'CI/CD Automated QA Report',
      );

      // Step 5: Save report
      await _saveReport(report, config.outputDirectory);

      // Step 6: Check failure conditions
      final exitCode = _determineExitCode(report, config);
      final success = exitCode == CiExitCode.success;

      final executionTime = DateTime.now().difference(startTime).inMilliseconds;

      return CiResult(
        success: success,
        exitCode: exitCode,
        report: report,
        screenshotPaths: screenshotPaths,
        executionTimeMs: executionTime,
        errors: errors,
      );
    } catch (e) {
      errors.add('Pipeline execution failed: $e');

      return CiResult(
        success: false,
        exitCode: CiExitCode.error,
        executionTimeMs: DateTime.now().difference(startTime).inMilliseconds,
        errors: errors,
      );
    }
  }

  /// Determine exit code based on report and config
  static CiExitCode _determineExitCode(QAReport report, CiConfig config) {
    final criticalCount = report.getIssueCount(IssueSeverity.critical);
    final errorCount = report.getIssueCount(IssueSeverity.error);

    if (config.failOnCritical &&
        criticalCount > config.maxIssuesBySeverity['critical']!) {
      return CiExitCode.failure;
    }

    if (config.failOnError &&
        errorCount > config.maxIssuesBySeverity['error']!) {
      return CiExitCode.partialSuccess;
    }

    if (report.hasCriticalIssues) {
      return CiExitCode.partialSuccess;
    }

    return CiExitCode.success;
  }

  /// Save screenshot to file system
  static Future<String> _saveScreenshot(
    ScreenshotResult screenshot,
    String directory,
  ) async {
    final path = '$directory/${screenshot.filename}';
    await File(path).writeAsBytes(screenshot.data);

    return path;
  }

  /// Save report to file system
  static Future<void> _saveReport(
    QAReport report,
    String directory,
  ) async {
    final extension = _getFileExtension(report.config.format);
    final path = '$directory/${report.id}.$extension';
    final content = await report.generateReport();

    await File(path).writeAsString(content);
  }

  /// Get file extension for report format
  static String _getFileExtension(ReportFormat format) {
    switch (format) {
      case ReportFormat.json:
        return 'json';
      case ReportFormat.html:
        return 'html';
      case ReportFormat.markdown:
        return 'md';
      case ReportFormat.pdf:
        return 'pdf';
    }
  }

  /// Create output directory if it doesn't exist
  static void ensureOutputDirectory(String path) {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }

  /// Print CI results to console
  static void printResults(CiResult result) {
    // Ignore print warnings for CI output
    // ignore: avoid_print
    print('--- GapScope CI/CD Results ---');
    // ignore: avoid_print
    print(result.summaryMessage);

    if (result.report != null) {
      // ignore: avoid_print
      print('Issues by severity:');
      // ignore: avoid_print
      print(
        '  Critical: ${result.report!.getIssueCount(IssueSeverity.critical)}',
      );
      // ignore: avoid_print
      print('  Error: ${result.report!.getIssueCount(IssueSeverity.error)}');
      // ignore: avoid_print
      print(
        '  Warning: ${result.report!.getIssueCount(IssueSeverity.warning)}',
      );
      // ignore: avoid_print
      print('  Info: ${result.report!.getIssueCount(IssueSeverity.info)}');
    }

    // ignore: avoid_print
    print('Execution time: ${result.executionTimeMs}ms');
    // ignore: avoid_print
    print('Screenshots captured: ${result.screenshotPaths.length}');

    if (result.errors.isNotEmpty) {
      // ignore: avoid_print
      print('Errors:');
      for (final error in result.errors) {
        // ignore: avoid_print
        print('  - $error');
      }
    }

    // ignore: avoid_print
    print('Exit code: ${result.exitCode.code}');
    // ignore: avoid_print
    print('-----------------------------');
  }

  /// Generate sample CI configuration for testing
  static CiConfig createSampleConfig({
    String? projectName,
    String? outputDirectory,
  }) {
    return CiConfig(
      projectName: projectName ?? 'GapScope Sample Project',
      outputDirectory: outputDirectory ?? './gapscope_reports',
      reportFormat: ReportFormat.html,
      failOnCritical: true,
      failOnError: false,
    );
  }
}
