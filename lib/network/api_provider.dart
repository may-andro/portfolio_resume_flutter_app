import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mayandro_resume/model/contact.dart';
import 'package:mayandro_resume/model/education.dart';
import 'package:mayandro_resume/model/experience.dart';
import 'package:mayandro_resume/model/language.dart';
import 'package:mayandro_resume/model/profile.dart';
import 'package:mayandro_resume/model/project.dart';

class ApiProvider {
  Firestore _firestore = Firestore.instance;

  Future<List<ContactItem>> getContactDetails() async {
    List<ContactItem> contactItemList = [];
    await _firestore.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection("contactTable").getDocuments();
      snapshot.documents.forEach((snapshot) {
        ContactItem contactItem = ContactItem.fromJson(snapshot);
        contactItemList.add(contactItem);
      });
    });
    return contactItemList;
  }

  Future<ProfileItem> getProfileDetails() async {
    ProfileItem profileItem;
    await _firestore.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection("profileTable").getDocuments();
      profileItem = ProfileItem.fromJson(snapshot.documents[0]);
    });
    return profileItem;
  }

  Future<List<ProjectItem>> getProjectList() async {
    List<ProjectItem> projectItemList = [];
    await _firestore.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection("projectTable").getDocuments();
      snapshot.documents.forEach((snapshot) {
        ProjectItem projectItem = ProjectItem.fromJson(snapshot);
        projectItemList.add(projectItem);
      });
    });
    return projectItemList;
  }

  Future<List<ExperienceItem>> getExperienceList() async {
    List<ExperienceItem> experienceItemList = [];
    await _firestore.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection("experienceTable").getDocuments();
      snapshot.documents.forEach((snapshot) {
        ExperienceItem experienceItem = ExperienceItem.fromJson(snapshot);
        experienceItemList.add(experienceItem);
      });
    });
    return experienceItemList;
  }

  Future<List<EducationItem>> getEducationList() async {
    List<EducationItem> educationItemList = [];
    await _firestore.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection("educationTable").getDocuments();
      snapshot.documents.forEach((snapshot) {
        EducationItem educationItem = EducationItem.fromJson(snapshot);
        educationItemList.add(educationItem);
      });
    });
    return educationItemList;
  }

  Future<List<LanguageItem>> getLanguageList() async {
    List<LanguageItem> languageItemList = [];
    await _firestore.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection("languageTable").getDocuments();
      snapshot.documents.forEach((snapshot) {
        LanguageItem languageItem = LanguageItem.fromJson(snapshot);
        languageItemList.add(languageItem);
      });
    });
    return languageItemList;
  }
}
