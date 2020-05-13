import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tech_companion_mobile/graphql/GraphQLConf.dart';
import 'package:tech_companion_mobile/graphql/QueryMutation.dart';

import 'package:tech_companion_mobile/models/Part.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider partsDb = DatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "part.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""CREATE TABLE Part (
        id integer primary key AUTOINCREMENT,
        partNumber TEXT,
        description TEXT,
        name TEXT,
        price DOUBLE,
        quantity INT)""");
    });
  }

  addPart(Part part) async {
    final db = await database;
    var raw = await db.insert("Part", part.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  updatePart(Part part) async {
    final db = await database;
    var response = await db
        .update("Part", part.toMap(), where: "id = ?", whereArgs: [part.id]);
    return response;
  }

  Future<Part> getPartWithId(int id) async {
    final db = await database;
    var response = await db.query("Part", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Part.fromMap(response.first) : null;
  }

  Future<List<Part>> getAllParts() async {
    final db = await database;
    var response = await db.query("Part");
    List<Part> list = response.map((c) => Part.fromMap(c)).toList();
    return list;
  }

  deletePartWithId(int id) async {
    final db = await database;
    return db.delete("Part", where: "id = ?", whereArgs: [id]);
  }

  deleteAllParts() async {
    final db = await database;
    db.delete("Part");
  }

  loadDatabase() async {
    List<dynamic> parts = new List<dynamic>();
    if (_database == null) {
      GraphQLConfiguration()
          .clientToQuery()
          .query(QueryOptions(
              documentNode: gql(QueryMutation().getParts), pollInterval: 10))
          .then((QueryResult result) => {
                parts =
                    result.data['parts'].map((i) => Part.fromJson(i)).toList(),
                parts.forEach((part) {
                  log(part.toString());
                  addPart(part);
                }),
              });
    }
  }
}
