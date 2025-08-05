import 'package:content_scripter/models/user_model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class HistoryModel {
  final List<UserModel> shared;
  final String sessionId;
  final DateTime created;
  final String category;
  final String iconUrl;
  final String userId;
  final String text;
  final bool pinned;
  final String id;

  const HistoryModel({
    this.id = "",
    required this.text,
    this.pinned = false,
    required this.userId,
    required this.created,
    required this.iconUrl,
    required this.category,
    this.shared = const [],
    required this.sessionId,
  });

  static final dummyHistory = List.generate(
    10,
    (idx) => HistoryModel(
      text: "This is a test history $idx",
      sessionId: idx.toString(),
      created: DateTime.now(),
      category: "custom",
      userId: "senpai",
      iconUrl: "",
    ),
  );

  Map<String, dynamic> toJson() {
    return {
      'shared': shared.map((e) => e.uid).toList(),
      'created': created.toIso8601String(),
      'sessionId': sessionId,
      'category': category,
      'iconUrl': iconUrl,
      'pinned': pinned,
      'userId': userId,
      'text': text,
      '_id': id,
    };
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? sharedJson = json['shared'];
    List<UserModel> sharedUsers = [];
    if (sharedJson != null) {
      sharedUsers = sharedJson.map((e) => UserModel.fromJson(e)).toList();
    }

    return HistoryModel(
      created: DateTime.parse(json['created'] as String),
      pinned: json['pinned'] as bool? ?? false,
      sessionId: json['sessionId'] as String,
      category: json['category'] as String,
      iconUrl: json['iconUrl'] as String,
      userId: json['userId'] as String,
      text: json['text'] as String,
      id: json['_id'] as String,
      shared: sharedUsers,
    );
  }

  HistoryModel copyWith({
    List<UserModel>? shared,
    DateTime? created,
    String? sessionId,
    String? category,
    String? iconUrl,
    String? userId,
    String? text,
    bool? pinned,
    String? id,
  }) {
    return HistoryModel(
      sessionId: sessionId ?? this.sessionId,
      category: category ?? this.category,
      created: created ?? this.created,
      iconUrl: iconUrl ?? this.iconUrl,
      userId: userId ?? this.userId,
      pinned: pinned ?? this.pinned,
      shared: shared ?? this.shared,
      text: text ?? this.text,
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryModel &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId &&
          category == other.category &&
          iconUrl == other.iconUrl &&
          userId == other.userId &&
          pinned == other.pinned &&
          text == other.text &&
          id == other.id &&
          created == other.created;

  @override
  int get hashCode =>
      sessionId.hashCode ^
      category.hashCode ^
      text.hashCode ^
      created.hashCode ^
      iconUrl.hashCode ^
      pinned.hashCode ^
      id.hashCode ^
      userId.hashCode;

  @override
  String toString() {
    return 'HistoryModel{id: $id, pinned: $pinned, iconUrl: $iconUrl, sessionId: $sessionId, userId:$userId category: $category, text: $text, created: $created, shared: $shared}';
  }
}
