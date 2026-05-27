# GapScope Studio

[![Pub](https://img.shields.io/badge/pub-v1.0.0-blue)](https://pub.dev/packages/gapscope)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter component workbench and runtime QA inspector for professional design systems and UI testing.

## ✨ Features

### 🎨 Component Workbench
- **Story System**: Organize components with multiple variations
- **Interactive Preview**: Real-time component rendering
- **Addon Ecosystem**: Theme, device, and custom addons
- **Material 3**: Built-in Material Design 3 support

### 🔍 Runtime QA Inspector
- **Bounds Inspection**: Visual widget boundaries and sizes
- **Spacing Analysis**: Measure distances between widgets
- **Flex Layout Detection**: Analyze flex spacing and gaps
- **Whitespace Detection**: Find spacing inconsistencies
- **Overlay Inspection**: Inspect dialogs, bottom sheets, and more
- **Tap Target Checking**: Verify Material Design compliance (48x48dp)
- **Constraint Analysis**: Understand widget constraints

### 📊 Export & Reporting
- **Screenshot Export**: PNG, WebP, JPEG formats with quality control
- **QA Report Generation**: JSON, HTML, Markdown formats
- **Golden Testing**: Integration with Flutter golden tests
- **CI/CD Support**: Automated quality pipelines

### 🌐 Cross-Platform
- **Web**: Full support for Flutter Web
- **Mobile**: iOS and Android optimized
- **Desktop**: macOS, Windows, Linux support

## 🚀 Getting Started

### Installation

```yaml
dependencies:
  gapscope: ^1.0.0
```

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:gapscope/gapscope.dart';

void main() {
  runApp(const DesignSystemApp());
}

class DesignSystemApp extends StatelessWidget {
  const DesignSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GapScopeStudio(
        title: 'My Design System',
        components: [
          GapScopeComponent(
            id: 'buttons',
            name: 'Buttons',
            description: 'Button component library',
            stories: [
              GapScopeStory(
                id: 'primary_button',
                name: 'Primary Button',
                description: 'Main action button',
                builder: (context) => const MyPrimaryButton(),
              ).toStoryData(),
              GapScopeStory(
                id: 'secondary_button',
                name: 'Secondary Button',
                description: 'Secondary action button',
                builder: (context) => const MySecondaryButton(),
              ).toStoryData(),
            ],
          ),
        ],
        addons: [
          ThemeAddon(),
          DeviceAddon(),
        ],
      ),
    );
  }
}
```

## 🎯 Inspector Modes

### 1. Bounds Mode
Visualize widget boundaries and sizes with precise measurements.

### 2. Spacing Mode
Measure distances between widgets and detect spacing issues.

### 3. Flex Mode
Analyze flex layouts, detect gaps, and visualize spacing distribution.

### 4. Whitespace Mode
Detect inconsistent spacing and excessive whitespace regions.

### 5. Overlay Mode
Inspect dialogs, bottom sheets, and other overlay widgets.

### 6. Tap Target Mode
Verify Material Design tap target compliance (48x48dp minimum).

### 7. Constraints Mode
Understand widget constraints and rendering behavior.

## 📦 Export Features

### Screenshot Export
```dart
final exporter = ScreenshotExporter();
final config = ExportConfig.highQuality;

final result = await exporter.captureScreenshot(config);
// result.data - Image bytes
// result.filename - Generated filename
// result.fileSizeKB - File size in KB
```

### QA Report Generation
```dart
final report = await QAReportGenerator.generateReport(
  title: 'My QA Report',
  screenshots: [screenshot1, screenshot2],
  issues: [issue1, issue2],
  metrics: {'total_widgets': 42},
  format: ReportFormat.html,
);

// Generate report in different formats
final htmlReport = await report.generateReport();
```

## 🔧 Advanced Usage

### Custom Inspector Controller
```dart
class MyComponent extends StatefulWidget {
  @override
  State<MyComponent> createState() => _MyComponentState();
}

class _MyComponentState extends State<MyComponent> {
  final _inspectorController = GapScopeController();

  @override
  Widget build(BuildContext context) {
    return GapScopeInspector(
      controller: _inspectorController,
      child: MyWidget(),
    );
  }
}
```

### CI/CD Integration
```dart
final config = CiConfig(
  projectName: 'My Project',
  outputDirectory: './qa_reports',
  failOnCritical: true,
);

final result = await CiAutomation.runPipeline(
  config,
  captureScreenshots,
  collectIssues,
  collectMetrics,
);

// result.success - Overall CI status
// result.exitCode - Process exit code
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Web      | ✅ Full | All features supported |
| iOS      | ✅ Full | Native performance |
| Android  | ✅ Full | Material Design optimized |
| macOS    | ✅ Full | Desktop experience |
| Windows  | ✅ Full | Desktop experience |
| Linux    | ✅ Full | Desktop experience |

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Run Example
```bash
cd example
flutter run
```

## 🎨 Design System Integration

Perfect for:
- **Design Systems**: Component libraries and design tokens
- **UI Kits**: Reusable component collections
- **QA Teams**: Runtime quality assurance
- **Development**: Component development and testing
- **Documentation**: Interactive component docs

## 📚 Examples

See the [example](https://github.com/yourusername/gapscope/tree/main/example) folder for comprehensive usage examples including:
- Component organization
- Story variations
- Inspector usage
- Export workflows
- CI/CD integration

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/yourusername/gapscope/blob/main/LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by popular tools like Widgetbook and Storybook
- Built for Flutter's Material Design 3 ecosystem
- Designed for professional design system workflows

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/gapscope/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/gapscope/discussions)
- **Email**: support@gapscope.dev

---

Made with ❤️ for the Flutter community