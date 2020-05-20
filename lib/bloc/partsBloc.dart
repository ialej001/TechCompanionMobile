import 'dart:async';
import 'package:tech_companion_mobile/bloc/blocProvider.dart';
import 'package:tech_companion_mobile/models/Part.dart';
import 'package:tech_companion_mobile/repository/parts_repository.dart';

class PartsBloc implements BlocBase {
  final _partsRepository = PartsRepository();

  final _partsController = StreamController<List<Part>>.broadcast();

  // StreamSink<List<Part>> get _inParts => _partsController.sink;

  get parts => _partsController.stream;

  PartsBloc() {
    getParts();
  }

  getParts() async {
    _partsController.sink.add(await _partsRepository.getAllParts());
  }

  addPart(Part part) async {
    await _partsRepository.insertPart(part);
  }
  
  updatePart(Part part) async {
    await _partsRepository.updatePart(part);
    getParts();
  }

  deletePartById(int id) async {
    _partsRepository.deletePartById(id);
    getParts();
  }

  dispose() {
    _partsController.close();
  }
}