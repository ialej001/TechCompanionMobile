import 'dart:convert';
import 'package:http/http.dart';
import 'package:tech_companion_mobile/models/Part.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';

class HttpService {
  final String url = "http://138.229.151.202:8080/api";
  // final String url = "http://10.0.2.2:8080/api";
  final Map<String, String> headers = {"Content-type": "application/json"};

  Future<List<WorkOrder>> getWorkOrders() async {
    Response res = await (get("$url/incomplete/ivan"));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<WorkOrder> workOrders = body
          .map(
            (dynamic item) => WorkOrder.fromJson(item),
          )
          .toList();

      return workOrders;
    } 
    if (res.statusCode == 404) {
      print(res.statusCode);
      throw "Can't retrieve work orders";
    } else {
      throw "Something bad happened :(";
    }
  }

  sendCompleteWorkOrder(WorkOrder workOrder) async {
    String id = workOrder.stringId;
    print(id);
    final json = jsonEncode({
      "stringId": workOrder.stringId,
      "issues": workOrder.issues.issues,
      "partsUsed": workOrder.partsUsed,
      "timeStarted": workOrder.timeStarted.toIso8601String(),
      "timeEnded": workOrder.timeEnded.toIso8601String(),
      "customer": workOrder.customer
    });
    print(json);
    Response res = await put("$url/complete/$id",
        headers: headers,
        body:
            json);

    return res.statusCode;
  }

    Future<List<Part>> getParts() async {
    Response res = await get("$url/parts/all");

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Part> parts = body
          .map(
            (dynamic item) => Part.fromJson(item),
          )
          .toList();

      return parts;
    } else {
      throw "Can't retrieve work orders";
    }
  }
}
