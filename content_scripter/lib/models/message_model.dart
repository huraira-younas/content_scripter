import 'package:flutter/foundation.dart' show immutable;

@immutable
class MessageModel {
  final String? imageUrl;
  final String message;
  final String userId;
  final DateTime time;
  final String role;

  const MessageModel({
    required this.message,
    required this.userId,
    required this.role,
    required this.time,
    this.imageUrl,
  });

  static final messages = List.generate(
    4,
    (idx) => MessageModel(
      message: "This is a test message $idx" * (idx.isEven ? 4 : idx * 10),
      userId: idx.isEven ? "user" : "model",
      role: idx.isEven ? "user" : "model",
      time: DateTime.now().add(Duration(minutes: idx)),
    ),
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      time: DateTime.parse(json['time']),
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      message: json['message'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'imageUrl': imageUrl,
      'message': message,
      'userId': userId,
      'role': role,
    };
  }

  MessageModel copyWith({
    String? imageUrl,
    String? message,
    String? userId,
    DateTime? time,
    String? role,
  }) {
    return MessageModel(
      imageUrl: imageUrl ?? this.imageUrl,
      message: message ?? this.message,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return "MessageModel(role: $role, senderId: $userId, imageUrl: $imageUrl, message: $message, time: $time)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    return other is MessageModel &&
        other.imageUrl == imageUrl &&
        other.userId == userId &&
        other.message == message &&
        other.role == role &&
        other.time == time;
  }

  @override
  int get hashCode =>
      role.hashCode ^
      imageUrl.hashCode ^
      userId.hashCode ^
      message.hashCode ^
      time.hashCode;
}
