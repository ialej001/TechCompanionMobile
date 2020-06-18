import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/bloc/blocProvider.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';
import 'package:tech_companion_mobile/views/Home.dart';
import 'package:tech_companion_mobile/views/Inventory.dart';
import 'package:tech_companion_mobile/views/LogIn.dart';
import 'package:tech_companion_mobile/views/serviceCalls.dart';
import 'bloc/partsBloc.dart';

// this is our entry point into the whole application
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
    // the bloc contains all the logic needed for parts allocation and selection
    return BlocProvider<PartsBloc>(
      bloc: PartsBloc(),
      child: MaterialApp(
        title: 'TechCompanion',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // want to route to the root on log out. '/' means the home widget below
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/home': (context) => HomePage(title: 'TechCompanion'),
          '/detailed-service-call': (context) => ServiceCallView(),
          '/inventory': (context) => InventoryWindow(),
          '/login': (context) => LoginPage(),
        },
        // always default to this widget builder
        home: FutureBuilder(
          // all depends if we have a jwt stored
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            // if we're still looking, display the indicator
            if (!snapshot.hasData) return CircularProgressIndicator();
            // if we have a jwt
            if (snapshot.data != "") {
              var jwt = snapshot.data.split("."); // array[3]
              if (jwt.length != 3) { // some wrong jwt
                return LoginPage();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                // if the jwt is still valid
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
