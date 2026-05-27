# GapScope Studio Example

This is a comprehensive example demonstrating how to use GapScope Studio in your Flutter project.

## Features Demonstrated

- **Component Organization**: How to structure your design system components
- **Story System**: Creating multiple story variations for each component
- **Inspector Integration**: Using the built-in runtime QA inspector
- **Addon System**: Theme and device simulation addons
- **Export Capabilities**: Screenshot and QA report generation

## Usage

### Running the Example

```bash
cd example
flutter run
```

### Key Features

#### Component Organization
```dart
final buttonComponent = GapScopeComponent(
  id: 'buttons',
  name: 'Buttons',
  description: 'Material Design button examples',
  stories: [
    GapScopeStory(
      id: 'filled_button',
      name: 'Filled Button',
      builder: (context) => const FilledButtonExample(),
    ).toStoryData(),
  ],
);
```

#### Inspector Modes
- **Bounds**: See widget boundaries and sizes
- **Spacing**: Measure distances between widgets
- **Flex**: Analyze flex layout spacing
- **Whitespace**: Detect spacing inconsistencies
- **Overlay**: Inspect dialogs and bottom sheets
- **Tap Target**: Verify Material Design compliance

#### Addons
- **ThemeAddon**: Switch between light/dark themes
- **DeviceAddon**: Test different device sizes

### Best Practices

1. **Component Structure**: Group related widgets into components
2. **Story Variations**: Create multiple stories per component
3. **Clear Naming**: Use descriptive IDs and names
4. **Documentation**: Add descriptions for components and stories
5. **Testing**: Use inspector modes for QA

## Integration

### Adding to Your Project

```yaml
dependencies:
  gapscope: ^1.0.0
```

```dart
import 'package:gapscope/gapscope.dart';

void main() {
  runApp(YourDesignSystem());
}

class YourDesignSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GapScopeStudio(
      title: 'Your Design System',
      components: [
        // Your components here
      ],
      addons: [
        ThemeAddon(),
        DeviceAddon(),
      ],
    );
  }
}
```

### Inspector Usage

1. Click the inspector toggle in the toolbar
2. Select different inspection modes from the dropdown
3. Interact with widgets to see their properties
4. Use the measure tool to check spacing
5. Export screenshots and QA reports

## Export Features

### Screenshots
- Click the camera icon to capture screenshots
- Supports PNG, WebP, and JPEG formats
- Adjustable quality and resolution

### QA Reports
- Generate comprehensive QA reports
- Include screenshots, issues, and metrics
- Export to JSON, HTML, or Markdown

## Tips

- Start with simple components
- Add stories incrementally
- Use theme addon for responsive testing
- Leverage device addon for mobile testing
- Export reports for documentation

## Support

For more information, visit the main package repository.