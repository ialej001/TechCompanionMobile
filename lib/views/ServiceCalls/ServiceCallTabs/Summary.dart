import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';

class Summary extends StatefulWidget {
  Summary({Key key, this.workOrder});

  final WorkOrder workOrder;

  @override
  State<StatefulWidget> createState() => _SummaryView(this.workOrder);
}

class _SummaryView extends State<Summary> {
  _SummaryView(this.workOrder);

  WorkOrder workOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5),
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildTimeStarted(workOrder),
                _buildTimeEnded(workOrder),
                // Spacer(flex: 1,),
              ],
            ),
          ),
          Expanded(
            // spacer - TODO: possible parts summary?
            flex: 2,
            child: Container(),
          ),
          _buildPriceSummary(workOrder),
        ],
      ),
    );
  }

  Widget _buildTimeStarted(WorkOrder workOrder) {
    String message;
    if (workOrder.timeStarted == null) {
      message = "Time Started:\nHaven't Started";
    } else {
      String timeStarted = new DateFormat("jm").format(workOrder.timeStarted);
      message = 'Time Started:\n' + timeStarted;
    }

    return Expanded(
      flex: 2,
      child: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildTimeEnded(WorkOrder workOrder) {
    String message;
    if (workOrder.timeStarted == null) {
      message = 'Time Ended:\nHaven\'t Started';
    } else if (workOrder.timeEnded == null) {
      message = "Time Ended:\nIn progress";
    } else {
      String timeEndedFormatted =
          new DateFormat("jm").format(workOrder.timeEnded);
      message = 'Time Ended:\n' + timeEndedFormatted;
    }

    return Expanded(
      flex: 2,
      child: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildPriceSummary(WorkOrder workOrder) {
    // get our subtotal from all parts used
    workOrder.subTotal = 0.0;
    if (workOrder.partsUsed.isNotEmpty) {
      workOrder.partsUsed.forEach((part) {
        // prices are doubles, quantity is an int
        workOrder.subTotal += part.price * part.quantity;
      });
    }
    // get labor charge based on time taken
    if (workOrder.timeStarted != null && workOrder.timeEnded != null) {
      // find how long the tech was at the job in minutes
      Duration timeDuration =
          workOrder.timeEnded.difference(workOrder.timeStarted);
      int totalTime = timeDuration.inMinutes;

      // any call up to an hour is fixed to the rate
      if (totalTime <= 60)
        workOrder.labor = workOrder.customer.laborRate;
      // otherwise time is prorated after the first hour every half hour
      else {
        int remainingTime = totalTime -= 60;
        double multiplier = 1;
        // find how many 'half hour chunks' were used. if a call took 91 min,
        // multiplier will be 2.0: 60 + 30/30 + 1/30
        while (remainingTime > 0) {
          multiplier += 0.5;
          remainingTime -= 30;
        }
        workOrder.labor = workOrder.customer.laborRate * multiplier;
      }
    }

    // get our tax based on subtotal
    workOrder.tax = workOrder.subTotal * (workOrder.customer.taxRate / 100);

    // finally, our total
    workOrder.total = workOrder.subTotal + workOrder.labor + workOrder.tax;

    // return our widget
    return Expanded(
      flex: 2,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: <Widget>[
            Text(
              'Subtotal: \$' + workOrder.subTotal.toStringAsFixed(2),
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Text(
              'Labor: \$' + workOrder.labor.toStringAsFixed(2),
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Text(
              'Tax (' +
                  workOrder.customer.taxRate.toString() +
                  '%): \$' +
                  workOrder.tax.toStringAsFixed(2),
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Text(
              'Total: \$' + workOrder.total.toStringAsFixed(2),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
