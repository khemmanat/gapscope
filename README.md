# GapScope Studio

GapScope Studio is a Flutter component workbench and runtime QA inspector for design systems and UI debugging.

It combines component stories with practical runtime inspection tools for checking layout behavior while building Flutter interfaces.

## Packages

```txt
packages/gapscope        Reusable Flutter package
apps/gapscope_studio_app Development and preview app
docs                     Public development docs
```

## Getting Started

Install dependencies for the workspace:

```bash
dart pub get
cd packages/gapscope
flutter pub get
```

Run tests:

```bash
cd packages/gapscope
flutter test
```

Run the studio app:

```bash
cd apps/gapscope_studio_app
flutter run
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:gapscope/gapscope.dart';

void main() {
  runApp(
    MaterialApp(
      home: GapScopeStudio(
        title: 'Design System',
        components: [
          GapScopeComponent(
            id: 'buttons',
            name: 'Buttons',
            stories: [
              GapScopeStory(
                id: 'primary',
                name: 'Primary',
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
    ),
  );
}
```

## Documentation

- [Package README](packages/gapscope/README.md)
- [Development Guide](docs/DEVELOPMENT.md)

## License

MIT. See [packages/gapscope/LICENSE](packages/gapscope/LICENSE).
