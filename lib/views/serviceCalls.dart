import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/graphql/QueryMutation.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';

import 'package:tech_companion_mobile/models/WorkOrder.dart';
import 'detailedServiceCall.dart';

class ServiceCallView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServiceCalls();
}

class _ServiceCalls extends State<ServiceCallView> {
  QueryMutation queryMutation = QueryMutation();
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service calls'),
        ),
      body: FutureBuilder(
        future: httpService.getWorkOrders(), 
        builder: (BuildContext context, AsyncSnapshot<List<WorkOrder>> snapshot) {
          if (snapshot.hasData) {
            List<WorkOrder> workOrders = snapshot.data;
            return _serviceCallsView(workOrders);
          } else if (snapshot.hasError) {
            return Center(child: Text('An error has occurred'));
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  ListView _serviceCallsView(List<WorkOrder> workOrders) {
    return ListView.separated(
      itemCount: workOrders.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(workOrders[index].customer.contactName),
          subtitle: Text(workOrders[index].customer.serviceAddress),
          onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(workorder: workOrders[index],)
              )
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
