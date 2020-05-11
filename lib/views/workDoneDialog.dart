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
    return AlertDialog(
        title: Text("What did you do for this problem?"),
        content: Container(
            child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: Column(children: <Widget>[
              _workDoneBox(workDoneField),
              _partSearchBar(_insertPartUsed, searchTextField, searchController),
              _partsListView(partsUsed),
            ]),
          ),
        )));
  }

  Widget _partSearchBar(void _insertPartUsed(List<Part> parts, Part part),
      AutoCompleteTextField searchTextField, TextEditingController controller) {
    return Container(
        child: Row(
      children: <Widget>[
        Container(
            width: 190,
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
                          hintText: "name or description"),
                      itemSubmitted: (item) {
                        _insertPartUsed(parts, item);
                      },
                      key: key,
                      suggestions: parts,
                      itemBuilder: (context, item) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(item.name),
                            Padding(padding: EdgeInsets.all(10.0)),
                            Text(item.description)
                          ],
                        );
                      },
                      itemSorter: (a, b) {
                        return a.description.compareTo(b.description);
                      },
                      itemFilter: (item, query) {
                        return item.description
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      },
                    );
                  } else {
                    return Container();
                  }
                })),
        FlatButton(onPressed: null, child: Text("Add"))
      ],
    ));
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
          height: 50,
          child: ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(parts[index].name +
                    ", Quantity Used: " +
                    parts[index].quantity.toString()),
                subtitle: Text("Description: " + parts[index].description),
              );
            },
          ));
    } else {
      return Container();
    }
  }

  void _insertPartUsed(List<Part> parts, Part part) {
    // add the part to partsUsed
    setState(() {
      parts.add(part);
    });
  }
}
