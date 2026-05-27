import '../models/story_data.dart';

/// A GapScope component containing multiple stories
///
/// Components group related stories together in the catalog.
class GapScopeComponent {

  const GapScopeComponent({
    required this.id,
    required this.name,
    this.description,
    this.stories = const [],
  });
  /// Unique identifier for this component
  final String id;

  /// Display name for the component
  final String name;

  /// Optional description
  final String? description;

  /// Stories belonging to this component
  final List<StoryData> stories;

  GapScopeComponent copyWith({
    String? id,
    String? name,
    String? description,
    List<StoryData>? stories,
  }) {
    return GapScopeComponent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      stories: stories ?? this.stories,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GapScopeComponent &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}