import 'package:flutter/foundation.dart' show immutable;

@immutable
class PromptModel {
  final String defaultPrompt;
  final String modelApiKey;
  final String tagsApiKey;
  final String model;

  const PromptModel({
    required this.defaultPrompt,
    required this.modelApiKey,
    required this.tagsApiKey,
    required this.model,
  });

  factory PromptModel.fromJson(Map<String, dynamic> json) {
    return PromptModel(
      defaultPrompt: json['defaultPrompt'],
      modelApiKey: json['modelApiKey'],
      tagsApiKey: json['tagsApiKey'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultPrompt': defaultPrompt,
      'modelApiKey': modelApiKey,
      'tagsApiKey': tagsApiKey,
      'model': model,
    };
  }

  PromptModel copyWith({
    String? defaultPrompt,
    String? modelApiKey,
    String? tagsApiKey,
    String? model,
  }) {
    return PromptModel(
      defaultPrompt: defaultPrompt ?? this.defaultPrompt,
      modelApiKey: modelApiKey ?? this.modelApiKey,
      tagsApiKey: tagsApiKey ?? this.tagsApiKey,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromptModel &&
          runtimeType == other.runtimeType &&
          defaultPrompt == other.defaultPrompt &&
          modelApiKey == other.modelApiKey &&
          tagsApiKey == other.tagsApiKey &&
          model == other.model;

  @override
  int get hashCode =>
      defaultPrompt.hashCode ^
      model.hashCode ^
      modelApiKey.hashCode ^
      tagsApiKey.hashCode;

  @override
  String toString() {
    return 'ModelPrompt{defaultPrompt: $defaultPrompt, model: $model, modelApiKey: $modelApiKey, tagsApiKey: $tagsApiKey}';
  }
}
