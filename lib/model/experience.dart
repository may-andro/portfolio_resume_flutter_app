import 'package:cloud_firestore/cloud_firestore.dart';

class ExperienceItem {
  String avatar;
  String company;
  String designation;
  String duration;
  String summary;
  String link;
  String location;

  ExperienceItem({
    this.avatar,
    this.company,
    this.designation,
    this.duration,
    this.summary,
    this.link,
    this.location,
  });

  factory ExperienceItem.fromJson(DocumentSnapshot snapShot) {
    return ExperienceItem(
      designation: snapShot['designation'] as String,
      avatar: snapShot['avatar'] as String,
      company: snapShot['company'] as String,
      duration: snapShot['duration'] as String,
      link: snapShot['link'] as String,
      location: snapShot['location'] as String,
      summary: snapShot['summary'] as String,
    );
  }

  factory ExperienceItem.fromMap(Map<String, dynamic> data) {
    return ExperienceItem(
      designation: data['designation'] as String,
      avatar: data['avatar'] as String,
      company: data['company'] as String,
      duration: data['duration'] as String,
      link: data['link'] as String,
      location: data['location'] as String,
      summary: data['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
	  "designation": designation,
	  "avatar": avatar,
	  "company": company,
	  "duration": duration,
	  "link": link,
	  "location": location,
	  "summary": summary,
  };

  @override
  String toString() {
    return 'ExperienceItem{avatar: $avatar, company: $company, designation: $designation, duration: $duration, summary: $summary, link: $link, location: $location}';
  }
}
