import 'dart:async';

import 'package:tech_companion_mobile/database/DatabaseProvider.dart';
import 'package:tech_companion_mobile/database/blocs/blocProvider.dart';
import 'package:tech_companion_mobile/models/Part.dart';

class PartsBloc implements BlocBase {
  final _partsController = StreamController<List<Part>>.broadcast();

  StreamSink<List<Part>> get _inParts => _partsController.sink;

  Stream<List<Part>> get parts => _partsController.stream;

  PartsBloc() {
    getParts();
  }

  @override
  void dispose() {
    _partsController.close();
  }

  void getParts() async {
    List<Part> parts = await DatabaseProvider.partsDb.getAllParts();

    _inParts.add(parts);
  }
}