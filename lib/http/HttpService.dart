import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:tech_companion_mobile/models/LoginResponse.dart';
import 'package:tech_companion_mobile/models/Part.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';
import 'package:tech_companion_mobile/views/LogIn.dart';

class HttpService {
  // final String url = "http://138.229.151.202:8080/api";
  final String url = "http://10.0.2.2:8080/api";
  // storage for key
  final storage = FlutterSecureStorage();
  final token = "";
  final Map<String, String> loginHeader = {"Content-type": "application/json"};

  Map<String, String> getAuthHeader(String token) {
    return {"Authorization": "Bearer $token"};
  }

  bool checkTokenExpiration() {
    // TODO: check for token validity
    return false;
  }

  Future<String> attemptLogIn(String name, String pass) async {
    Response res = await post("$url/auth/login",
        headers: loginHeader,
        body: jsonEncode({"username": name, "password": pass}));
    String token = LoginResponse.fromJson(jsonDecode(res.body)).token;
    if (res.statusCode == 200) return token;
    return null;
  }

  void logOut(BuildContext context) async {
    storage.delete(key: "jwt");
    // make logout call to server once implemented
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  // TODO: attach jwt to all queries
  Future<List<WorkOrder>> getWorkOrders(String token) async {
    Map<String, String> authHeader = {"Authorization": "Bearer $token"};

    Response res = await (get("$url/incomplete/ivan", headers: authHeader));
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
      throw "No open work orders";
    } else {
      throw "Something bad happened :(";
    }
  }

  sendCompleteWorkOrder(String token, WorkOrder workOrder) async {
    String id = workOrder.stringId;
    final json = jsonEncode({
      "stringId": workOrder.stringId,
      "issues": workOrder.issues.issues,
      "partsUsed": workOrder.partsUsed,
      "timeStarted": workOrder.timeStarted.toIso8601String(),
      "timeEnded": workOrder.timeEnded.toIso8601String(),
      "customer": workOrder.customer
    });
    Map<String, String> authHeader = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    print(authHeader);
    Response res =
        await put("$url/complete/$id", headers: authHeader, body: json);

    print(res.body);
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
