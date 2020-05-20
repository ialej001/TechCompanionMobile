import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';

class DatabaseProvider {
  // DatabaseProvider._();
  final HttpService httpService = HttpService();

  static final DatabaseProvider partsDb = DatabaseProvider();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "parts.db");
    return await openDatabase(path, version: 1, onCreate: initDB);
  }

  void initDB(Database database, int version) async {
    await database.execute("""CREATE TABLE Parts (
        id integer primary key AUTOINCREMENT,
        partNumber TEXT,
        description TEXT,
        name TEXT,
        price DOUBLE,
        quantity INT)""");
  }
}
