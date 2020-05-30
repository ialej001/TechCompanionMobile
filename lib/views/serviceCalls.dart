import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';
import 'package:tech_companion_mobile/views/ServiceCalls/detailedServiceCall.dart';

class ServiceCallView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServiceCalls();
}

class _ServiceCalls extends State<ServiceCallView> {
  final HttpService httpService = HttpService();
  List<WorkOrder> workOrders = List<WorkOrder>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Future<List<WorkOrder>> _fetchWorkOrders() async {
    return httpService.getWorkOrders();
  }

  Future<void> _refreshCalls() async {
    var result = await _fetchWorkOrders();
    setState(() {
      workOrders = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchWorkOrders(),
      builder: (BuildContext context, AsyncSnapshot<List<WorkOrder>> snapshot) {
        if (snapshot.hasData) {
          workOrders = snapshot.data;
          return _serviceCallsView(workOrders);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text(snapshot.error));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _serviceCallsView(List<WorkOrder> workOrders, ) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      child: ListView.separated(
        itemCount: workOrders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(workOrders[index].customer.contactName),
            subtitle: Text(workOrders[index].customer.serviceAddress),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(
                    workorder: workOrders[index],
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
      onRefresh: () { return _refreshCalls();},
    );
  }
}
