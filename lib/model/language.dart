import 'package:cloud_firestore/cloud_firestore.dart';

class LanguageItem {
  String language;
  String level;

  LanguageItem({this.language, this.level});

  factory LanguageItem.fromJson(DocumentSnapshot snapShot) {
    return LanguageItem(
      language: snapShot['language'] as String,
      level: snapShot['level'] as String,
    );
  }

  factory LanguageItem.fromMap(Map<String, dynamic> data) {
    return LanguageItem(
      language: data['language'] as String,
      level: data['level'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "language": language,
        "level": level,
      };
}
