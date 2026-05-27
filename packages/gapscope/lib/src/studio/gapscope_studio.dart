import 'package:flutter/widgets.dart';
import '../models/story_data.dart';
import '../addons/gapscope_addon.dart';
import '../ui/studio_shell.dart';
import 'gapscope_catalog.dart';
import 'gapscope_component.dart';

/// Main GapScope Studio widget
///
/// The root widget for GapScope Studio that provides the foundation
/// for component preview and addon management.
class GapScopeStudio extends StatefulWidget {
  final String title;
  final List<GapScopeComponent> components;
  final List<GapScopeAddon> addons;
  final StoryData? initialStory;

  const GapScopeStudio({
    super.key,
    required this.title,
    this.components = const [],
    this.addons = const [],
    this.initialStory,
  });

  @override
  State<GapScopeStudio> createState() => _GapScopeStudioState();
}

class _GapScopeStudioState extends State<GapScopeStudio> {
  late GapScopeCatalog _catalog;

  @override
  void initState() {
    super.initState();
    _catalog = GapScopeCatalog(components: widget.components);
  }

  @override
  void didUpdateWidget(GapScopeStudio oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.components != oldWidget.components) {
      _catalog = GapScopeCatalog(components: widget.components);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StudioShell(
      title: widget.title,
      catalog: _catalog,
      addons: widget.addons,
      initialStory: widget.initialStory,
    );
  }
}