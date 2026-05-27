import 'package:flutter/material.dart';
import 'package:gapscope/gapscope.dart';

void main() {
  runApp(const GapScopeStudioApp());
}

class GapScopeStudioApp extends StatelessWidget {
  const GapScopeStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GapScope Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const GapScopeStudioHome(),
    );
  }
}

class GapScopeStudioHome extends StatelessWidget {
  const GapScopeStudioHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Create example components and stories for Phase 1 demo
    final buttonComponent = GapScopeComponent(
      id: 'buttons',
      name: 'Buttons',
      description: 'Button component examples',
      stories: [
        GapScopeStory(
          id: 'filled_button',
          name: 'Filled Button',
          description: 'Primary filled button example',
          builder: (context) => const FilledButtonExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'outlined_button',
          name: 'Outlined Button',
          description: 'Outlined button example',
          builder: (context) => const OutlinedButtonExample(),
        ).toStoryData(),
      ],
    );

    final textComponent = GapScopeComponent(
      id: 'text',
      name: 'Text',
      description: 'Text component examples',
      stories: [
        GapScopeStory(
          id: 'headline',
          name: 'Headline',
          description: 'Large headline text example',
          builder: (context) => const HeadlineExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'body_text',
          name: 'Body Text',
          description: 'Body text example',
          builder: (context) => const BodyTextExample(),
        ).toStoryData(),
      ],
    );

    final cardComponent = GapScopeComponent(
      id: 'cards',
      name: 'Cards',
      description: 'Card component examples',
      stories: [
        GapScopeStory(
          id: 'basic_card',
          name: 'Basic Card',
          description: 'Simple card example',
          builder: (context) => const BasicCardExample(),
        ).toStoryData(),
      ],
    );

    // Phase 5: Export component examples
    final exportComponent = GapScopeComponent(
      id: 'exports',
      name: 'Export Demo',
      description: 'Screenshot export and QA report generation examples',
      stories: [
        GapScopeStory(
          id: 'screenshot_example',
          name: 'Screenshot Example',
          description: 'Test screenshot capture with export controls',
          builder: (context) => const ScreenshotExportExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'qa_report_example',
          name: 'QA Report Example',
          description: 'QA report generation example',
          builder: (context) => const QaReportExample(),
        ).toStoryData(),
      ],
    );

    // Phase 3: Overlay component examples
    final overlayComponent = GapScopeComponent(
      id: 'overlays',
      name: 'Overlays',
      description: 'Dialog, bottom sheet, and dropdown overlay examples',
      stories: [
        GapScopeStory(
          id: 'dialog_example',
          name: 'Dialog Example',
          description: 'Simple dialog with overlay tracking',
          builder: (context) => const DialogExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'bottom_sheet_example',
          name: 'Bottom Sheet Example',
          description: 'Bottom sheet with overlay tracking',
          builder: (context) => const BottomSheetExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'dropdown_example',
          name: 'Dropdown Example',
          description: 'Dropdown menu with overlay tracking',
          builder: (context) => const DropdownExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'mixed_overlays',
          name: 'Mixed Overlays',
          description: 'Story with multiple overlay types',
          builder: (context) => const MixedOverlaysExample(),
        ).toStoryData(),
      ],
    );

    // Phase 4: Advanced QA features
    final qaComponent = GapScopeComponent(
      id: 'qa_features',
      name: 'QA Features',
      description: 'Advanced quality assurance analysis features',
      stories: [
        GapScopeStory(
          id: 'flex_layout_example',
          name: 'Flex Layout Analysis',
          description: 'Row and Column layout with gap detection',
          builder: (context) => const FlexLayoutExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'tap_target_example',
          name: 'Tap Target Testing',
          description: 'Material Design tap target compliance checking',
          builder: (context) => const TapTargetExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'whitespace_example',
          name: 'Whitespace Analysis',
          description: 'Spacing consistency and whitespace detection',
          builder: (context) => const WhitespaceExample(),
        ).toStoryData(),
      ],
    );

    return GapScopeStudio(
      title: 'GapScope Studio',
      components: [buttonComponent, textComponent, cardComponent, overlayComponent, qaComponent, exportComponent],
      addons: [
        ThemeAddon(),
        DeviceAddon(),
      ],
    );
  }
}

// Example story widgets
class FilledButtonExample extends StatelessWidget {
  const FilledButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton(
          onPressed: () {},
          child: const Text('Filled Button'),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('With Icon'),
        ),
      ],
    );
  }
}

class OutlinedButtonExample extends StatelessWidget {
  const OutlinedButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {},
          child: const Text('Outlined Button'),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.star),
          label: const Text('With Icon'),
        ),
      ],
    );
  }
}

class HeadlineExample extends StatelessWidget {
  const HeadlineExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Headline Large',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Headline Medium',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Headline Small',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BodyTextExample extends StatelessWidget {
  const BodyTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Body Large - Lorem ipsum dolor sit amet'),
          SizedBox(height: 8),
          Text('Body Medium - consectetur adipiscing elit'),
          SizedBox(height: 8),
          Text('Body Small - sed do eiusmod tempor incididunt'),
        ],
      ),
    );
  }
}

class BasicCardExample extends StatelessWidget {
  const BasicCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 48, color: Theme.of(context).colorScheme.primary),
              SizedBox(height: 16),
              Text('Card Title', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              Text('Card description goes here with some details about the content.'),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () {},
                child: Text('Action'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Phase 3 Overlay Examples

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () => _showDialog(context),
        child: const Text('Show Dialog'),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return GapScopeDialogRegion(
          id: 'example_dialog',
          name: 'Example Dialog',
          child: AlertDialog(
            title: const Text('Dialog Title'),
            content: const Text('This is a dialog with overlay tracking enabled.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () => _showBottomSheet(context),
        child: const Text('Show Bottom Sheet'),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return GapScopeBottomSheetRegion(
          id: 'example_bottom_sheet',
          name: 'Example Bottom Sheet',
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bottom Sheet Title',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                const Text('This is a bottom sheet with overlay tracking.'),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DropdownExample extends StatelessWidget {
  const DropdownExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: DropdownButtonExample(),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: selectedValue,
        hint: const Text('Select an option'),
        items: ['Option 1', 'Option 2', 'Option 3'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: GapScopeDropdownRegion(
              id: 'dropdown_item_$value',
              name: 'Dropdown: $value',
              child: Text(value),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue;
          });
        },
      ),
    );
  }
}

class MixedOverlaysExample extends StatelessWidget {
  const MixedOverlaysExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton(
            onPressed: () => _showDialog(context),
            child: const Text('Show Dialog'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _showBottomSheet(context),
            child: const Text('Show Bottom Sheet'),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return GapScopeDialogRegion(
          id: 'mixed_dialog',
          name: 'Mixed Dialog',
          child: AlertDialog(
            title: const Text('Mixed Dialog'),
            content: const Text('This dialog can coexist with bottom sheets.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return GapScopeBottomSheetRegion(
          id: 'mixed_bottom_sheet',
          name: 'Mixed Bottom Sheet',
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Mixed Bottom Sheet',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                const Text('This bottom sheet can coexist with dialogs.'),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Phase 4 QA Feature Examples

class FlexLayoutExample extends StatelessWidget {
  const FlexLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Flex Layout Analysis'),
          const SizedBox(height: 20),
          // Row example
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Button 1')),
              const SizedBox(width: 16),
              ElevatedButton(onPressed: () {}, child: const Text('Button 2')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () {}, child: const Text('Button 3')),
            ],
          ),
          const SizedBox(height: 20),
          // Column example
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Icon(Icons.star),
                  const SizedBox(height: 8),
                  const Icon(Icons.favorite),
                  const SizedBox(height: 8),
                  const Icon(Icons.thumb_up),
                ],
              ),
              const SizedBox(width: 32),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 40,
                    color: Colors.blue.shade100,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 40,
                    color: Colors.green.shade100,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 40,
                    color: Colors.orange.shade100,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TapTargetExample extends StatelessWidget {
  const TapTargetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tap Target Testing', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Good tap targets (48x48+):'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Good Button'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Good Button'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Good Button'),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  tooltip: 'Good Icon',
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Problematic tap targets (< 48x48):'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  color: Colors.red.shade100,
                  child: InkWell(
                    onTap: () {},
                    child: const Center(child: Text('Tiny')),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Small Text'),
                ),
                Container(
                  width: 35,
                  height: 35,
                  color: Colors.orange.shade100,
                  child: InkWell(
                    onTap: () {},
                    child: const Icon(Icons.star, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WhitespaceExample extends StatelessWidget {
  const WhitespaceExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Whitespace Analysis', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),

            // Example with good spacing
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('Good Spacing Example'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCard('Card 1'),
                      _buildCard('Card 2'),
                      _buildCard('Card 3'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Example with inconsistent spacing
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('Inconsistent Spacing Example'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildCard('Card A'),
                      const SizedBox(width: 8),
                      _buildCard('Card B'),
                      const SizedBox(width: 32),
                      _buildCard('Card C'),
                      const SizedBox(width: 4),
                      _buildCard('Card D'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Example with excessive whitespace
            Container(
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Excessive Whitespace Example'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCard(String title) {
  return Container(
    width: 80,
    height: 60,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 10),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

// Phase 5 Export Examples

class ScreenshotExportExample extends StatefulWidget {
  const ScreenshotExportExample({super.key});

  @override
  State<ScreenshotExportExample> createState() => _ScreenshotExportExampleState();
}

class _ScreenshotExportExampleState extends State<ScreenshotExportExample> {
  final ScreenshotExporter _exporter = ScreenshotExporter();
  bool _isExporting = false;
  String? _lastExportPath;

  Future<void> _captureScreenshot() async {
    setState(() {
      _isExporting = true;
    });

    try {
      final config = ExportConfig.highQuality;
      final result = await _exporter.captureScreenshot(config);

      setState(() {
        _lastExportPath = result.filename;
        _isExporting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Screenshot saved: ${result.filename}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Screenshot failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.screenshot, size: 64, color: Colors.blue),
          const SizedBox(height: 24),
          const Text(
            'Screenshot Export Demo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Capture screenshots with different quality settings'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _isExporting ? null : _captureScreenshot,
            icon: _isExporting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.camera_alt),
            label: Text(_isExporting ? 'Capturing...' : 'Capture Screenshot'),
          ),
          if (_lastExportPath != null) ...[
            const SizedBox(height: 16),
            Text('Last export: $_lastExportPath'),
          ],
        ],
      ),
    );
  }
}

class QaReportExample extends StatefulWidget {
  const QaReportExample({super.key});

  @override
  State<QaReportExample> createState() => _QaReportExampleState();
}

class _QaReportExampleState extends State<QaReportExample> {
  bool _isGenerating = false;
  QAReport? _lastReport;

  Future<void> _generateReport() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      // Create sample data for demo
      final screenshots = <ScreenshotResult>[];
      final issues = QAReportGenerator.createSampleIssues();
      final metrics = QAReportGenerator.createSampleMetrics();

      final report = await QAReportGenerator.generateReport(
        title: 'GapScope QA Demo Report',
        screenshots: screenshots,
        issues: issues,
        metrics: metrics,
        format: ReportFormat.html,
        description: 'Sample QA report generated from GapScope Studio',
      );

      setState(() {
        _lastReport = report;
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QA Report generated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report generation failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assessment, size: 64, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'QA Report Generator Demo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Generate comprehensive QA reports with issue tracking'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isGenerating ? null : _generateReport,
              icon: _isGenerating
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.description),
              label: Text(_isGenerating ? 'Generating...' : 'Generate QA Report'),
            ),
            if (_lastReport != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Report ID: ${_lastReport!.id}'),
                    const SizedBox(height: 8),
                    Text('Generated: ${_lastReport!.timestamp.toIso8601String()}'),
                    const SizedBox(height: 8),
                    Text('Total Issues: ${_lastReport!.issues.length}'),
                    const SizedBox(height: 8),
                    Text('Critical: ${_lastReport!.getIssueCount(IssueSeverity.critical)}'),
                    const SizedBox(height: 8),
                    Text('Errors: ${_lastReport!.getIssueCount(IssueSeverity.error)}'),
                    const SizedBox(height: 8),
                    Text('Warnings: ${_lastReport!.getIssueCount(IssueSeverity.warning)}'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}