import 'package:flutter/material.dart';

class LandingView extends StatefulWidget {
  // variables

  LandingView({
    Key key,
  }) : super(key: key);

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  // variables

  @override
  void initState() {
    super.initState();
    // functions
  }

  @override
  void dispose() {
    // functions
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
            '''Welcome!\n\nUse the navigation buttons below to move about the app.
            \nMore stuff will come with time.'''),
      ),
    );
  }
}
