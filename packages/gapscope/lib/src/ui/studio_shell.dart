import 'package:flutter/material.dart';

import '../addons/device_addon.dart';
import '../addons/gapscope_addon.dart';
import '../addons/theme_addon.dart';
import '../inspector/gapscope_controller.dart';
import '../models/story_data.dart';
import '../studio/gapscope_catalog.dart';
import 'addon_panel.dart';
import 'component_sidebar.dart';
import 'story_canvas.dart';

/// Main studio shell for GapScope Studio
///
/// Provides the responsive layout with sidebar, canvas, and addon panel.
class StudioShell extends StatefulWidget {
  const StudioShell({
    super.key,
    required this.title,
    required this.catalog,
    this.addons = const [],
    this.initialStory,
  });
  final String title;
  final GapScopeCatalog catalog;
  final List<GapScopeAddon> addons;
  final StoryData? initialStory;

  @override
  State<StudioShell> createState() => _StudioShellState();
}

class _StudioShellState extends State<StudioShell> {
  StoryData? _selectedStory;
  bool _sidebarVisible = true;
  bool _addonPanelVisible = true;
  late List<GapScopeAddon> _addons;
  late GapScopeController _inspectorController;

  @override
  void initState() {
    super.initState();
    _selectedStory = widget.initialStory;
    _addons = widget.addons;
    _inspectorController = GapScopeController();
  }

  @override
  void didUpdateWidget(StudioShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.addons != oldWidget.addons) {
      _addons = widget.addons;
    }
  }

  void _selectStory(StoryData story) {
    setState(() {
      _selectedStory = story;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _sidebarVisible = !_sidebarVisible;
    });
  }

  void _toggleAddonPanel() {
    setState(() {
      _addonPanelVisible = !_addonPanelVisible;
    });
  }

  void _setInspectorMode(GapScopeMode mode) {
    setState(() {
      _inspectorController.mode = mode;
    });
  }

  void _updateAddon(GapScopeAddon addon) {
    setState(() {
      _addons = [
        for (final current in _addons)
          if (current.id == addon.id) addon else current,
      ];
    });
  }

  T? _findAddon<T extends GapScopeAddon>() {
    for (final addon in _addons) {
      if (addon is T) return addon;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeState = _findAddon<ThemeAddon>()?.state;
    final deviceState = _findAddon<DeviceAddon>()?.state;

    return Theme(
      data: _themeDataForState(context, themeState),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: _buildAppBar(context),
          body: Row(
            children: [
              if (_sidebarVisible)
                ComponentSidebar(
                  catalog: widget.catalog,
                  selectedStory: _selectedStory,
                  onStorySelected: _selectStory,
                  width: 300,
                ),
              Expanded(
                child: _selectedStory != null
                    ? StoryCanvas(
                        story: _selectedStory!,
                        key: ValueKey(_selectedStory!.id),
                        inspectorEnabled:
                            _inspectorController.mode != GapScopeMode.off,
                        inspectorController: _inspectorController,
                        themeState: themeState,
                        deviceState: deviceState,
                      )
                    : _buildEmptyState(),
              ),
              if (_addonPanelVisible)
                AddonPanel(
                  addons: _addons,
                  width: 300,
                  onAddonChanged: _updateAddon,
                ),
            ],
          ),
        ),
      ),
    );
  }

  ThemeData _themeDataForState(
    BuildContext context,
    ThemeAddonState? themeState,
  ) {
    if (themeState == null || !themeState.enabled) {
      return Theme.of(context);
    }

    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final useDarkTheme = switch (themeState.themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };

    if (useDarkTheme) {
      return themeState.darkTheme ?? ThemeAddon.defaultDarkTheme;
    }

    return themeState.lightTheme ?? ThemeAddon.defaultLightTheme;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        IconButton(
          icon: Icon(_sidebarVisible ? Icons.menu_open : Icons.menu),
          onPressed: _toggleSidebar,
          tooltip: 'Toggle Sidebar',
        ),
        PopupMenuButton<GapScopeMode>(
          icon: Icon(
            _inspectorController.mode == GapScopeMode.off
                ? Icons.brightness_5_outlined
                : Icons.brightness_5,
          ),
          tooltip: 'Inspector Mode',
          initialValue: _inspectorController.mode,
          onSelected: _setInspectorMode,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: GapScopeMode.off,
              child: Text('Off'),
            ),
            PopupMenuItem(
              value: GapScopeMode.bounds,
              child: Text('Bounds'),
            ),
            PopupMenuItem(
              value: GapScopeMode.spacing,
              child: Text('Spacing'),
            ),
            PopupMenuItem(
              value: GapScopeMode.overlay,
              child: Text('Overlays'),
            ),
          ],
        ),
        IconButton(
          icon: Icon(_addonPanelVisible ? Icons.apps : Icons.apps_outlined),
          onPressed: _toggleAddonPanel,
          tooltip: 'Toggle Addon Panel',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.layers_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Select a Story',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          const Text('Choose a component story from the sidebar to preview'),
        ],
      ),
    );
  }
}
