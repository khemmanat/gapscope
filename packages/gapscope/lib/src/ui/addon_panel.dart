import 'package:flutter/material.dart';
import '../addons/gapscope_addon.dart';
import 'theme_addon_control.dart';
import 'device_addon_control.dart';

/// Panel for addon controls
class AddonPanel extends StatelessWidget {
  final List<GapScopeAddon> addons;
  final double width;

  const AddonPanel({
    super.key,
    this.addons = const [],
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    if (addons.isEmpty) {
      return _buildEmptyPanel(context);
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
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
              padding: const EdgeInsets.all(16),
              children: _buildAddonControls(context),
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
            Icons.extension,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Addons',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAddonControls(BuildContext context) {
    return addons.map((addon) {
      return _buildAddonControl(context, addon);
    }).toList();
  }

  Widget _buildAddonControl(BuildContext context, GapScopeAddon addon) {
    switch (addon.id) {
      case 'theme_addon':
        return ThemeAddonControl(
          addon: addon as dynamic, // Type cast for specific addon types
        );
      case 'device_addon':
        return DeviceAddonControl(
          addon: addon as dynamic, // Type cast for specific addon types
        );
      default:
        return _buildDefaultAddonControl(context, addon);
    }
  }

  Widget _buildDefaultAddonControl(BuildContext context, GapScopeAddon addon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.extension_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    addon.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (addon.description != null) ...[
              const SizedBox(height: 8),
              Text(
                addon.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enabled'),
              value: addon.isEnabled,
              onChanged: null, // TODO: Implement toggle
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPanel(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.extension_off,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'No addons available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}