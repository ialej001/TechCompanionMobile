import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/bloc/partsBloc.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';
import 'package:tech_companion_mobile/models/Part.dart';
import 'package:tech_companion_mobile/repository/parts_repository.dart';

class InventoryWindow extends StatefulWidget {
  InventoryWindow({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InventoryWindow();
}

class _InventoryWindow extends State<InventoryWindow> {
  PartsBloc partsBloc = PartsBloc();
  List<Part> parts;
  final HttpService httpService = HttpService();
  final _partsRepository = PartsRepository();

  _InventoryWindow();

  @override
  void initState() {
    super.initState();

    // _partsBloc = BlocProvider.of<PartsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _topBar(),
          _partsView(),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Row(children: <Widget>[
        RaisedButton(
            onPressed: _queryServerForParts, child: Text('Sync database')),
        RaisedButton(onPressed: _emptyPartsBloc, child: Text('Empty database')),
      ]),
    );
  }

  Widget _partsView() {
    return Expanded(
      child: StreamBuilder(
          stream: partsBloc.parts,
          builder: (BuildContext context, AsyncSnapshot<List<Part>> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.length != 0
                  ? ListView.separated(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Part part = snapshot.data[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 120,
                              child: Text(part.partNumber),
                            ),
                            Container(
                              width: 180,
                              child: Text(part.description),
                            ),
                            Container(
                              width: 90,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('\$' + part.price.toString())),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    )
                  : Container(
                      child: Center(
                      child: Text('No parts in database, please sync.'),
                    ));
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }

  void _queryServerForParts() async {
    await _partsRepository.getAllParts().then((result) {
      if (result.isEmpty) {
        httpService.getParts().then((value) {
          value.forEach((part) {
            partsBloc.addPart(part);
          });
        }).catchError((onError) {});
      } else {
        print('loaded');
      }
    });
  }

  void _emptyPartsBloc() async {
    _partsRepository.deleteAllParts();
  }
}
