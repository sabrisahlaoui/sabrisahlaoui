import 'package:flutter/material.dart';
import 'package:multifactor_auth/Screens/Authenticate_screen.dart';
import 'package:multifactor_auth/Screens/Login.dart';
import 'package:multifactor_auth/Screens/authenticate.dart';
import 'package:multifactor_auth/services/auth.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
          title: Text('MFA App'),
          backgroundColor: Colors.purple[400],
          elevation: 0.0,
          actions: <Widget>[
      TextButton.icon(
      icon: Icon(Icons.person),
      label: Text('logout'),
      onPressed: () async {
        await _auth.signOut();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      },
    )
          ],
      ),
    );
  }
}
