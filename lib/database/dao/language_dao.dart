import 'package:mayandro_resume/model/language.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class LanguageDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Insert Operation: Insert a object to database
  Future<int> insertLanguage(LanguageItem languageItem) async {
    final db = await dbProvider.database;
    var result = await db.insert(languageTable, languageItem.toJson());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateLanguage(LanguageItem languageItem) async {
    final db = await dbProvider.database;
    var result =
        await db.update(languageTable, languageItem.toJson(), where: '$columnLanguageName = ?', whereArgs: [languageItem.language]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteLanguage(String language) async {
    final db = await dbProvider.database;
    int result = await db.rawDelete('DELETE FROM $languageTable WHERE $columnLanguageName = $language');
    return result;
  }

  // Get number of objects in database
  Future<int> getCount() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $languageTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Fetch Operation: Get all objects from database
  Future<List<LanguageItem>> getAllLanguages() async {
    final db = await dbProvider.database;
    var result = await db.query(languageTable, orderBy: '$columnId ASC');
    List<LanguageItem> list = [];
    result.forEach((item) {
	    list.add(LanguageItem.fromMap(item));
    });
    return list;
  }

  // Delete Operation: Delete all object from database
  Future<int> deleteAllLanguages() async {
    final db = await dbProvider.database;
    int result = await db.delete(languageTable);
    return result;
  }
}
