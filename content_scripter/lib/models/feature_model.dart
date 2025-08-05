import 'package:flutter/foundation.dart' show immutable;

@immutable
class FeatureModel {
  final ResetDuration resetDuration;
  final FileInput fileInput;
  final Count promptsLimit;
  final int remPromptTime;
  final int remFileTime;
  final String userId;

  const FeatureModel({
    required this.resetDuration,
    required this.remPromptTime,
    required this.promptsLimit,
    required this.remFileTime,
    required this.fileInput,
    required this.userId,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      resetDuration: ResetDuration.fromJson(json['resetDuration']),
      remPromptTime: (json['remPromptTime'] as num? ?? 0).toInt(),
      remFileTime: (json['remFileTime'] as num? ?? 0).toInt(),
      promptsLimit: Count.fromJson(json['promptsLimit']),
      fileInput: FileInput.fromJson(json['fileInput']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resetDuration': resetDuration.toJson(),
      'promptsLimit': promptsLimit.toJson(),
      'fileInput': fileInput.toJson(),
      'userId': userId,
    };
  }

  FeatureModel copyWith({
    ResetDuration? resetDuration,
    FileInput? fileInput,
    Count? promptsLimit,
    int? remPromptTime,
    int? remFileTime,
    String? userId,
  }) {
    return FeatureModel(
      resetDuration: resetDuration ?? this.resetDuration,
      remPromptTime: remPromptTime ?? this.remPromptTime,
      promptsLimit: promptsLimit ?? this.promptsLimit,
      remFileTime: remFileTime ?? this.remFileTime,
      fileInput: fileInput ?? this.fileInput,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          fileInput == other.fileInput &&
          remFileTime == other.remFileTime &&
          remPromptTime == other.remPromptTime &&
          promptsLimit == other.promptsLimit &&
          resetDuration == other.resetDuration;

  @override
  int get hashCode =>
      userId.hashCode ^
      fileInput.hashCode ^
      remFileTime.hashCode ^
      remPromptTime.hashCode ^
      promptsLimit.hashCode ^
      resetDuration.hashCode;

  @override
  String toString() {
    return 'Feature{userId: $userId, remFileTime: $remFileTime, remPromptTime: $remPromptTime, fileInput: $fileInput, promptsLimit: $promptsLimit, resetDuration: $resetDuration}';
  }
}

class FileInput {
  final Count image;

  FileInput({required this.image});

  factory FileInput.fromJson(Map<String, dynamic> json) {
    return FileInput(
      image: Count.fromJson(json['image']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image.toJson(),
    };
  }

  FileInput copyWith({Count? image}) {
    return FileInput(image: image ?? this.image);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileInput &&
          runtimeType == other.runtimeType &&
          image == other.image;

  @override
  int get hashCode => image.hashCode;

  @override
  String toString() {
    return 'FileInput{image: $image}';
  }
}

class Count {
  final int max;
  final int current;

  Count({this.max = 5, this.current = 0});
  double get progress => (current / max) * 100;

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(
      max: json['max'],
      current: json['current'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max': max,
      'current': current,
    };
  }

  Count copyWith({int? max, int? current}) {
    return Count(
      max: max ?? this.max,
      current: current ?? this.current,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Count &&
          runtimeType == other.runtimeType &&
          max == other.max &&
          current == other.current;

  @override
  int get hashCode => max.hashCode ^ current.hashCode;

  @override
  String toString() {
    return 'Count{max: $max, current: $current}';
  }
}

class ResetDuration {
  final int fileInput;
  final int prompts;

  ResetDuration({this.fileInput = 10800, this.prompts = 18000});

  factory ResetDuration.fromJson(Map<String, dynamic> json) {
    return ResetDuration(
      fileInput: json['fileInput'],
      prompts: json['prompts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileInput': fileInput,
      'prompts': prompts,
    };
  }

  ResetDuration copyWith({int? fileInput, int? prompts}) {
    return ResetDuration(
      fileInput: fileInput ?? this.fileInput,
      prompts: prompts ?? this.prompts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResetDuration &&
          runtimeType == other.runtimeType &&
          fileInput == other.fileInput &&
          prompts == other.prompts;

  @override
  int get hashCode => fileInput.hashCode ^ prompts.hashCode;

  @override
  String toString() {
    return 'ResetDuration{fileInput: $fileInput, prompts: $prompts}';
  }
}
