import 'package:flutter/foundation.dart' show immutable;

@immutable
class MembershipTimePeriod {
  final double discount;
  final int days;

  const MembershipTimePeriod({
    required this.discount,
    required this.days,
  });

  MembershipTimePeriod copyWith({
    double? discount,
    int? days,
  }) {
    return MembershipTimePeriod(
      discount: discount ?? this.discount,
      days: days ?? this.days,
    );
  }

  @override
  String toString() => 'MembershipTimePeriod(discount: $discount, days: $days)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MembershipTimePeriod &&
        other.discount == discount &&
        other.days == days;
  }

  @override
  int get hashCode => discount.hashCode ^ days.hashCode;

  Map<String, dynamic> toJson() => {
        'discount': discount,
        'time': days,
      };

  factory MembershipTimePeriod.fromJson(Map<String, dynamic> json) {
    return MembershipTimePeriod(
      discount: (json['discount'] as num).toDouble(),
      days: json['time'] as int,
    );
  }
}
