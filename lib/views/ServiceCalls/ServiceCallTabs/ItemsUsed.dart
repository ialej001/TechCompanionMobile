import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/bloc/partsBloc.dart';
import 'package:tech_companion_mobile/models/Part.dart';

class ItemsUsed extends StatefulWidget {
  ItemsUsed({Key key, this.partsUsed}) : super(key: key);

  final List<Part> partsUsed;
  @override
  State<StatefulWidget> createState() => _ItemsUsedView(this.partsUsed);
}

class _ItemsUsedView extends State<ItemsUsed> {
  // variables
  PartsBloc partsBloc = PartsBloc();
  List<Part> partsUsed;
  GlobalKey<AutoCompleteTextFieldState<Part>> key = new GlobalKey();
  TextEditingController searchController = TextEditingController();
  AutoCompleteTextField searchTextField;
  // functions

  _ItemsUsedView(this.partsUsed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Column(
        children: <Widget>[
          _partSearchBar(searchTextField, searchController),
          _partsListView(partsUsed),
        ],
      ),
    );
  }

  Widget _partSearchBar(
      AutoCompleteTextField searchTextField, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      width: MediaQuery.of(context).size.width,
      // our parts bloc is consumed as a stream
      child: StreamBuilder<List<Part>>(
        stream: partsBloc.parts,
        builder: (BuildContext context, AsyncSnapshot<List<Part>> snapshot) {
          // data in the stream
          if (snapshot.hasData) {
            List<Part> parts = snapshot.data;
            return AutoCompleteTextField<Part>(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
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
              // max suggestions
              suggestionsAmount: 10,
              // length of input required to show results
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
                  ),
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
            return Container(
              child: Text('nothing'),
            );
          }
        },
      ),
    );
  }

  // this is our widget that displays the parts that have been selected
  Widget _partsListView(List<Part> parts) {
    if (parts.isNotEmpty) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 30),
          // .builder method allows us to use custom tiles
          child: ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final part = parts[index];
              // dismissible allows the user to remove an item from the list
              return Dismissible(
                key: Key(part.partNumber),
                child: ListTile(
                  // minus button
                  leading: Container(
                    width: 48,
                    height: 48,
                    child: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (part.quantity == 0) return;

                            part.quantity--;
                          });
                        }),
                  ),
                  title: Text(part.description),
                  subtitle: Text("Quantity Used: " + part.quantity.toString()),
                  // plus button
                  trailing: Container(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          part.quantity++;
                        });
                      },
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  setState(() {
                    parts.removeAt(index);
                  });
                },
                background: Container(color: Colors.red),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  return await _confirmItemRemoval(context);
                },
              );
            },
          ),
        ),
      );
    } else {
      return Container(
          padding: EdgeInsets.only(top: 120, bottom: 160),
          child: Center(
            child: Text("No parts used."),
          ));
    }
  }

  Future<bool> _confirmItemRemoval(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to remove this item?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('No'),
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
