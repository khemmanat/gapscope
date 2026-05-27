import 'package:flutter/widgets.dart';
import '../models/story_data.dart';

/// Definition of a single story in GapScope Studio
///
/// Stories are individual previews of components with specific configurations.
class GapScopeStory {

  const GapScopeStory({
    required this.id,
    required this.name,
    this.description,
    required this.builder,
    this.category,
  });
  /// Unique identifier for this story
  final String id;

  /// Display name for the story
  final String name;

  /// Optional description
  final String? description;

  /// Builder function that creates the story widget
  final Widget Function(BuildContext) builder;

  /// Optional category for grouping
  final String? category;

  /// Convert to StoryData model
  StoryData toStoryData() {
    return StoryData(
      id: id,
      name: name,
      description: description,
      builder: builder,
      category: category,
    );
  }

  GapScopeStory copyWith({
    String? id,
    String? name,
    String? description,
    Widget Function(BuildContext)? builder,
    String? category,
  }) {
    return GapScopeStory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      builder: builder ?? this.builder,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GapScopeStory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}