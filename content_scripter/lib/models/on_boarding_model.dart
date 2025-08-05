import 'package:content_scripter/constants/app_assets.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class OnBoardingModel {
  final int index;
  final String title;
  final String imageUrl;
  final String description;

  const OnBoardingModel({
    required this.description,
    required this.imageUrl,
    required this.index,
    required this.title,
  });

  OnBoardingModel copyWith({
    int? index,
    String? title,
    String? imageUrl,
    String? description,
  }) {
    return OnBoardingModel(
      title: title ?? this.title,
      index: index ?? this.index,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  static OnBoardingModel dummyData = OnBoardingModel(
    description: "This is a description" * 16,
    imageUrl: AppAssets.appLogoPng,
    title: "Ai Content Scripter",
    index: 0,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnBoardingModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          index == other.index &&
          imageUrl == other.imageUrl &&
          description == other.description;

  @override
  int get hashCode =>
      title.hashCode ^
      index.hashCode ^
      imageUrl.hashCode ^
      description.hashCode;

  @override
  String toString() {
    return 'OnBoardingModel{text: $title, index: $index, description: $description, imageUrl: $imageUrl}';
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'imageUrl': imageUrl,
      'index': index,
      'title': title,
    };
  }

  factory OnBoardingModel.fromJson(Map<String, dynamic> json) {
    return OnBoardingModel(
      imageUrl: json['imageUrl'] as String? ?? AppAssets.appLogoPng,
      description: json['description'] as String,
      title: json['title'] as String,
      index: json['index'] as int,
    );
  }
}
