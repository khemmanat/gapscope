import 'package:flutter/material.dart';

import '../addons/device_addon.dart';
import '../addons/theme_addon.dart';
import '../inspector/gapscope_controller.dart';
import '../inspector/gapscope_inspector.dart';
import '../models/story_data.dart';

/// Canvas for rendering story previews with inspector support
class StoryCanvas extends StatelessWidget {
  const StoryCanvas({
    super.key,
    required this.story,
    this.inspectorEnabled = false,
    this.inspectorController,
    this.themeState,
    this.deviceState,
  });
  final StoryData story;
  final bool inspectorEnabled;
  final GapScopeController? inspectorController;
  final ThemeAddonState? themeState;
  final DeviceAddonState? deviceState;

  @override
  Widget build(BuildContext context) {
    final storyWidget = _applyDeviceState(
      context,
      _applyThemeState(context, _buildStoryContent(context)),
    );

    final wrappedWidget = inspectorEnabled
        ? GapScopeInspector(
            enabled: true,
            controller: inspectorController,
            child: storyWidget,
          )
        : storyWidget;

    return ColoredBox(
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

  Widget _applyThemeState(BuildContext context, Widget child) {
    if (themeState == null || !themeState!.enabled) {
      return child;
    }

    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final useDarkTheme = switch (themeState!.themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };
    final theme = useDarkTheme
        ? themeState!.darkTheme ?? ThemeAddon.defaultDarkTheme
        : themeState!.lightTheme ?? ThemeAddon.defaultLightTheme;

    return Theme(
      data: theme,
      child: child,
    );
  }

  Widget _applyDeviceState(BuildContext context, Widget themedChild) {
    if (deviceState == null || !deviceState!.enabled) {
      return themedChild;
    }

    final device = deviceState!.selectedDevice;
    if (device == null) {
      return themedChild;
    }

    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: device.size.width,
        height: device.size.height,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            size: device.size,
            padding: EdgeInsets.zero,
            viewInsets: EdgeInsets.zero,
            viewPadding: EdgeInsets.zero,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(platform: device.platform),
            child: themedChild,
          ),
        ),
      ),
    );
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
