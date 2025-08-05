import 'package:flutter/foundation.dart' show immutable;

@immutable
class MembershipModel {
  final List<String> features;
  final String title;
  final bool hideAds;
  final double price;
  final String id;

  const MembershipModel({
    required this.id,
    required this.title,
    required this.price,
    required this.hideAds,
    required this.features,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      hideAds: json['isAdsOn'] as bool,
      price: (json['price'] as num).toDouble(),
      features: List<String>.from(json['features'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'price': price,
        'title': title,
        'hideAds': hideAds,
        'features': features,
      };

  MembershipModel copyWith({
    String? id,
    String? title,
    double? price,
    bool? hideAds,
    List<String>? features,
  }) {
    return MembershipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      hideAds: hideAds ?? this.hideAds,
      features: features ?? this.features,
    );
  }

  @override
  String toString() {
    return 'Membership(id: $id, title: $title, price: $price, features: $features, hideAds: $hideAds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MembershipModel &&
        other.id == id &&
        other.title == title &&
        other.price == price &&
        other.hideAds == hideAds &&
        other.features == features;
  }

  @override
  int get hashCode {
    return price.hashCode ^
        hideAds.hashCode ^
        id.hashCode ^
        title.hashCode ^
        features.hashCode;
  }
}
