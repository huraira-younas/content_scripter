import 'package:flutter/foundation.dart' show immutable, listEquals;

@immutable
class HelpCenterModel {
  final List<ContactUsModel> contactUs;
  final String termAndServices;
  final String privacyPolicy;
  final List<FaqModel> faq;

  const HelpCenterModel({
    required this.termAndServices,
    required this.privacyPolicy,
    required this.contactUs,
    required this.faq,
  });

  factory HelpCenterModel.fromJson(Map<String, dynamic> json) {
    return HelpCenterModel(
      termAndServices: json['termAndServices'] as String,
      privacyPolicy: json['privacyPolicy'] as String,
      contactUs: (json['contactUs'] as List<dynamic>)
          .map((e) => ContactUsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      faq: (json['faq'] as List<dynamic>)
          .map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactUs': contactUs.map((e) => e.toJson()).toList(),
      'faq': faq.map((e) => e.toJson()).toList(),
      'termsAndServices': termAndServices,
      'privacyPolicy': privacyPolicy,
    };
  }

  HelpCenterModel copyWith({
    List<ContactUsModel>? contactUs,
    String? termAndServices,
    String? privacyPolicy,
    List<FaqModel>? faq,
  }) {
    return HelpCenterModel(
      termAndServices: termAndServices ?? this.termAndServices,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      contactUs: contactUs ?? this.contactUs,
      faq: faq ?? this.faq,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HelpCenterModel &&
        listEquals(other.contactUs, contactUs) &&
        other.termAndServices == termAndServices &&
        other.privacyPolicy == privacyPolicy &&
        listEquals(other.faq, faq);
  }

  @override
  int get hashCode =>
      privacyPolicy.hashCode ^
      termAndServices.hashCode ^
      contactUs.hashCode ^
      faq.hashCode;

  @override
  String toString() =>
      'HelpCenterModel(privacyPolicy: $privacyPolicy, termsAndServices: $termAndServices, contactUs: $contactUs, faqModel: $faq)';
}

class FaqModel {
  final String catName;
  final List<HelperModel> items;

  FaqModel({
    required this.catName,
    required this.items,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      catName: json['catName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => HelperModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'catName': catName,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  FaqModel copyWith({
    String? catName,
    List<HelperModel>? items,
  }) {
    return FaqModel(
      catName: catName ?? this.catName,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FaqModel &&
        other.catName == catName &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode => catName.hashCode ^ items.hashCode;

  @override
  String toString() => 'FaqModel(catName: $catName, items: $items)';
}

@immutable
class HelperModel {
  final String title;
  final String text;

  const HelperModel({
    required this.title,
    required this.text,
  });

  factory HelperModel.fromJson(Map<String, dynamic> json) {
    return HelperModel(
      title: json['title'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
    };
  }

  HelperModel copyWith({
    String? title,
    String? text,
  }) {
    return HelperModel(
      title: title ?? this.title,
      text: text ?? this.text,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HelperModel && other.title == title && other.text == text;
  }

  @override
  int get hashCode => title.hashCode ^ text.hashCode;

  @override
  String toString() => 'HelperModel(title: $title, text: $text)';
}

@immutable
class ContactUsModel extends HelperModel {
  final String icon;

  const ContactUsModel({
    required super.title,
    required super.text,
    required this.icon,
  });

  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(
      title: json['title'] as String,
      text: json['text'] as String,
      icon: json['icon'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['icon'] = icon;
    return data;
  }

  @override
  ContactUsModel copyWith({
    String? title,
    String? text,
    String? icon,
  }) {
    return ContactUsModel(
      title: title ?? super.title,
      text: text ?? super.text,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactUsModel &&
        other.title == title &&
        other.text == text &&
        other.icon == icon;
  }

  @override
  int get hashCode => title.hashCode ^ text.hashCode ^ icon.hashCode;

  @override
  String toString() => 'ContactUs(title: $title, text: $text, icon: $icon)';
}
