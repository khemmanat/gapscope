import 'package:flutter/material.dart';
import '../addons/theme_addon.dart';

/// Control widget for theme addon
class ThemeAddonControl extends StatefulWidget {

  const ThemeAddonControl({
    super.key,
    required this.addon,
  });
  final ThemeAddon addon;

  @override
  State<ThemeAddonControl> createState() => _ThemeAddonControlState();
}

class _ThemeAddonControlState extends State<ThemeAddonControl> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.addon.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (widget.addon.description != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.addon.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 16),
            _buildThemeModeSelector(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Mode',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              value: ThemeMode.system,
              label: Text('System'),
              icon: Icon(Icons.brightness_auto),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              label: Text('Light'),
              icon: Icon(Icons.light_mode),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode),
            ),
          ],
          selected: {widget.addon.state.themeMode},
          onSelectionChanged: (Set<ThemeMode> modes) {
            if (modes.isNotEmpty) {
              _onThemeModeChanged(modes.first);
            }
          },
        ),
      ],
    );
  }

  void _onThemeModeChanged(ThemeMode mode) {
    // TODO: Implement theme mode change
    // This will require updating the app's theme mode
    // and notifying the addon of the change
  }
}