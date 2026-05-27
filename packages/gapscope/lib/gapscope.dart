/// GapScope Studio - Flutter component workbench and runtime QA inspector
///
/// This library provides the core functionality for GapScope Studio,
/// including the story system, studio UI, and addon framework.
///
/// Current Phase: Phase 5 - Export + Ecosystem
library;

export 'src/addons/device_addon.dart';
// Addon exports
export 'src/addons/gapscope_addon.dart';
export 'src/addons/theme_addon.dart';
// Phase 2 inspection exports
export 'src/capture/geometry_snapshot.dart';
export 'src/capture/render_tree_capture.dart';
export 'src/export/ci_automation.dart';
// Phase 5 export ecosystem exports
export 'src/export/export_config.dart';
export 'src/export/golden_test_integration.dart';
export 'src/export/qa_report_generator.dart';
export 'src/export/screenshot_exporter.dart';
export 'src/inspector/gapscope_controller.dart';
// Inspector exports
export 'src/inspector/gapscope_inspector.dart';
export 'src/measurement/constraint_reader.dart';
// Phase 4 advanced QA exports
export 'src/measurement/flex_gap_detector.dart';
export 'src/measurement/measurement_engine.dart';
export 'src/measurement/tap_target_checker.dart';
export 'src/measurement/whitespace_detector.dart';
export 'src/models/addon_state.dart';
// Models
export 'src/models/story_data.dart';
export 'src/overlay/gapscope_overlay_host.dart';
export 'src/overlay/gapscope_overlay_region.dart';
export 'src/overlay/gapscope_route_observer.dart';
export 'src/overlay/overlay_info.dart';
export 'src/overlay/overlay_registry.dart';
// Phase 3 overlay exports
export 'src/overlay/overlay_type.dart';
export 'src/painting/flex_painter.dart';
export 'src/painting/inspector_painter.dart';
export 'src/studio/gapscope_catalog.dart';
export 'src/studio/gapscope_component.dart';
export 'src/studio/gapscope_story.dart';
// Studio exports
export 'src/studio/gapscope_studio.dart';
export 'src/ui/addon_panel.dart';
export 'src/ui/component_sidebar.dart';
export 'src/ui/story_canvas.dart';
// UI exports
export 'src/ui/studio_shell.dart';