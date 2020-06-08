import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';
import 'package:tech_companion_mobile/views/ServiceCalls/detailedServiceCall.dart';

class ServiceCallView extends StatefulWidget {
  ServiceCallView({Key key, this.jwt}) : super(key: key);
  final String jwt;
  @override
  State<StatefulWidget> createState() => _ServiceCalls(this.jwt);
}

class _ServiceCalls extends State<ServiceCallView> {
    _ServiceCalls(this.jwt);

  final String jwt;
  final HttpService httpService = HttpService();
  List<WorkOrder> workOrders = List<WorkOrder>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Future<String> getToken() async {
    return httpService.storage.read(key: "jwt");
  }
  
  Future<List<WorkOrder>> _fetchWorkOrders() async {
    String token = await getToken();
    print(token);
    return httpService.getWorkOrders(token);
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
          print(snapshot.data);
          workOrders = snapshot.data;
          return _serviceCallsView(workOrders);
        } else if (snapshot.hasError) {
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
                    jwt: jwt,
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
