import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/database/blocs/blocProvider.dart';
import 'package:tech_companion_mobile/database/blocs/partsBloc.dart';
import 'package:tech_companion_mobile/models/Part.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';

class WorkDoneView extends StatefulWidget {
  final List<Part> partsUsed;
  final Issue issue;

  WorkDoneView({Key key, this.partsUsed, this.issue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _WorkDoneView(this.partsUsed, this.issue);
}

class _WorkDoneView extends State<WorkDoneView> {
  PartsBloc _partsBloc;
  GlobalKey<AutoCompleteTextFieldState<Part>> key = new GlobalKey();
  final _formKey = GlobalKey<FormState>();

  // text controllers
  TextEditingController workDoneField = TextEditingController();
  TextEditingController searchController = TextEditingController();
  AutoCompleteTextField searchTextField;

  // variables
  List<String> workPerformed;
  List<Part> partsUsed;
  int issueIndex;
  Issue issue;

  _WorkDoneView(this.partsUsed, this.issue);

  @override
  void dispose() {
    _partsBloc.dispose();
    workDoneField.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _partsBloc = BlocProvider.of<PartsBloc>(context);
    
    if (issue.resolution != null) {
      workDoneField.text = issue.resolution;
    }
    partsUsed = partsUsed;
  }

  void _saveChanges() {
    issue.resolution = workDoneField.text;

    Navigator.pop(
        context, WorkDoneForIssue(partsUsed, workPerformed, issueIndex));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Problem resolution"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.check), onPressed: _saveChanges)
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
                child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  _workDoneBox(workDoneField),
                  _partSearchBar(searchTextField, searchController),
                  _partsListView(partsUsed),
                ]),
              ),
            ))));
  }

  Widget _partSearchBar(
      AutoCompleteTextField searchTextField, TextEditingController controller) {
    return Container(
        margin: EdgeInsets.only(top: 15),
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      hintText: "Add part by description..."),
                  itemSubmitted: (item) {
                    setState(() {
                      item.quantity = 1;
                      partsUsed.add(item);
                    });
                  },
                  clearOnSubmit: true,
                  key: key,
                  suggestions: parts,
                  suggestionsAmount: 10,
                  minLength: 3,
                  itemBuilder: (context, item) {
                    return Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                                child: Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ))
                          ],
                        ));
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
      padding: EdgeInsets.only(top: 15),
      child: TextField(
          maxLength: 200,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          autofocus: false,
          maxLines: 20,
          controller: workDoneField,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.perm_identity),
              labelText: "Work performed for this issue:",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))))),
    );
  }

  Widget _partsListView(List<Part> parts) {
    if (parts.isNotEmpty) {
      return Container(
          height: 300,
          child: ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  child: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (parts[index].quantity == 0) return;

                          parts[index].quantity--;
                        });
                      }),
                ),
                title: Text(parts[index].description
                    ),
                subtitle: Text(
                     "Quantity Used: " +
                    parts[index].quantity.toString()),
                trailing: Container(
                    width: 48,
                    height: 48,
                    child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            parts[index].quantity++;
                          });
                        })),
              );
            },
          ));
    } else {
      return Container(
          padding: EdgeInsets.only(top: 120, bottom: 160),
          child: Center(
            child: Text("No parts used."),
          ));
    }
  }
}
