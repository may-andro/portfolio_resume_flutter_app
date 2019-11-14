import 'package:cloud_firestore/cloud_firestore.dart';

class EducationItem {
  String avatar;
  String college;
  String course;
  String degree;
  String duration;
  String location;
  String link;
  String university;

  EducationItem({
    this.avatar,
    this.college,
    this.course,
    this.degree,
    this.duration,
    this.location,
    this.link,
    this.university,
  });

  factory EducationItem.fromJson(DocumentSnapshot snapShot) {
    return EducationItem(
      college: snapShot['college'] as String,
      avatar: snapShot['avatar'] as String,
      course: snapShot['course'] as String,
      duration: snapShot['duration'] as String,
      degree: snapShot['degree'] as String,
      link: snapShot['link'] as String,
      location: snapShot['location'] as String,
      university: snapShot['university'] as String,
    );
  }

  EducationItem.fromMap(Map<String, dynamic> data)
		  : this(
	  college: data['college'],
	  avatar: data['avatar'],
	  course: data['course'] as String,
	  duration: data['duration'] as String,
	  degree: data['degree'] as String,
	  link: data['link'] as String,
	  location: data['location'] as String,
	  university: data['university'] as String,
  );

  Map<String, dynamic> toJson() => {
        "college": college,
        "avatar": avatar,
        "course": course,
        "duration": duration,
        "degree": degree,
        "link": link,
        "location": location,
        "university": university,
      };
}
