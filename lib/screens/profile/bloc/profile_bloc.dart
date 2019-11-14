import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mayandro_resume/model/contact.dart';
import 'package:mayandro_resume/model/education.dart';
import 'package:mayandro_resume/model/experience.dart';
import 'package:mayandro_resume/model/language.dart';
import 'package:mayandro_resume/model/profile.dart';
import 'package:mayandro_resume/model/project.dart';
import 'package:mayandro_resume/repository/repository.dart';
import 'package:open_file/open_file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ProfileBloc {
  final _repository = Repository();

  //String to store navigationId
  int detailPagerCurrentPage = 0;
  int mainPagerCurrentPage = 0;

  final _detailPagerBehaviorSubject = PublishSubject<double>();

  Stream<double> get detailPagerStream => _detailPagerBehaviorSubject.stream;

  Sink<double> get detailPagerSink => _detailPagerBehaviorSubject.sink;

  final _detailPagerSelectedPageBehaviorSubject = PublishSubject<int>();

  Stream<int> get detailPagerSelectedPageStream => _detailPagerSelectedPageBehaviorSubject.stream;

  Sink<int> get detailPagerSelectedPageSink => _detailPagerSelectedPageBehaviorSubject.sink;

  final _mainPagerBehaviorSubject = PublishSubject<double>();

  Stream<double> get mainPagerStream => _mainPagerBehaviorSubject.stream;

  Sink<double> get mainPagerSink => _mainPagerBehaviorSubject.sink;

  final _selectedPageBehaviorSubject = PublishSubject<int>();

  Stream<int> get pageNavigationStream => _selectedPageBehaviorSubject.stream;

  Sink<int> get pageNavigationSink => _selectedPageBehaviorSubject.sink;

  final _downloadCVBehaviorSubject = PublishSubject<double>();

  Stream<double> get downloadCVStream => _downloadCVBehaviorSubject.stream;

  Sink<double> get downloadCVSink => _downloadCVBehaviorSubject.sink;

  final _getContactBehaviorSubject = BehaviorSubject<List<ContactItem>>();

  Stream<List<ContactItem>> get getContactStream => _getContactBehaviorSubject.stream;

  Sink<List<ContactItem>> get getContactSink => _getContactBehaviorSubject.sink;

  final _getProfileBehaviorSubject = BehaviorSubject<ProfileItem>();

  Stream<ProfileItem> get getProfileStream => _getProfileBehaviorSubject.stream;

  Sink<ProfileItem> get getProfileSink => _getProfileBehaviorSubject.sink;

  final _getEducationBehaviorSubject = BehaviorSubject<List<EducationItem>>();

  Stream<List<EducationItem>> get getEducationStream => _getEducationBehaviorSubject.stream;

  Sink<List<EducationItem>> get getEducationSink => _getEducationBehaviorSubject.sink;

  final _getProjectBehaviorSubject = BehaviorSubject<List<ProjectItem>>();

  Stream<List<ProjectItem>> get getProjectStream => _getProjectBehaviorSubject.stream;

  Sink<List<ProjectItem>> get getProjectSink => _getProjectBehaviorSubject.sink;

  final _getLanguageBehaviorSubject = BehaviorSubject<List<LanguageItem>>();

  Stream<List<LanguageItem>> get getLanguageItemStream => _getLanguageBehaviorSubject.stream;

  Sink<List<LanguageItem>> get getLanguageItemSink => _getLanguageBehaviorSubject.sink;

  final _getExperienceBehaviorSubject = BehaviorSubject<List<ExperienceItem>>();

  Stream<List<ExperienceItem>> get getExperienceStream => _getExperienceBehaviorSubject.stream;

  Sink<List<ExperienceItem>> get getExperienceSink => _getExperienceBehaviorSubject.sink;

  ProfileBloc() {
	  _repository.checkIfDbNeedsUpdate().then((value) {
		  getProfileTabData();
	  });
  }

  getProfileTabData() {
    _repository.getProfileDetails().then((item) {
      getProfileSink.add(item);
    }).catchError((error) {
      getProfileSink.add(null);
    });

    _repository.getContactDetails().then((list) {
      getContactSink.add(list);
    }).catchError((error) {
      getContactSink.add(null);
    });

    _repository.getProjectDetails().then((list) {
      getProjectSink.add(list);
    }).catchError((error) {
      getProjectSink.add(null);
    });
  }

  getAboutTabData() {
    _repository.getEducationDetails().then((list) {
      getEducationSink.add(list);
    }).catchError((error) {
      getEducationSink.add(null);
    });
    _repository.getLanguageDetails().then((list) {
      getLanguageItemSink.add(list);
    }).catchError((error) {
      getLanguageItemSink.add(null);
    });
  }

  getExperienceTabData() {
    _repository.getExperienceDetails().then((list) {
      getExperienceSink.add(list);
    }).catchError((error) {
      getExperienceSink.add(null);
    });
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      createEmail();
    }
  }

  void createEmail() async {
    const emailaddress = 'mailto:mayankrai271993@gmail.com?subject=Let\'s get in touch&body=Enter your message!';

    if (await canLaunch(emailaddress)) {
      await launch(emailaddress);
    } else {
      throw 'Could not Email';
    }
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    final StorageReference ref = FirebaseStorage.instance.ref().child('cv.pdf');
    final String url = await ref.getDownloadURL();

    var dir = await getApplicationDocumentsDirectory();
    var file = File("${dir.path}/cv.pdf");

    await dio.download(url, file.path, onReceiveProgress: (rec, total) {
      downloadCVSink.add(((rec / total) * 100));
    });

    downloadCVSink.add(null);

    OpenFile.open(file.path);
  }

  dispose() {
    _detailPagerBehaviorSubject.close();
    _detailPagerSelectedPageBehaviorSubject.close();
    _mainPagerBehaviorSubject.close();
    _selectedPageBehaviorSubject.close();
    _downloadCVBehaviorSubject.close();
    _getContactBehaviorSubject.close();
    _getProfileBehaviorSubject.close();
    _getEducationBehaviorSubject.close();
    _getProjectBehaviorSubject.close();
    _getLanguageBehaviorSubject.close();
    _getExperienceBehaviorSubject.close();
  }
}
