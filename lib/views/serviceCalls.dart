import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tech_companion_mobile/graphql/QueryMutation.dart';

import 'package:tech_companion_mobile/models/WorkOrder.dart';
import 'detailedServiceCall.dart';

class ServiceCallView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServiceCalls();
}

class _ServiceCalls extends State<ServiceCallView> {
  QueryMutation queryMutation = QueryMutation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service calls'),
        ),
      body: Query(
        options: QueryOptions(
          documentNode: gql(queryMutation.getIncomplete),
          // variables: {},
          pollInterval: 10,
        ),
        builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
          
          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (result.data == null) {
            return Center(child: Text('No service calls right now.'));
          }

          WorkOrders workOrders = new WorkOrders.fromJson(result.data['getIncompleteWorkOrders']);
          return _serviceCallsView(workOrders.workOrders);
        },
      ),
    );
  }

  ListView _serviceCallsView(List<WorkOrder> workOrders) {
    // final serviceCallList = result.data['getIncompleteWorkOrders'];
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
