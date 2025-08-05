import 'package:flutter/foundation.dart' show immutable;

@immutable
class FeatureSettings {
  final int amount;
  final int time;

  const FeatureSettings({
    required this.time,
    required this.amount,
  });

  factory FeatureSettings.fromJson(Map<String, dynamic> json) {
    return FeatureSettings(
      time: json['time'] as int,
      amount: json['amount'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'amount': amount,
      };

  FeatureSettings copyWith({
    int? time,
    int? amount,
  }) {
    return FeatureSettings(
      time: time ?? this.time,
      amount: amount ?? this.amount,
    );
  }

  @override
  String toString() => 'FeatureSettings(amount: $amount, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FeatureSettings &&
        other.time == time &&
        other.amount == amount;
  }

  @override
  int get hashCode => amount.hashCode ^ time.hashCode;
}

@immutable
class MembershipPricing {
  final double amount;
  final int days;

  const MembershipPricing({
    required this.amount,
    required this.days,
  });
}
