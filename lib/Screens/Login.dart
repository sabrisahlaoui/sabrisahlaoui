import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multifactor_auth/Screens/Register.dart';
import 'package:multifactor_auth/services/auth.dart';
import 'package:multifactor_auth/shared/loading.dart';
import 'package:multifactor_auth/widgets/custom_alert_dialog.dart';

import 'otp_email_screen.dart';



class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');


  // text field state
  String email = '';
  String password = '';




  void sendOTP() async {
    EmailAuth.sessionName = "Test session";
    var res = await EmailAuth.sendOtp(receiverMail: email);
    if (res) {
      setState(() {
        loading = true;});
        print("otp sent");
        Fluttertoast.showToast(
            msg: "OTP has sent to your email.");

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Otp(email: email)));

       /* Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Otp(email: email,)),
                (route) => false);*/
      }
    else{
      print("We could not sent the otp");
      Fluttertoast.showToast(
          msg: "Could not sent the otp");
    }
  }



  User user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {

    final mq = MediaQuery.of(context);

    void showAlertDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController _emailControllerField =
            TextEditingController();
            return CustomAlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 2.3,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Text("Insert Reset Email:"),
                    TextField(

                      controller: _emailControllerField,

                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText: "something@example.com",
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.pink,
                        child: MaterialButton(
                          minWidth: mq.size.width / 3,
                          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 15.0),
                          child: Text(
                            "Send Reset Email",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            try {
                              FirebaseAuth.instance.sendPasswordResetEmail(
                                  email: _emailControllerField.text);
                              Navigator.of(context).pop();
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }


    final emailField = TextFormField(

      validator: (String val){
        if(val.isEmpty)
        {
          return 'Please Enter an email';
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(val)){
          return 'Please enter a valid Email';
        }
        return null;
      },
      onChanged: (val) {
        setState(() => email = val);
      },
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.white,
      ),

      cursorColor: Colors.white,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        hintText: "something@example.com",
        labelText: "Email",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );



    final passwordField = Column(
      children: <Widget>[
        TextFormField(
          obscureText: true,
          validator: (String val) {
            Pattern pattern =
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
            RegExp regex = new RegExp(pattern);

            if (val.isEmpty) {
              return 'Please enter password';
            } else {
              if (!regex.hasMatch(val))
                return 'Enter valid password';
              else
                return null;
            }
          },
          onChanged: (val) {
            setState(() => password = val);
          },

          style: TextStyle(
            color: Colors.white,
          ),

          cursorColor: Colors.white,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintText: "password",
            labelText: "Password",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(2.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MaterialButton(
                child: Text(
                  "Forgot Password",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  showAlertDialog(context);
                }),
          ],
        ),
      ],
    );

    final fields = Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          emailField,
          passwordField,
          Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          ),
        ],
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
          minWidth: mq.size.width / 1.2,
          padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              dynamic result = await _auth.signInWithEmailAndPassword(email, password);
              if (result == null) {
                setState(() {
                  loading = false;
                  error = 'Could not sign in with those credentials';
                });
              }
              else{
                sendOTP();
              }
            }
          }
      ),
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        loginButton,
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Not a member?",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Colors.white,
              ),
            ),
            MaterialButton(
              onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Register())),
              child: Text(
                "Sign Up",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.purple,
      body:Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(36),
            child: Container(
              height: mq.size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //logo,
                  fields,
                  Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: bottom,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}