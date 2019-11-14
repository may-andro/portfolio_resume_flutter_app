import 'package:mayandro_resume/model/experience.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class ExperienceDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Insert Operation: Insert a object to database
  Future<int> insertExperience(ExperienceItem experienceItem) async {
    final db = await dbProvider.database;
    var result = await db.insert(experienceTable, experienceItem.toJson());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateExperience(ExperienceItem experienceItem) async {
    final db = await dbProvider.database;
    var result =
        await db.update(experienceTable, experienceItem.toJson(), where: '$columnExperienceCompany = ?', whereArgs: [experienceItem.company]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteExperience(String company) async {
    final db = await dbProvider.database;
    int result = await db.rawDelete('DELETE FROM $experienceTable WHERE $columnExperienceCompany = $company');
    return result;
  }

  // Get number of objects in database
  Future<int> getCount() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $experienceTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Fetch Operation: Get all objects from database
  Future<List<ExperienceItem>> getAllExperiences() async {
    final db = await dbProvider.database;
    var result = await db.query(experienceTable, orderBy: '$columnId ASC');
    List<ExperienceItem> list = [];
    result.forEach((item) {
	    list.add(ExperienceItem.fromMap(item));
    });
    return list;
  }

  // Delete Operation: Delete all object from database
  Future<int> deleteAllExperiences() async {
    final db = await dbProvider.database;
    int result = await db.delete(experienceTable);
    return result;
  }
}
