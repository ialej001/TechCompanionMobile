import 'dart:developer';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/database/blocs/blocProvider.dart';
import 'package:tech_companion_mobile/database/blocs/partsBloc.dart';

import 'package:tech_companion_mobile/models/Part.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';

class WorkDoneWindow extends StatefulWidget {
  final Issue issue;
  final String workPerformed = "";
  final List<Part> partsUsed = List<Part>();

  WorkDoneWindow({Key key, this.issue}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _WorkDoneWindow(this.issue, this.workPerformed, this.partsUsed);
}

class _WorkDoneWindow extends State<WorkDoneWindow> {
  PartsBloc _partsBloc;
  GlobalKey<AutoCompleteTextFieldState<Part>> key = new GlobalKey();

  // text controllers
  TextEditingController workDoneField = TextEditingController();
  TextEditingController searchController = TextEditingController();
  AutoCompleteTextField searchTextField;

  // variables
  Issue issue;
  String workPerformed;
  List<Part> partsUsed = List<Part>();

  _WorkDoneWindow(this.issue, this.workPerformed, this.partsUsed);

  @override
  void initState() {
    super.initState();

    _partsBloc = BlocProvider.of<PartsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("What did you do for this problem?"),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Column(children: <Widget>[
                  _workDoneBox(workDoneField),
                  _partSearchBar(searchTextField, searchController),
                  _partsListView(partsUsed),
                ]),
              ),
            )));
  }

  Widget _partSearchBar(
      AutoCompleteTextField searchTextField, TextEditingController controller) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<List<Part>>(
            stream: _partsBloc.parts,
            builder:
                (BuildContext context, AsyncSnapshot<List<Part>> snapshot) {
              if (snapshot.hasData) {
                List<Part> parts = snapshot.data;

                return AutoCompleteTextField<Part>(
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add part by description..."),
                  itemSubmitted: (item) {
                    // _insertPartUsed(parts, item);
                    log('submit');
                    setState(() {
                      item.quantity = 1;
                      partsUsed.add(item);
                    });
                    log(partsUsed.length.toString());
                  },
                  clearOnSubmit: true,
                  key: key,
                  suggestions: parts,
                  suggestionsAmount: 10,
                  minLength: 3,
                  itemBuilder: (context, item) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(child: Text(item.description))
                      ],
                    );
                  },
                  itemSorter: (a, b) {
                    return a.description.compareTo(b.description);
                  },
                  itemFilter: (item, query) {
                    return item.description
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  },
                );
              } else {
                return Container();
              }
            }));
  }

  Widget _workDoneBox(TextEditingController workDoneField) {
    return Container(
      height: 160,
      child: TextField(
          maxLength: 200,
          keyboardType: TextInputType.multiline,
          maxLines: 20,
          controller: workDoneField,
          decoration: InputDecoration(
              icon: Icon(Icons.perm_identity),
              labelText: "Work performed for this issue:")),
    );
  }

  Widget _partsListView(List<Part> parts) {
    if (parts.isNotEmpty) {
      return Container(
          height: 300,
          child: ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) { //TODO rework ListTile into Row w/ two children, ListTile & Row with two icons and quant number
              return ListTile(
                title: Text(parts[index].description +
                    ", Quantity Used: " +
                    parts[index].quantity.toString()),
                subtitle: Text("Description: " + parts[index].description),
              );
            },
          ));
    } else {
      return Container(padding: EdgeInsets.only(top: 120),child: Center(child: Text("No parts used."),));
    }
  }
}
