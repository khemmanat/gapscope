# GapScope Studio

[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)

GapScope is a Flutter component workbench and runtime inspection package for building and checking design-system UI.

It provides a story-based preview surface, lightweight addons, and runtime layout inspection utilities for Flutter apps.

## Features

- Component and story organization
- Interactive preview shell
- Theme and device preview addons
- Runtime layout inspection primitives
- Screenshot and report helpers for local QA workflows

## Installation

```yaml
dependencies:
  gapscope: ^1.0.0
```

For local development in this repository:

```yaml
dependencies:
  gapscope:
    path: ../../packages/gapscope
```

## Basic Usage

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
        title: 'Design System',
        components: [
          GapScopeComponent(
            id: 'buttons',
            name: 'Buttons',
            stories: [
              GapScopeStory(
                id: 'primary_button',
                name: 'Primary Button',
                builder: (context) => const FilledButton(
                  onPressed: null,
                  child: Text('Primary'),
                ),
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

## Runtime Inspector

```dart
final controller = GapScopeController();

GapScopeInspector(
  controller: controller,
  child: const MyApp(),
);
```

## Development

Run tests from the package directory:

```bash
flutter test
```

Run the example:

```bash
cd example
flutter run
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
