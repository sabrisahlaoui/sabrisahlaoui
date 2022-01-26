import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multifactor_auth/Screens/Login.dart';
import 'package:multifactor_auth/Screens/home.dart';
import 'package:multifactor_auth/Screens/home_page/TabLayoutMy.dart';
import 'package:multifactor_auth/models/user.dart';
import 'package:multifactor_auth/services/auth.dart';
import 'package:multifactor_auth/shared/loading.dart';


class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  bool loading = false;

  // text field state
  String name = '';
  String lastName = '';
  String email = '';
  String phoneNumber ;

  String password = '';
  String confirmpassword = '';

  @override
  Widget build(BuildContext context) {

    final mq = MediaQuery.of(context);

    final usernameField = TextFormField(

      validator: (val) => val.isEmpty ? 'Enter a username' : null,
      onChanged: (val) {
        setState(() => name = val);
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
        hintText: "John Doe",
        labelText: "Username",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final phoneField = TextFormField(

      validator: (val) => val.isEmpty ? 'Enter a phoneNumber' : null,
      onChanged: (val) {
        setState(() => phoneNumber = val );
      },
      keyboardType: TextInputType.phone,
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
        hintText: "phoneNumber",
        labelText: "phoneNumber",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

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
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        hintText: "something@example.com",
        labelText: "email",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final passwordField = TextFormField(

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
    );

    final repasswordField = TextFormField(

      obscureText: true,

      validator: (String value){
        if(value.isEmpty)
        {
          return 'Please re-enter password';
        }

        if(password != confirmpassword){
          return "Password does not match";
        }

        return null;
      },

      onChanged: (val) {
        setState(() => confirmpassword = val);
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
        labelText: "Re-enter Password",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final fields = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          usernameField,
          emailField,
          phoneField,
          passwordField,
          repasswordField,
          Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          )
        ],
      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
          minWidth: mq.size.width / 1.2,
          padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Text(
            "Register",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),


          onPressed: () async {
            if(_formKey.currentState.validate()){

              dynamic result = await _auth.registerWithEmailAndPassword(email, password);


              AuthService().userSetup(name,email,phoneNumber);

              if(result == null) {
              setState(() {
              loading = false;
              error = 'Please supply a valid email';
              });
              }
              else{
                setState(() => loading = true);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => TabLayoutMy(email: email,displayName: name,)),
                        (route) => false);
              }
            }
          }
      ),
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        registerButton,
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "Are you a member?",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Colors.white,
              ),
            ),
            MaterialButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignIn())),/*widget.toggleView(),*/
              child: Text(
                "Login",
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
    return loading ? Loading() :  Scaffold(
      backgroundColor: Colors.purple,
      body:Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Container(
            height: mq.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                fields,
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
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
