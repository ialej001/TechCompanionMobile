import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ServiceCallView extends StatelessWidget {
  final String query = '''
              query getWorkOrders {
                getIncompleteWorkOrders(isCompleted: false) {
                  customer {
                    contactName
                    contactPhone
                    gateLocations
                    serviceAddress
                  }
                  issues {
                    location
                    problem
                  }
                  isCompleted
                }
              }
              ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service calls'),
        ),
      body: Query(
        options: QueryOptions(
          documentNode: gql(query),
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

          return _serviceCallsView(result);
        },
      ),
    );
  }

  ListView _serviceCallsView(QueryResult result) {
    final serviceCallList = result.data['getIncompleteWorkOrders'];
    return ListView.separated(
      itemCount: serviceCallList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(serviceCallList[index]['customer']['contactName']),
          subtitle: Text(serviceCallList[index]['customer']['serviceAddress'])
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
