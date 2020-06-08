import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/bloc/blocProvider.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';
import 'package:tech_companion_mobile/views/Home.dart';
import 'package:tech_companion_mobile/views/Inventory.dart';
import 'package:tech_companion_mobile/views/LogIn.dart';
import 'package:tech_companion_mobile/views/serviceCalls.dart';
import 'bloc/partsBloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final HttpService httpService = new HttpService();

  Future<String> get jwtOrEmpty async {
    var jwt = await httpService.storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PartsBloc>(
      bloc: PartsBloc(),
      child: MaterialApp(
        title: 'TechCompanion',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // initialRoute: '/login',
        routes: <String, WidgetBuilder>{
          '/home': (context) => HomePage(title: 'TechCompanion'),
          '/detailed-service-call': (context) => ServiceCallView(),
          '/inventory': (context) => InventoryWindow(),
          '/login': (context) => LoginPage(),
        },
        home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data != "") {
              var jwt = snapshot.data.split("."); // array[3]
              if (jwt.length != 3) { // some wrong jwt
                return LoginPage();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  return HomePage(title: 'TechCompanion');
                } else {
                  return LoginPage();
                }
              }
            } else
              return LoginPage();
          },
        ),
      ),
    );
  }
}
