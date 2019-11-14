import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectItem {
  final String appStoreLink;
  final String avatar;
  final String company;
  final String duration;
  final String githubLink;
  final String location;
  final String name;
  final String playStoreLink;
  final String role;
  final String summary;

  ProjectItem({
    this.appStoreLink,
    this.avatar,
    this.company,
    this.duration,
    this.githubLink,
    this.location,
    this.name,
    this.playStoreLink,
    this.role,
    this.summary,
  });

  factory ProjectItem.fromJson(DocumentSnapshot snapShot) {
    return ProjectItem(
      appStoreLink: snapShot['app_store_link'] as String,
      avatar: snapShot['avatar'] as String,
      company: snapShot['company'] as String,
      duration: snapShot['duration'] as String,
      githubLink: snapShot['github_project_link'] as String,
      location: snapShot['location'] as String,
      name: snapShot['name'] as String,
      playStoreLink: snapShot['play_store_link'] as String,
      role: snapShot['role'] as String,
      summary: snapShot['summary'] as String,
    );
  }

  factory ProjectItem.fromMap(Map<String, dynamic> data) {
    return ProjectItem(
      appStoreLink: data['app_store_link'] as String,
      avatar: data['avatar'] as String,
      company: data['company'] as String,
      duration: data['duration'] as String,
      githubLink: data['github_project_link'] as String,
      location: data['location'] as String,
      name: data['name'] as String,
      playStoreLink: data['play_store_link'] as String,
      role: data['role'] as String,
      summary: data['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "app_store_link": appStoreLink,
        "avatar": avatar,
        "company": company,
        "duration": duration,
        "github_project_link": githubLink,
        "location": location,
        "name": name,
        "play_store_link": playStoreLink,
        "role": role,
        "summary": summary,
      };
}
