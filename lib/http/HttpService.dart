import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';

class HttpService {
  final String url = "http://10.0.2.2:9000/api";
  final Map<String, String> headers = {"Content-type": "application/json"};

  Future<List<WorkOrder>> getWorkOrders() async {
    Response res = await get("$url/incomplete");

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<WorkOrder> workOrders = body
          .map(
            (dynamic item) => WorkOrder.fromJson(item),
          )
          .toList();

      return workOrders;
    } else {
      throw "Can't retrieve work orders";
    }
  }

  sendCompleteWorkOrder(WorkOrder workOrder) async {
    String id = workOrder.stringId;
    final json = jsonEncode({
      "issues": workOrder.issues.issues,
      "partsUsed": workOrder.partsUsed,
      "timeStarted": workOrder.timeStarted.toIso8601String(),
      "timeEnded": workOrder.timeEnded.toIso8601String()
    });
    Response res = await put("$url/complete/$id",
        headers: headers,
        body:
            json);

    return res.statusCode;
  }
}
