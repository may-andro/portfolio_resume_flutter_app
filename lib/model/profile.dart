import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileItem {
  final String name;
  final String avatar;
  final String designation;
  final String currentCity;
  final String nationality;
  final int lastUpdatedVersion;

  const ProfileItem({
    this.name,
    this.avatar,
    this.designation,
    this.currentCity,
    this.nationality,
    this.lastUpdatedVersion,
  });

  factory ProfileItem.fromJson(DocumentSnapshot snapShot) {
    return ProfileItem(
        name: snapShot['name'] as String,
        avatar: snapShot['avatar'] as String,
        designation: snapShot['designation'] as String,
        currentCity: snapShot['current_city'] as String,
        lastUpdatedVersion: snapShot['update_version'] as int,
        nationality: snapShot['nationality'] as String);
  }

  ProfileItem.fromMap(Map<String, dynamic> data)
      : this(
          name: data['name'],
          avatar: data['avatar'],
          designation: data['designation'],
          currentCity: data['current_city'],
          lastUpdatedVersion: data['update_version'],
          nationality: data['nationality'],
        );

  Map<String, dynamic> toJson() => {
        "name": name,
        "avatar": avatar,
        "designation": designation,
        "current_city": currentCity,
        "update_version": lastUpdatedVersion,
        "nationality": nationality,
      };
}
