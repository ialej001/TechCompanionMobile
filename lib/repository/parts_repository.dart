import 'package:tech_companion_mobile/dao/parts_dao.dart';
import 'package:tech_companion_mobile/models/Part.dart';

class PartsRepository {
  final partsDao = PartsDao();

  Future insertPart(Part part) => partsDao.addPart(part);

  Future getAllParts() => partsDao.getAllParts();

  Future updatePart(Part part) => partsDao.updatePart(part);

  Future deletePartById(int id) => partsDao.deletePart(id);

  Future deleteAllParts() => partsDao.deleteAllParts();
}