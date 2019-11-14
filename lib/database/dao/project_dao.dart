import 'package:mayandro_resume/model/project.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class ProjectDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Insert Operation: Insert a object to database
  Future<int> insertProject(ProjectItem projectItem) async {
    final db = await dbProvider.database;
    var result = await db.insert(projectTable, projectItem.toJson());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateProject(ProjectItem projectItem) async {
    final db = await dbProvider.database;
    var result =
        await db.update(projectTable, projectItem.toJson(), where: '$columnProjectName = ?', whereArgs: [projectItem.name]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteProject(String name) async {
    final db = await dbProvider.database;
    int result = await db.rawDelete('DELETE FROM $projectTable WHERE $columnProjectName = $name');
    return result;
  }

  // Get number of objects in database
  Future<int> getCount() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $projectTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Fetch Operation: Get all objects from database
  Future<List<ProjectItem>> getAllProjects() async {
    final db = await dbProvider.database;
    var result = await db.query(projectTable, orderBy: '$columnId ASC');
    List<ProjectItem> list = [];
    result.forEach((item) {
	    list.add(ProjectItem.fromMap(item));
    });
    return list;
  }

  // Delete Operation: Delete all object from database
  Future<int> deleteAllProjects() async {
    final db = await dbProvider.database;
    int result = await db.delete(projectTable);
    return result;
  }
}
