import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/bloc/blocProvider.dart';
import 'package:tech_companion_mobile/bloc/partsBloc.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';
import 'package:tech_companion_mobile/views/workDoneDialog.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';

class DetailScreen extends StatefulWidget {
  final WorkOrder workorder;

  DetailScreen({Key key, @required this.workorder}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(workorder);
}

class _DetailScreenState extends State<DetailScreen> {
  WorkOrder workOrder;

  _DetailScreenState(this.workOrder);

  // time functions
  void _setTimeStarted() {
    setState(() {
      this.workOrder.timeStarted = new DateTime.now();
      debugPrint(workOrder.timeStarted.toString());
    });
  }

  void _setTimeEnded() {
    setState(() {
      this.workOrder.timeEnded = new DateTime.now();
      debugPrint(workOrder.timeEnded.toString());
    });
  }

  void _addWorkPerformed(int issueIndex) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
              bloc: PartsBloc(),
              child: WorkDoneView(
                  partsUsed: workOrder.partsUsed,
                  issue: workOrder.issues.issues[issueIndex])),
        ));
  }

  void _submitWorkOrder(WorkOrder workOrder) {
    HttpService httpService = HttpService();

    httpService.sendCompleteWorkOrder(workOrder).then((result) {
      if (result != 200) {
        log('error');
        return;
      }

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Details...")),
        body: Container(
            // height: 700,
            child: Column(children: <Widget>[
          _buildCustomerInfo(context, workOrder),
          _buildIssues(workOrder.getIssues(), _addWorkPerformed),
          Expanded(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: _buildNavButtons(this, workOrder)))
        ])));
  }

  Widget _buildCustomerInfo(BuildContext context, WorkOrder workOrder) {
    return Container(
        // height: 170,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          Container(
              width: 200,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Property Type: ' + workOrder.customer.propertyType),
                  if (workOrder.customer.propertyType != 'House')
                    Text('Property Name: ' + workOrder.customer.propertyName),
                  Text('\nCustomer information:'),
                  Text(workOrder.customer.contactName +
                      ', \n' +
                      workOrder.customer.contactPhone),
                  Text(workOrder.customer.serviceAddress)
                ],
              )),
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                onPressed: null,
                child: Text('Codes & Info', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 30),
              RaisedButton(
                  onPressed: null,
                  child: Text('Checklists', style: TextStyle(fontSize: 16)))
            ],
          ))
        ]));
  }

  Widget _buildIssues(List<Issue> issues, void workPerformed(int issueIndex)) {
    return Container(
        margin: EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
        height: 300,
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Issues reported:\n',
                  style: TextStyle(fontSize: 18),
                )),
            LimitedBox(
                maxHeight: 250,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final color =
                          workOrder.issues.issues[index].resolution == ""
                              ? Colors.red
                              : Colors.green;
                      return Container(
                          color: color,
                          child: ListTile(
                            title: Text(
                                "Problem at " + issues[index].location + ':\n'),
                            subtitle: Text(issues[index].problem),
                            onTap: () => workPerformed(index),
                          ));
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: issues.length))
          ],
        ));
  }

  Widget _buildNavButtons(_DetailScreenState state, WorkOrder workOrder) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 25),
      child: Row(
        children: <Widget>[
          // open google maps navigation button
          RaisedButton(onPressed: null, child: Text('Navigate')),
          Container(
              child: _displayTimeStamps(
                  this.workOrder.timeStarted, this.workOrder.timeEnded)),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: _workOrderState(state, workOrder)))
        ],
      ),
    );
  }

  Widget _workOrderState(_DetailScreenState state, WorkOrder workOrder) {
    if (workOrder.timeStarted == null)
      return RaisedButton(
          onPressed: state._setTimeStarted, child: Text('Start time'));
    else if (workOrder.timeEnded == null)
      return RaisedButton(
          onPressed: state._setTimeEnded, child: Text('Stop time'));
    else if (workOrder.timeStarted != null) {
      return RaisedButton(
          onPressed: () {
            _submitWorkOrder(workOrder);
          },
          child: Text('Update'));
    } else {
      return RaisedButton(
          onPressed: () {
            _submitWorkOrder(workOrder);
          },
          child: Text('Submit'));
    }
  }

  Widget _displayTimeStamps(DateTime started, DateTime ended) {
    String startedStr =
        started == null ? "" : "${started.hour}:${started.minute}";
    String endedStr = ended == null ? "" : "${ended.hour}:${ended.minute}";
    String date = started == null
        ? ""
        : "${started.month}/${started.day}/${started.year}";

    if (started == null) {
      return Container();
    }

    return Container(
        padding: EdgeInsets.only(left: 10),
        child: Text(startedStr + " - " + endedStr + ", " + date));
  }
}
