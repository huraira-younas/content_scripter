import 'package:flutter/foundation.dart' show immutable;

@immutable
class PhoneModel {
  final String phoneCode;
  final String country;
  final String number;
  final String code;

  const PhoneModel({
    this.phoneCode = "",
    this.country = "",
    this.number = "",
    this.code = "",
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      phoneCode: json['phoneCode'] as String? ?? "",
      country: json['country'] as String? ?? "",
      number: json['number'] as String? ?? "",
      code: json['code'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneCode': phoneCode,
      'country': country,
      'number': number,
      'code': code,
    };
  }

  PhoneModel copyWith({
    String? phoneCode,
    String? country,
    String? number,
    String? code,
  }) {
    return PhoneModel(
      phoneCode: phoneCode ?? this.phoneCode,
      country: country ?? this.country,
      number: number ?? this.number,
      code: code ?? this.code,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneModel &&
          runtimeType == other.runtimeType &&
          phoneCode == other.phoneCode &&
          country == other.country &&
          number == other.number &&
          code == other.code;

  @override
  int get hashCode =>
      code.hashCode ^ phoneCode.hashCode ^ country.hashCode ^ number.hashCode;

  @override
  String toString() {
    return 'PhoneModel(code: $code, phoneCode: $phoneCode, country: $country, number: $number)';
  }
}
