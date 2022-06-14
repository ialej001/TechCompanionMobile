import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';
import 'package:tech_companion_mobile/views/LandingView.dart';
import 'package:tech_companion_mobile/views/serviceCalls.dart';
import 'Inventory.dart';

// stateful because navigation controller requries it
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.jwt}) : super(key: key);

  final String title;
  final String jwt;

  @override
  _HomePageState createState() => _HomePageState(this.title, this.jwt);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.title, this.jwt);
  String jwt;
  String title;
  int _selectedNavTab = 0;
  List<Widget> _navTabs = <Widget>[
    LandingView(),
    ServiceCallView(),
    InventoryWindow(),
  ];

  void _navTo(int index) {
    setState(() {
      _selectedNavTab = index;
    });
  }

  // our logout confirmation dialog. Give our users a chance to back out
  // important to know that this dialog is another widget on the navigation stack
  void logoutConfirmDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text("Go back"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Log out"),
              onPressed: () {
                // logout() handles our navigator pops
                HttpService().logOut(context);
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[_moreOptions(context)],
      ),
      body: Container(
        child: _navTabs.elementAt(_selectedNavTab),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.subject),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Inventory',
          )
        ],
        currentIndex: _selectedNavTab,
        onTap: _navTo,
      ),
    );
  }

  // use a menu because eventually we want to add a global app settings option
  Widget _moreOptions(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Log out'),
          value: 1,
        ),
      ],
      onCanceled: () {},
      onSelected: (value) {
        // picked log out
        if (value == 1) {
          logoutConfirmDialog(
              context, "Log out?", "Are you sure you want to log out?");
        }
      },
      icon: Icon(Icons.more_vert, size: 25),
    );
  }
}
