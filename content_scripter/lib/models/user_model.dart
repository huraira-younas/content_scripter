import 'package:content_scripter/models/phone_model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String username;
  final PhoneModel phone;
  final String profileUrl;
  final String membershipId;

  const UserModel({
    required this.uid,
    required this.name,
    required this.username,
    this.profileUrl = "",
    required this.email,
    required this.phone,
    required this.membershipId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: PhoneModel.fromJson(json['phone'] ?? {}),
      membershipId: json['membershipId'] as String,
      profileUrl: json['profileUrl'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      uid: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': uid,
      'name': name,
      'email': email,
      'username': username,
      'phone': phone.toJson(),
      'profileUrl': profileUrl,
      'membershipId': membershipId,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? country,
    String? username,
    PhoneModel? phone,
    String? profileUrl,
    String? membershipId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      profileUrl: profileUrl ?? this.profileUrl,
      membershipId: membershipId ?? this.membershipId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          membershipId == other.membershipId &&
          profileUrl == other.profileUrl &&
          username == other.username &&
          email == other.email &&
          phone == other.phone;

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      uid.hashCode ^
      phone.hashCode ^
      username.hashCode ^
      membershipId.hashCode ^
      profileUrl.hashCode;

  @override
  String toString() {
    return 'UserModel{uid: $uid, name: $name, membershipId: $membershipId, username: $username, email: $email, number: $phone, profileUrl: $profileUrl}';
  }
}
