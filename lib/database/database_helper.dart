import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final contactTable = 'contact_table';
final columnId = '_id';
final columnContactLabel = 'label';
final columnContactAvatar = 'avatar';
final columnContactValue = 'value';

final educationTable = 'education_history_table';
final columnEducationAvatar = 'avatar';
final columnEducationCollege = 'college';
final columnEducationCourse = 'course';
final columnEducationDegree = 'degree';
final columnEducationDuration = 'duration';
final columnEducationLocation = 'location';
final columnEducationLink = 'link';
final columnEducationUniversity = 'university';

final experienceTable = 'expereince_table';
final columnExperienceAvatar = 'avatar';
final columnExperienceCompany = 'company';
final columnExperienceDesignation = 'designation';
final columnExperienceDuration = 'duration';
final columnExperienceSummary = 'summary';
final columnExperienceLink = 'link';
final columnExperienceLocation = 'location';

final languageTable = 'language_table';
final columnLanguageName = 'language';
final columnLanguageLevel = 'level';

final profileTable = 'profile_table';
final columnProfileName = 'name';
final columnProfileAvatar = 'avatar';
final columnProfileDesignation = 'designation';
final columnProfileCurrentCity = 'current_city';
final columnProfileCurrentNationality = 'nationality';
final columnProfileVersion = 'update_version';

final projectTable = 'project_table';
final columnProjectAppStoreLink = 'app_store_link';
final columnProjectAvatar = 'avatar';
final columnProjectCompany = 'company';
final columnProjectDuration = 'duration';
final columnProjectGithubLink = 'github_project_link';
final columnProjectLocation = 'location';
final columnProjectName = 'name';
final columnProjectPlayStoreLink = 'play_store_link';
final columnProjectRole = 'role';
final columnProjectSummary = 'summary';

final _databaseName = "weighter.db";

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  static Database _database;

  static final _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _databaseName;

    // Open/create the database at a given path
    var database = await openDatabase(path, version: _databaseVersion, onCreate: _createDb, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void _createDb(Database database, int version) async {
    await database.execute('CREATE TABLE $contactTable ( '
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnContactLabel TEXT NOT NULL, '
        '$columnContactAvatar TEXT NOT NULL, '
        '$columnContactValue TEXT NOT NULL'
        ')');

    await database.execute('CREATE TABLE $educationTable ( '
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnEducationAvatar TEXT NOT NULL, '
        '$columnEducationCollege TEXT NOT NULL, '
        '$columnEducationCourse TEXT NOT NULL, '
        '$columnEducationDegree TEXT NOT NULL, '
        '$columnEducationDuration TEXT NOT NULL, '
        '$columnEducationLocation TEXT NOT NULL, '
        '$columnEducationLink TEXT NOT NULL, '
        '$columnEducationUniversity TEXT NOT NULL'
        ')');

    await database.execute('CREATE TABLE $experienceTable ( '
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnExperienceAvatar TEXT NOT NULL, '
        '$columnExperienceCompany TEXT NOT NULL, '
        '$columnExperienceDesignation TEXT NOT NULL, '
        '$columnExperienceDuration TEXT NOT NULL, '
        '$columnExperienceSummary TEXT NOT NULL, '
        '$columnExperienceLink TEXT NOT NULL, '
        '$columnExperienceLocation TEXT NOT NULL'
        ')');

    await database.execute('CREATE TABLE $languageTable ( '
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnLanguageName TEXT NOT NULL, '
        '$columnLanguageLevel TEXT NOT NULL'
        ')');

    await database.execute('CREATE TABLE $profileTable ( '
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnProfileName TEXT NOT NULL, '
        '$columnProfileAvatar TEXT NOT NULL, '
        '$columnProfileDesignation TEXT NOT NULL, '
        '$columnProfileCurrentCity TEXT NOT NULL, '
        '$columnProfileVersion INTEGER NOT NULL, '
        '$columnProfileCurrentNationality TEXT NOT NULL'
        ')');

    await database.execute('CREATE TABLE $projectTable ( '
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnProjectAppStoreLink TEXT NOT NULL, '
        '$columnProjectAvatar TEXT NOT NULL, '
        '$columnProjectCompany TEXT NOT NULL, '
        '$columnProjectDuration TEXT NOT NULL, '
        '$columnProjectGithubLink TEXT NOT NULL, '
        '$columnProjectLocation TEXT NOT NULL, '
        '$columnProjectName TEXT NOT NULL, '
        '$columnProjectPlayStoreLink TEXT NOT NULL, '
        '$columnProjectRole TEXT NOT NULL, '
        '$columnProjectSummary TEXT NOT NULL'
        ')');
  }
}
