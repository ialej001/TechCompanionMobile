import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/database/DatabaseProvider.dart';
import 'package:tech_companion_mobile/database/blocs/blocProvider.dart';
import 'package:tech_companion_mobile/database/blocs/partsBloc.dart';
import 'package:tech_companion_mobile/models/Part.dart';

class InventoryWindow extends StatefulWidget {
  InventoryWindow({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InventoryWindow();
}

class _InventoryWindow extends State<InventoryWindow> {
  PartsBloc _partsBloc;
  List<Part> parts;

  _InventoryWindow();

  @override
  void initState() {
    super.initState();

    _partsBloc = BlocProvider.of<PartsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
      ),
      body: _body(),
    );
  }

  Widget _body() {
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
    return Container(
      child: Row(children: <Widget>[
        RaisedButton(
            onPressed: _queryServerForParts, child: Text('Sync database')),
      ]),
    );
  }

  Widget _partsView() {
    return Container(
      height: 550,
      width: 460,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: StreamBuilder<List<Part>>(
          stream: _partsBloc.parts,
          builder: (BuildContext context, AsyncSnapshot<List<Part>> snapshot) {
            if (snapshot.hasData) {
              log(snapshot.data.length.toString());
              return ListView.separated(
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
              );
            } else {
              return Container(
                child: Text("no parts in database, please sync"),
              );
            }
          }),
    );
  }

  void _queryServerForParts() {
    log('pressed');
    DatabaseProvider.partsDb.getAllParts().then((List<Part> parts) {
      if (parts.isEmpty) {
        log('loading');
        DatabaseProvider.partsDb.loadDatabase();
      } else {
        log('db initialized');
      }
    });
  }
}
