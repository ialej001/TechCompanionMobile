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
  final String jwt;

  DetailScreen({Key key, @required this.workorder, this.jwt}) : super(key: key);

  @override
  _DetailScreenState createState() =>
      _DetailScreenState(this.workorder, this.jwt);
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  WorkOrder workOrder;
  bool isTimerRunning = false;
  Icon fabIcon = Icon(Icons.play_arrow);
  PartsBloc _partsBloc;
  bool showCompleteButton = false;
  String jwt;

  _DetailScreenState(this.workOrder, this.jwt);

  // our time stamp function: has three different states
  void _toggleTimer() {
    // after the clock has been stopped
    if (workOrder.timeEnded != null) {
      // prevent the user from submitting an unresolved work order
      for (Issue issue in workOrder.issues.issues) {
        if (issue.resolution == "") {
          return;
        }
      }
      // otherwise let's update the state to display the submit button
      setState(() {
        showCompleteButton = true;
      });

      return;
    }
    // start/stop the clock
    if (!isTimerRunning) {
      // starting
      setState(() {
        isTimerRunning = true;
        // change our icon to the stop symbol
        fabIcon = Icon(Icons.stop);
        if (workOrder.timeStarted == null) {
          workOrder.timeStarted = new DateTime.now();
        }
      });
    } else {
      setState(() {
        isTimerRunning = false;
        // change our icon to the check symbol
        fabIcon = Icon(Icons.check);
        workOrder.timeEnded = new DateTime.now();
      });
    }
  }

  void _submitWorkOrder(WorkOrder workOrder) async {
    HttpService httpService = HttpService();
    // grab our token from the storage
    var token = await httpService.storage.read(key: "jwt");

    // TODO: add a catch handler for errors
    httpService.sendCompleteWorkOrder(token, workOrder).then((result) {
      if (result != 200) {
        log(result.toString());
        return;
      }

      // TODO: return our completed data
      // removes this widget off the navigation stack going back to 'Home: ServiceCalls'
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
    // instantiate our parts bloc that was provided to the entire app in the main widget
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
        // when a user flips through the different tabs, the underlying
        // workorder is the *same* reference. changes made in one widget is 
        // reflected across the others
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
                // ternary statement to show/hide our 'complete' button
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
        // our red button on the bottom dock
        floatingActionButton: FloatingActionButton(
          onPressed: () => _toggleTimer(),
          child: fabIcon,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // prevent flutter from redrawing the view to include the bottom portion of this
        // widget when a keyboard is being used
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Text _getTitle(String propertyType, String propertyName) {
    if (propertyName == "")
      return Text(propertyType);
    else
      return Text(propertyName);
  }
}
