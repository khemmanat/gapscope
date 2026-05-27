import 'package:flutter/widgets.dart';

/// Story data model for GapScope component stories
///
/// Defines the metadata and content for a single story in the catalog.
class StoryData {

  const StoryData({
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

  StoryData copyWith({
    String? id,
    String? name,
    String? description,
    Widget Function(BuildContext)? builder,
    String? category,
  }) {
    return StoryData(
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
      other is StoryData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}