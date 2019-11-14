import 'package:mayandro_resume/model/contact.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class ContactDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Insert Operation: Insert a object to database
  Future<int> insertContact(ContactItem contactItem) async {
    final db = await dbProvider.database;
    var result = await db.insert(contactTable, contactItem.toJson());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateContact(ContactItem contactItem) async {
    final db = await dbProvider.database;
    var result =
        await db.update(contactTable, contactItem.toJson(), where: '$columnContactValue = ?', whereArgs: [contactItem.value]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteContact(String item) async {
    final db = await dbProvider.database;
    int result = await db.rawDelete('DELETE FROM $contactTable WHERE $columnContactValue = $item');
    return result;
  }

  // Get number of objects in database
  Future<int> getCount() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $contactTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Fetch Operation: Get all objects from database
  Future<List<ContactItem>> getAllContacts() async {
    final db = await dbProvider.database;
    var result = await db.query(contactTable, orderBy: '$columnId ASC');
    List<ContactItem> list = [];
    result.forEach((item){
	  list.add(ContactItem.fromMap(item));
    });
    return list;
  }

  // Delete Operation: Delete all object from database
  Future<int> deleteAllContacts() async {
    final db = await dbProvider.database;
    int result = await db.delete(contactTable);
    return result;
  }
}
