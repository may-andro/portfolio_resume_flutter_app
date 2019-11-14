import 'package:mayandro_resume/model/profile.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class ProfileDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Insert Operation: Insert a object to database
  Future<int> insertProfile(ProfileItem profileItem) async {
    final db = await dbProvider.database;
    var result = await db.insert(profileTable, profileItem.toJson());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateProfile(ProfileItem profileItem) async {
    final db = await dbProvider.database;
    var result = await db.update(profileTable, profileItem.toJson(),
        where: '$columnProfileName = ?', whereArgs: [profileItem.name]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteProfile(String name) async {
    final db = await dbProvider.database;
    int result = await db.rawDelete('DELETE FROM $profileTable WHERE $columnProfileName = $name');
    return result;
  }

  // Get number of objects in database
  Future<int> getCount() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $profileTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Fetch Operation: Get all objects from database
  Future<ProfileItem> getCurrentProfiles() async {
    final db = await dbProvider.database;
    var result = await db.query(profileTable, orderBy: '$columnId ASC');
    return ProfileItem.fromMap(result[0]);
  }

  // Delete Operation: Delete all object from database
  Future<int> deleteAllProfiles() async {
    final db = await dbProvider.database;
    int result = await db.delete(profileTable);
    return result;
  }
}
