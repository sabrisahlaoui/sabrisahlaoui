import 'package:flutter/material.dart';
import 'package:multifactor_auth/Screens/Login.dart';
import 'package:multifactor_auth/Screens/Register.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => new _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // we will give media query height
          // double.infinity make it big as my parent allows
          // while MediaQuery make it big as per the screen

          width: double.infinity,
          height: MediaQuery
              .of(context)
              .size
              .height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            // even space distribution
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("welcome to MFA app",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),)
                ],
              ),
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 3.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/welcome.png")
                    )
                ),
              ),
              Column(
                children: <Widget>[
                  // the login button
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    // defining the shape
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                  ),
                  // creating the signup button
                  SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Register()));
                    },
                    color: /*Color(0xff0095FF)*/Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}