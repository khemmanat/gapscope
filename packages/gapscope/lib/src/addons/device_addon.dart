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
      other is DeviceInfo &&
          runtimeType == other.runtimeType &&
          id == other.id;

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
  }) {
    return DeviceAddonState(
      enabled: enabled ?? this.enabled,
      selectedDevice: selectedDevice ?? this.selectedDevice,
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
      id: 'iphone_14',
      name: 'iPhone 14',
      platform: TargetPlatform.iOS,
      size: Size(390, 844),
    ),
    DeviceInfo(
      id: 'pixel_7',
      name: 'Pixel 7',
      platform: TargetPlatform.android,
      size: Size(412, 915),
    ),
    DeviceInfo(
      id: 'macbook',
      name: 'MacBook Pro',
      platform: TargetPlatform.macOS,
      size: Size(1440, 900),
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