import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mayandro_resume/database/dao/contact_dao.dart';
import 'package:mayandro_resume/database/dao/education_dao.dart';
import 'package:mayandro_resume/database/dao/experience_dao.dart';
import 'package:mayandro_resume/database/dao/language_dao.dart';
import 'package:mayandro_resume/database/dao/profile_dao.dart';
import 'package:mayandro_resume/database/dao/project_dao.dart';
import 'package:mayandro_resume/model/contact.dart';
import 'package:mayandro_resume/model/education.dart';
import 'package:mayandro_resume/model/experience.dart';
import 'package:mayandro_resume/model/language.dart';
import 'package:mayandro_resume/model/profile.dart';
import 'package:mayandro_resume/model/project.dart';
import 'package:mayandro_resume/network/api_provider.dart';

class Repository {
  final _firestoreProvider = ApiProvider();

  final _contactDao = ContactDao();
  final _educationDao = EducationDao();
  final _experienceDao = ExperienceDao();
  final _languageDao = LanguageDao();
  final _profileDao = ProfileDao();
  final _projectDao = ProjectDao();

  Future<List<ContactItem>> getContactDetails() async {
    var count = await _contactDao.getCount();
    print('Repository.getContactDetails count $count');
    if (count > 0) {
      return _contactDao.getAllContacts();
    }
    var list = await _firestoreProvider.getContactDetails();
    list.forEach((item) {
      _contactDao.insertContact(item);
    });
    return list;
  }

  Future<List<EducationItem>> getEducationDetails() async {
    var count = await _educationDao.getCount();
    print('Repository.getEducationDetails count $count');
    if (count > 0) {
      return _educationDao.getAllEducations();
    }
    var list = await _firestoreProvider.getEducationList();
    list.forEach((item) {
      _educationDao.insertEducation(item);
    });
    return list;
  }

  Future<List<ExperienceItem>> getExperienceDetails() async {
    var count = await _experienceDao.getCount();
    print('Repository.getExperienceDetails count $count');
    if (count > 0) {
      return _experienceDao.getAllExperiences();
    }
    var list = await _firestoreProvider.getExperienceList();
    list.forEach((item) {
      _experienceDao.insertExperience(item);
    });
    return list;
  }

  Future<ProfileItem> getProfileDetails() async {
    var count = await _profileDao.getCount();
    print('Repository.getProfileDetails count $count');
    if (count > 0) return _profileDao.getCurrentProfiles();
    var profileDetail = await _firestoreProvider.getProfileDetails();
    _profileDao.insertProfile(profileDetail);
    return profileDetail;
  }

  Future<List<ProjectItem>> getProjectDetails() async {
    var count = await _projectDao.getCount();
    print('Repository.getProjectDetails count $count');
    if (count > 0) {
      return _projectDao.getAllProjects();
    }
    var list = await _firestoreProvider.getProjectList();
    list.forEach((item) {
      _projectDao.insertProject(item);
    });
    return list;
  }

  Future<List<LanguageItem>> getLanguageDetails() async {
    var count = await _languageDao.getCount();
    print('Repository.getLanguageDetails count $count');
    if (count > 0) {
      return _languageDao.getAllLanguages();
    }
    var list = await _firestoreProvider.getLanguageList();
    list.forEach((item) {
      _languageDao.insertLanguage(item);
    });
    return list;
  }

  Future<bool> checkIfDbNeedsUpdate() async {
    var count = await _profileDao.getCount();
    print('Repository.checkIfDbNeedsUpdate count $count');
    if (count <= 0) return false;
    var apiProfile = await _firestoreProvider.getProfileDetails();
    var dbProfile = await _profileDao.getCurrentProfiles();
    if (apiProfile.lastUpdatedVersion > dbProfile.lastUpdatedVersion) {
	    _contactDao.deleteAllContacts();
	    _experienceDao.deleteAllExperiences();
	    _educationDao.deleteAllEducations();
	    _languageDao.deleteAllLanguages();
	    _projectDao.deleteAllProjects();
	    _profileDao.deleteAllProfiles();
	    _profileDao.insertProfile(apiProfile);
	    return true;
    }
    return false;
  }
}
