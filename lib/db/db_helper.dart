import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../models/puppy.dart';

class DBHelper{
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "puppies";

  static Future<void> initDb() async{
    if(_db != null){
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'puppy.db';
      _db = await openDatabase(
          _path,
        version: _version,
        onCreate: (db, version){
            print("creating a new one");
            return db.execute(
              "CREATE TABLE $_tableName("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "name STRING, serviceDetails TEXT,"
                  "date STRING, arrivalTime STRING, isServiced INTEGER)"
            );
        }
      );
    } catch (e){
      print(e);
    }
  }

  static Future<int> insert(Puppy? puppy) async {
    print("insert function called");
    print(puppy?.toJson());
    return await _db?.insert(_tableName, puppy!.toJson())??1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query the puppy list");
    return await _db!.query(_tableName);
  }

  static void delete(Puppy puppy) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [puppy.id]);
  }

  static update(int id) async{
   await _db!.rawUpdate('''
        UPDATE puppies
        SET isServiced = ?
        WHERE id = ?
    ''', [1, id]);
  }
}