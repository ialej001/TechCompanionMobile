import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/bloc/partsBloc.dart';
import 'package:tech_companion_mobile/models/Part.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';

class Resolutions extends StatefulWidget {
  Resolutions({Key key, this.issues, this.partsUsed, this.partsBloc})
      : super(key: key);

  final List<Issue> issues;
  final List<Part> partsUsed;
  final PartsBloc partsBloc;

  @override
  State<StatefulWidget> createState() =>
      _ResolutionsView(this.issues, this.partsUsed, this.partsBloc);
}

class _ResolutionsView extends State<Resolutions> {
  List<Issue> issues;
  List<Part> partsUsed;
  PartsBloc partsBloc;

  // final _formKey = GlobalKey<FormState>();

  // text controllers
  TextEditingController searchController = TextEditingController();
  AutoCompleteTextField searchTextField;

  _ResolutionsView(this.issues, this.partsUsed, this.partsBloc);

  // this is our dialog builder that is called when an issue block is tapped
  // allows our user to input what work they did for that issue
  Future<void> _openResolutionForm(int index) async {
    String inputtedText;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('What was wrong?'),
          content: Container(
            child: TextFormField(
              // most of the time this is empty, but if something is there, show it
              initialValue: issues[index].resolution,
              // character limit
              maxLength: 500,
              // keyboard with new line for the 'enter' button
              keyboardType: TextInputType.multiline,
              autofocus: false,
              maxLines: null,
              onChanged: (String textTyped) {
                setState(() {
                  inputtedText = textTyped;
                });
              },
              decoration: InputDecoration(
                labelText: "Work performed:",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // our cancel button
            FlatButton(
              onPressed: () {
                setState(() {
                  // clear any inputted text, regardless if it's filled or not
                  issues[index].resolution = '';
                });
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            // complete button
            FlatButton(
              onPressed: () {
                setState(() {
                  // commit our changes to the work order object
                  issues[index].resolution = inputtedText;
                });
                Navigator.of(context).pop();
              },
              child: Text('Complete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    partsBloc = PartsBloc();
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Issues reported:',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          _buildIssues(issues),
        ],
      ),
    );
  }

  Widget _buildIssues(List<Issue> issues) {
    return Expanded(
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // for each tile to be rendered, check if it's been 'resolved', ie empty string
            // red for incomplete, green for complete
            final color =
                issues[index].resolution == "" ? Colors.red : Colors.green;
            return Container(
              color: color,
              child: ListTile(
                title: Text("Problem at " + issues[index].location + ':\n'),
                subtitle: Text(issues[index].problem),
                onTap: () => _openResolutionForm(index),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: issues.length),
    );
  }
}
