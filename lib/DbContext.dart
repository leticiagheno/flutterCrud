import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testeinicial/Models/Person.dart';

class DbContext {
  
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'Pessoa';
  
  static final columnId = 'Id';
  static final columnName = 'Name';
  static final columnAge = 'Age';

  DbContext._privateConstructor();
  static final DbContext instance = DbContext._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }
  
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');
  }
  
  Future<int> savePerson(Person person) async {
    var dbClient = await database;
    var result = await dbClient.insert(table, person.toMap());
 
    return result;
  }
 
  Future<List> getAllPersons() async {
    var dbClient = await database;
    var result = await dbClient.rawQuery("Select * from " + table);
 
    return result.toList();
  }
 
  Future<int> getCount() async {
    var dbClient = await database;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $table'));
  }
 
  Future<Person> getPerson(int id) async {
    var dbClient = await database;
    List<Map> result = await dbClient.query(table,
        columns: [columnId, columnName, columnAge],
        where: '$columnId = ?',
        whereArgs: [id]);
 
    if (result.length > 0) {
      return new Person.fromMap(result.first);
    }
 
    return null;
  }
 
  Future<int> deletePerson(int id) async {
    var dbClient = await database;
    return await dbClient.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
 
  Future<int> updatePerson(Person person) async {
    var dbClient = await database;
    var sql = 'UPDATE $table SET $columnName = \'${person.name}\', $columnAge = \'${person.age}\' WHERE $columnId = ${person.id}';
    return  dbClient.rawUpdate(sql);
  }
 
  Future close() async {
    var dbClient = await database;
    return dbClient.close();
  }
}