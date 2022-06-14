import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/http/HttpService.dart';
import 'package:tech_companion_mobile/views/Home.dart';

// we're not changing widgets on this page, so state is not needed
class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final HttpService httpService = new HttpService();

  // our popup to display an error
  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  // helper function to build the two input boxes
  Widget _buildInputBox(
      TextEditingController controller, String hintText, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: <Widget>[
          // expanded so we maintain ratio between the widgets in the column
          // 1:3 height ratio between the two widgets
          // first expanded contains our welcome message
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  Text(
                    "Welcome to",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                    ),
                  ),
                  Text(
                    "TechCompanion!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // this contains the white widget which holds our inputs
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              // call on the function to return this widget
              child: _loginForm(context),
            ),
          ),
        ],
      ),
    );
  }

  // this function returns our login inputs
  Widget _loginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 45, 15, 25),
      child: Column(
        children: <Widget>[
          _buildInputBox(_usernameController, 'Username', false),
          SizedBox(
            height: 35,
          ),
          _buildInputBox(_passwordController, 'Password', true),
          SizedBox(
            height: 35,
          ),
          FlatButton(
            // we'll put our function in line since it's relatively small
            onPressed: () async {
              var username = _usernameController.text;
              var password = _passwordController.text;
              // attempt to log in, if successful the server will respond with our jwt
              var jwt = await httpService.attemptLogIn(username, password);
              if (jwt != null) {
                // store our jwt in flutter secure storage
                httpService.storage.write(key: "jwt", value: jwt);
                // reroute to main application widget
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        HomePage(title: 'TechCompanion', jwt: jwt),
                  ),
                );
              } else {
                displayDialog(context, "An Error Occurred",
                    "No account was found matching that username and password");
              }
            },
            child: Text(
              "Log In",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
