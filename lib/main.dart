import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/bloc/blocProvider.dart';
import 'package:tech_companion_mobile/graphql/GraphQLConf.dart';
import 'package:tech_companion_mobile/views/Inventory.dart';
import 'package:tech_companion_mobile/views/serviceCalls.dart';

import 'bloc/partsBloc.dart';
import 'views/LandingView.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        initialRoute: '/home',
        routes: <String, WidgetBuilder>{
          '/home': (context) => MyHomePage(title: 'TechCompanion'),
          '/detailed-service-call': (context) => ServiceCallView(),
          '/inventory': (context) => InventoryWindow(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedNavTab = 0;
  static List<Widget> _navTabs = <Widget>[
    LandingView(),
    ServiceCallView(),
    InventoryWindow(),
  ];

  void _navTo(int index) {
    setState(() {
      _selectedNavTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: _navTabs.elementAt(_selectedNavTab),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.subject), title: Text('Home')),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            title: Text('Service'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            title: Text('Inventory'),
          )
        ],
        currentIndex: _selectedNavTab,
        onTap: _navTo,
      ),
    );
  }
}
