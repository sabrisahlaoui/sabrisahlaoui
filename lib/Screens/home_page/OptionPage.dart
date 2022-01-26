import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multifactor_auth/Screens/Authenticate_screen.dart';
import 'package:multifactor_auth/services/auth.dart';


class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  final AuthService _auth = AuthService();

  final CollectionReference user = FirebaseFirestore.instance.collection('Users');

  String uid = FirebaseAuth.instance.currentUser.uid.toString();


  bool oPhoneVerified = false ;


  Future<void> updateUser() {
    return user
        .doc(uid)
        .update({
      'otp_phone_verified': oPhoneVerified,
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

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
            icon: Icon(Icons.person,color: Colors.white),
            label: Text('logout',style: TextStyle(color: Colors.white)),
            onPressed: () async {
              updateUser();
              await _auth.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthScreen()),
                      (route) => false);
            },
          )
        ],
      ),
    );
  }
}