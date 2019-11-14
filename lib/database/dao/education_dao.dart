import 'package:mayandro_resume/model/education.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class EducationDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Insert Operation: Insert a object to database
  Future<int> insertEducation(EducationItem educationItem) async {
    final db = await dbProvider.database;
    var result = await db.insert(educationTable, educationItem.toJson());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateEducation(EducationItem educationItem) async {
    final db = await dbProvider.database;
    var result = await db.update(educationTable, educationItem.toJson(),
        where: '$columnEducationDegree = ?', whereArgs: [educationItem.degree]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteEducation(String degree) async {
    final db = await dbProvider.database;
    int result = await db.rawDelete('DELETE FROM $educationTable WHERE $columnEducationDegree = $degree');
    return result;
  }

  // Get number of objects in database
  Future<int> getCount() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $educationTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Fetch Operation: Get all objects from database
  Future<List<EducationItem>> getAllEducations() async {
    final db = await dbProvider.database;
    var result = await db.query(educationTable, orderBy: '$columnId ASC');

    List<EducationItem> list = [];
    result.forEach((item) {
      list.add(EducationItem.fromMap(item));
    });
    return list;
  }

  // Delete Operation: Delete all object from database
  Future<int> deleteAllEducations() async {
    final db = await dbProvider.database;
    int result = await db.delete(educationTable);
    return result;
  }
}
