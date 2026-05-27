import 'package:flutter/material.dart';
import '../models/story_data.dart';
import '../studio/gapscope_catalog.dart';
import '../studio/gapscope_component.dart';

/// Sidebar for component and story navigation
class ComponentSidebar extends StatelessWidget {
  const ComponentSidebar({
    super.key,
    required this.catalog,
    this.selectedStory,
    required this.onStorySelected,
    this.width = 300,
  });
  final GapScopeCatalog catalog;
  final StoryData? selectedStory;
  final ValueChanged<StoryData> onStorySelected;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              children: _buildComponentLists(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.view_list,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Components',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildComponentLists(BuildContext context) {
    final components = catalog.components;

    if (components.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No components available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ];
    }

    return components.map<Widget>((component) {
      return _buildComponentExpansionTile(context, component);
    }).toList();
  }

  Widget _buildComponentExpansionTile(
    BuildContext context,
    GapScopeComponent component,
  ) {
    return ExpansionTile(
      title: Text(component.name),
      subtitle: component.description != null
          ? Text(
              component.description!,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      leading: Icon(
        Icons.folder_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: _buildStoryList(context, component),
    );
  }

  List<Widget> _buildStoryList(
    BuildContext context,
    GapScopeComponent component,
  ) {
    if (component.stories.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'No stories',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ];
    }

    return component.stories.map<Widget>((story) {
      final isSelected = selectedStory?.id == story.id;
      return ListTile(
        title: Text(story.name),
        subtitle: story.description != null
            ? Text(
                story.description!,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        leading: Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        selected: isSelected,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        onTap: () => onStorySelected(story),
      );
    }).toList();
  }
}
