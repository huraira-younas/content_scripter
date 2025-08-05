import 'package:flutter/foundation.dart' show immutable;

@immutable
class AssistantModel {
  final String id;
  final String topic;
  final String prompt;
  final String iconUrl;
  final String category;
  final String description;

  const AssistantModel({
    required this.id,
    required this.topic,
    required this.prompt,
    required this.iconUrl,
    required this.category,
    required this.description,
  });

  AssistantModel copyWith({
    String? id,
    String? topic,
    String? prompt,
    String? iconUrl,
    String? category,
    String? description,
  }) {
    return AssistantModel(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      prompt: prompt ?? this.prompt,
      iconUrl: iconUrl ?? this.iconUrl,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  factory AssistantModel.fromJson(Map<String, dynamic> json) {
    return AssistantModel(
      id: json['_id'] as String,
      topic: json['topic'] as String,
      iconUrl: json['icon'] as String,
      prompt: json['prompt'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'icon': iconUrl,
      'prompt': prompt,
      'category': category,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssistantModel &&
        other.id == id &&
        other.topic == topic &&
        other.prompt == prompt &&
        other.iconUrl == iconUrl &&
        other.category == category &&
        other.description == description;
  }

  @override
  int get hashCode {
    return topic.hashCode ^
        id.hashCode ^
        prompt.hashCode ^
        iconUrl.hashCode ^
        category.hashCode ^
        description.hashCode;
  }

  @override
  String toString() {
    return 'AssistantModel(topic: $topic, id: $id, prompt: $prompt, iconUrl: $iconUrl, category: $category, description: $description)';
  }
}
