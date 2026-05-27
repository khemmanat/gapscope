import '../models/story_data.dart';
import 'gapscope_component.dart';

/// Catalog for organizing and accessing components and stories
class GapScopeCatalog {
  /// All registered components
  final List<GapScopeComponent> components;

  /// All stories across all components
  List<StoryData> get allStories {
    return components
        .expand((component) => component.stories)
        .toList();
  }

  const GapScopeCatalog({this.components = const []});

  /// Find component by ID
  GapScopeComponent? findComponent(String id) {
    for (final component in components) {
      if (component.id == id) return component;
    }
    return null;
  }

  /// Find story by ID
  StoryData? findStory(String storyId) {
    for (final component in components) {
      for (final story in component.stories) {
        if (story.id == storyId) return story;
      }
    }
    return null;
  }

  GapScopeCatalog copyWith({
    List<GapScopeComponent>? components,
  }) {
    return GapScopeCatalog(
      components: components ?? this.components,
    );
  }
}