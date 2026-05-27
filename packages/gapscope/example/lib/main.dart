import 'package:flutter/material.dart';
import 'package:gapscope/gapscope.dart';

void main() {
  runApp(const GapScopeExample());
}

class GapScopeExample extends StatelessWidget {
  const GapScopeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GapScope Studio Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatelessWidget {
  const ExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Create example components
    final buttonComponent = GapScopeComponent(
      id: 'buttons',
      name: 'Buttons',
      description: 'Material Design button examples',
      stories: [
        GapScopeStory(
          id: 'filled_button',
          name: 'Filled Button',
          description: 'Primary filled button',
          builder: (context) => const FilledButtonExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'outlined_button',
          name: 'Outlined Button',
          description: 'Secondary outlined button',
          builder: (context) => const OutlinedButtonExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'text_button',
          name: 'Text Button',
          description: 'Text button without border',
          builder: (context) => const TextButtonExample(),
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
          description: 'Simple card with content',
          builder: (context) => const BasicCardExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'elevated_card',
          name: 'Elevated Card',
          description: 'Card with elevation',
          builder: (context) => const ElevatedCardExample(),
        ).toStoryData(),
      ],
    );

    final inputComponent = GapScopeComponent(
      id: 'inputs',
      name: 'Inputs',
      description: 'Text input and form fields',
      stories: [
        GapScopeStory(
          id: 'text_field',
          name: 'Text Field',
          description: 'Material text field',
          builder: (context) => const TextFieldExample(),
        ).toStoryData(),
      ],
    );

    final layoutComponent = GapScopeComponent(
      id: 'layouts',
      name: 'Layouts',
      description: 'Layout examples for testing',
      stories: [
        GapScopeStory(
          id: 'row_layout',
          name: 'Row Layout',
          description: 'Row with spacing',
          builder: (context) => const RowLayoutExample(),
        ).toStoryData(),
        GapScopeStory(
          id: 'column_layout',
          name: 'Column Layout',
          description: 'Column with spacing',
          builder: (context) => const ColumnLayoutExample(),
        ).toStoryData(),
      ],
    );

    return GapScopeStudio(
      title: 'GapScope Examples',
      components: [
        buttonComponent,
        cardComponent,
        inputComponent,
        layoutComponent,
      ],
      addons: [
        ThemeAddon(),
        DeviceAddon(),
      ],
    );
  }
}

// Example Widgets

class FilledButtonExample extends StatelessWidget {
  const FilledButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
      ),
    );
  }
}

class OutlinedButtonExample extends StatelessWidget {
  const OutlinedButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {},
            child: const Text('Outlined Button'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.remove),
            label: const Text('With Icon'),
          ),
        ],
      ),
    );
  }
}

class TextButtonExample extends StatelessWidget {
  const TextButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: const Text('Text Button'),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text('Card Title', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('Card description goes here with some details.'),
            ],
          ),
        ),
      ),
    );
  }
}

class ElevatedCardExample extends StatelessWidget {
  const ElevatedCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Elevated Card', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('This card has elevation'),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldExample extends StatelessWidget {
  const TextFieldExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Input',
          border: OutlineInputBorder(),
          helperText: 'Enter some text',
        ),
      ),
    );
  }
}

class RowLayoutExample extends StatelessWidget {
  const RowLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            color: Colors.blue,
            child: const Center(child: Text('1', style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 60,
            color: Colors.green,
            child: const Center(child: Text('2', style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 60,
            color: Colors.orange,
            child: const Center(child: Text('3', style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}

class ColumnLayoutExample extends StatelessWidget {
  const ColumnLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            color: Colors.purple,
            child: const Center(child: Text('1', style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 60,
            color: Colors.teal,
            child: const Center(child: Text('2', style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 60,
            color: Colors.amber,
            child: const Center(child: Text('3', style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}