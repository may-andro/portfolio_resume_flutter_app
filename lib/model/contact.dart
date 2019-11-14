import 'package:cloud_firestore/cloud_firestore.dart';

class ContactItem {
  final String label;
  final String avatar;
  final String value;

  const ContactItem({
    this.label,
    this.avatar,
    this.value,
  });

  factory ContactItem.fromJson(DocumentSnapshot snapShot) {
    return ContactItem(
      label: snapShot['label'] as String,
      avatar: snapShot['avatar'] as String,
      value: snapShot['value'] as String,
    );
  }

  ContactItem.fromMap(Map<String, dynamic> data)
      : this(
          label: data['label'],
          avatar: data['avatar'],
          value: data['value'],
        );

  Map<String, dynamic> toJson() => {
        "label": label,
        "avatar": avatar,
        "value": value,
      };
}
