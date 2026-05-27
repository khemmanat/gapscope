import 'package:flutter/material.dart';
import '../addons/device_addon.dart';

/// Control widget for device addon
class DeviceAddonControl extends StatefulWidget {
  final DeviceAddon addon;

  const DeviceAddonControl({
    super.key,
    required this.addon,
  });

  @override
  State<DeviceAddonControl> createState() => _DeviceAddonControlState();
}

class _DeviceAddonControlState extends State<DeviceAddonControl> {
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
                  Icons.phone_android,
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
            _buildDeviceSelector(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceSelector(BuildContext context) {
    final selectedDevice = widget.addon.state.selectedDevice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Preview',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        DropdownButton<DeviceInfo>(
          isExpanded: true,
          value: selectedDevice,
          hint: const Text('Select a device'),
          items: DeviceAddon.defaultDevices.map((device) {
            return DropdownMenuItem(
              value: device,
              child: Row(
                children: [
                  Icon(
                    _getDeviceIcon(device.platform),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(device.name),
                  ),
                  Text(
                    '${device.size.width.toInt()}×${device.size.height.toInt()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (DeviceInfo? device) {
            if (device != null) {
              _onDeviceChanged(device);
            }
          },
        ),
      ],
    );
  }

  IconData _getDeviceIcon(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return Icons.phone_iphone;
      case TargetPlatform.android:
        return Icons.phone_android;
      case TargetPlatform.macOS:
        return Icons.laptop;
      case TargetPlatform.windows:
        return Icons.computer;
      case TargetPlatform.linux:
        return Icons.computer;
      default:
        return Icons.devices;
    }
  }

  void _onDeviceChanged(DeviceInfo device) {
    // TODO: Implement device change
    // This will require updating the addon state
    // and applying device frame to canvas
  }
}