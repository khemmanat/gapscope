import 'package:flutter/material.dart';
import '../models/story_data.dart';
import '../inspector/gapscope_inspector.dart';
import '../inspector/gapscope_controller.dart';

/// Canvas for rendering story previews with inspector support
class StoryCanvas extends StatelessWidget {
  final StoryData story;
  final bool inspectorEnabled;
  final GapScopeController? inspectorController;

  const StoryCanvas({
    super.key,
    required this.story,
    this.inspectorEnabled = false,
    this.inspectorController,
  });

  @override
  Widget build(BuildContext context) {
    final storyWidget = _buildStoryContent(context);

    final wrappedWidget = inspectorEnabled
        ? GapScopeInspector(
            enabled: true,
            controller: inspectorController,
            child: storyWidget,
          )
        : storyWidget;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Card(
            elevation: 2,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800,
                maxHeight: 800,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoryHeader(context),
                    const Divider(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: wrappedWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          story.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (story.description != null) ...[
          const SizedBox(height: 8),
          Text(
            story.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
        if (story.category != null) ...[
          const SizedBox(height: 8),
          Chip(
            label: Text(story.category!),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ],
      ],
    );
  }

  Widget _buildStoryContent(BuildContext context) {
    try {
      return story.builder(context);
    } catch (e) {
      return _buildErrorWidget(context, e);
    }
  }

  Widget _buildErrorWidget(BuildContext context, Object error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                'Story Error',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
          ),
        ],
      ),
    );
  }
}