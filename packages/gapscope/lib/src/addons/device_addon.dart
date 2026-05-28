import 'package:flutter/material.dart';
import '../models/addon_state.dart';
import 'gapscope_addon.dart';

/// Device information model
class DeviceInfo {
  const DeviceInfo({
    required this.id,
    required this.name,
    required this.platform,
    required this.size,
  });
  final String id;
  final String name;
  final TargetPlatform platform;
  final Size size;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceInfo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Device addon state model
class DeviceAddonState extends AddonState {
  const DeviceAddonState({
    super.enabled = true,
    this.selectedDevice,
  });
  final DeviceInfo? selectedDevice;

  @override
  DeviceAddonState copyWith({
    bool? enabled,
    DeviceInfo? selectedDevice,
    bool clearSelectedDevice = false,
  }) {
    return DeviceAddonState(
      enabled: enabled ?? this.enabled,
      selectedDevice:
          clearSelectedDevice ? null : selectedDevice ?? this.selectedDevice,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceAddonState &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          selectedDevice == other.selectedDevice;

  @override
  int get hashCode => Object.hash(enabled, selectedDevice);
}

/// Device addon for previewing different device frames
class DeviceAddon extends GapScopeAddon<DeviceAddonState> {
  DeviceAddon({
    this.state = const DeviceAddonState(),
  });
  @override
  String get id => 'device_addon';

  @override
  String get name => 'Device Preview';

  @override
  String? get description => 'Preview components in different device frames';

  @override
  final DeviceAddonState state;

  static const List<DeviceInfo> defaultDevices = [
    DeviceInfo(
      id: 'iphone_se',
      name: 'iPhone SE',
      platform: TargetPlatform.iOS,
      size: Size(375, 667),
    ),
    DeviceInfo(
      id: 'iphone_14',
      name: 'iPhone 14',
      platform: TargetPlatform.iOS,
      size: Size(390, 844),
    ),
    DeviceInfo(
      id: 'iphone_14_pro_max',
      name: 'iPhone 14 Pro Max',
      platform: TargetPlatform.iOS,
      size: Size(430, 932),
    ),
    DeviceInfo(
      id: 'ipad_mini',
      name: 'iPad Mini',
      platform: TargetPlatform.iOS,
      size: Size(744, 1133),
    ),
    DeviceInfo(
      id: 'ipad_pro_11',
      name: 'iPad Pro 11"',
      platform: TargetPlatform.iOS,
      size: Size(834, 1194),
    ),
    DeviceInfo(
      id: 'pixel_7',
      name: 'Pixel 7',
      platform: TargetPlatform.android,
      size: Size(412, 915),
    ),
    DeviceInfo(
      id: 'pixel_fold',
      name: 'Pixel Fold',
      platform: TargetPlatform.android,
      size: Size(673, 841),
    ),
    DeviceInfo(
      id: 'galaxy_s23',
      name: 'Galaxy S23',
      platform: TargetPlatform.android,
      size: Size(360, 780),
    ),
    DeviceInfo(
      id: 'galaxy_tab_s8',
      name: 'Galaxy Tab S8',
      platform: TargetPlatform.android,
      size: Size(800, 1280),
    ),
    DeviceInfo(
      id: 'macbook',
      name: 'MacBook Pro',
      platform: TargetPlatform.macOS,
      size: Size(1440, 900),
    ),
    DeviceInfo(
      id: 'desktop_1080p',
      name: 'Desktop 1080p',
      platform: TargetPlatform.windows,
      size: Size(1920, 1080),
    ),
  ];

  @override
  DeviceAddonState updateState(DeviceAddonState state) {
    return state;
  }

  DeviceAddon copyWith(DeviceAddonState? state) {
    return DeviceAddon(
      state: state ?? this.state,
    );
  }
}
