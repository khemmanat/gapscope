import 'package:flutter/material.dart';

import '../addons/gapscope_addon.dart';
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
  late GapScopeController _inspectorController;

  @override
  void initState() {
    super.initState();
    _selectedStory = widget.initialStory;
    _inspectorController = GapScopeController();
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

  void _toggleInspector() {
    setState(() {
      if (_inspectorController.mode == GapScopeMode.off) {
        _inspectorController.mode = GapScopeMode.bounds;
      } else {
        _inspectorController.mode = GapScopeMode.off;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  )
                : _buildEmptyState(),
          ),
          if (_addonPanelVisible)
            AddonPanel(
              addons: widget.addons,
              width: 300,
            ),
        ],
      ),
    );
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
        IconButton(
          icon: Icon(
            _inspectorController.mode != GapScopeMode.off
                ? Icons.brightness_5
                : Icons.brightness_5_outlined,
          ),
          onPressed: _toggleInspector,
          tooltip: 'Toggle Inspector',
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
