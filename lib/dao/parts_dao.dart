import 'package:tech_companion_mobile/database/DatabaseProvider.dart';
import 'package:tech_companion_mobile/models/Part.dart';

class PartsDao {
  final dbProvider = DatabaseProvider.partsDb;

  Future<int> addPart(Part part) async {
    final db = await dbProvider.database;
    var raw = db.insert("Parts", part.toMap());
    return raw;
  }

  Future<Part> getPart(int id) async {
    final db = await dbProvider.database;
    var response = await db.query("Parts", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Part.fromMap(response.first) : null;
  }

  Future<List<Part>> getAllParts() async {
    final db = await dbProvider.database;
    var response = await db.query("Parts");
    List<Part> list = response.isNotEmpty
        ? response.map((c) => Part.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<int> updatePart(Part part) async {
    final db = await dbProvider.database;
    return await db
        .update("Parts", part.toMap(), where: "id = ?", whereArgs: [part.id]);
  }

  Future<int> deletePart(int id) async {
    final db = await dbProvider.database;
    return await db.delete("Parts", where: "id = ?", whereArgs: [id]);
  }

  Future deleteAllParts() async {
    final db = await dbProvider.database;
    return await db.delete("Parts");
  }

  // loadDatabase() async {
  //   if (_database == null) {
  //     List<Part> parts = await httpService.getParts();
  //     parts.forEach((part) {
  //       addPart(part);
  //     });
  //   }
  // }
}
