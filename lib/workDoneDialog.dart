import 'package:flutter/material.dart';

import 'Part.dart';
import 'WorkOrder.dart';

class WorkDoneWindow extends StatefulWidget {
  final Issue issue;
  final String workPerformed = "";
  final List<Part> partsUsed = List<Part>();
  
  WorkDoneWindow({Key key, this.issue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WorkDoneWindow(this.issue, this.workPerformed, this.partsUsed);
}

class _WorkDoneWindow extends State<WorkDoneWindow> {
  Issue issue;
  String workPerformed;
  List<Part> partsUsed;

  _WorkDoneWindow(this.issue, this.workPerformed, this.partsUsed);

  @override Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("What did you do for this problem?")
    );
  }
}