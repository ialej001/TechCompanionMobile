import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/bloc/blocProvider.dart';
import 'package:tech_companion_mobile/bloc/partsBloc.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';
import 'package:tech_companion_mobile/views/ServiceCalls/ServiceCallTabs/CustomerInfo.dart';
import 'package:tech_companion_mobile/views/ServiceCalls/ServiceCallTabs/ItemsUsed.dart';
import 'package:tech_companion_mobile/views/ServiceCalls/ServiceCallTabs/Resolutions.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';
import 'package:tech_companion_mobile/views/ServiceCalls/ServiceCallTabs/Summary.dart';

class DetailScreen extends StatefulWidget {
  final WorkOrder workorder;

  DetailScreen({Key key, @required this.workorder}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(workorder);
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  WorkOrder workOrder;
  bool isTimerRunning = false;
  Icon fabIcon = Icon(Icons.play_arrow);
  PartsBloc _partsBloc;
  bool showCompleteButton = false;

  _DetailScreenState(this.workOrder);

  // timer function
  void _toggleTimer() {
    if (workOrder.timeEnded != null) {
      for (Issue issue in workOrder.issues.issues) {
        if (issue.resolution == "") {
          return;
        }
        setState(() {
          showCompleteButton = true;
        });

        return;
      }
    }
    // start state
    if (!isTimerRunning) {
      setState(() {
        isTimerRunning = true;
        fabIcon = Icon(Icons.stop);
        if (workOrder.timeStarted == null) {
          workOrder.timeStarted = new DateTime.now();
        }
      });
    } else {
      setState(() {
        isTimerRunning = false;
        fabIcon = Icon(Icons.check);
        workOrder.timeEnded = new DateTime.now();
      });
    }
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

  final List<Tab> tabs = <Tab>[
    Tab(
      text: 'Customer',
    ),
    Tab(
      text: 'Issues',
    ),
    Tab(
      text: 'Parts',
    ),
    Tab(
      text: 'Summary',
    )
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _partsBloc = BlocProvider.of<PartsBloc>(context);
  }

  @override
  void dispose() {
    _partsBloc.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: _getTitle(
              workOrder.customer.propertyType, workOrder.customer.propertyName),
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            CustomerInfo(
              customer: workOrder.customer,
            ),
            Resolutions(
              issues: workOrder.issues.issues,
              partsUsed: workOrder.partsUsed,
              partsBloc: _partsBloc,
            ),
            ItemsUsed(
              partsUsed: workOrder.partsUsed,
            ),
            Summary(
              workOrder: workOrder,
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                showCompleteButton
                    ? FlatButton(
                        child: Text('Complete'),
                        onPressed: () {
                          _submitWorkOrder(workOrder);
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _toggleTimer(),
          child: fabIcon,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  // Widget _showCompleteButton(WorkOrder workOrder) {
  //   // determine if all issues are done, assume all are completed
  //   // go through each issue, if any resolution fields are empty,
  //   // exit the function with an empty container
  //   for (Issue issue in workOrder.issues.issues) {
  //     if (issue.resolution == "") {
  //       return Container();
  //     }
  //   }

  //   // if the loop completes, then we can show our submission button
  //   // if time has ended
  //   if (workOrder.timeEnded != null) {
  //     return
  //     ;
  //   }

  //   // if the timer is still running, just display nothing
  //   return Container();
  // }

  Text _getTitle(String propertyType, String propertyName) {
    if (propertyName == "")
      return Text(propertyType);
    else
      return Text(propertyName);
  }
}
