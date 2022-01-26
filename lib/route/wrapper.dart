import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multifactor_auth/Screens/Authenticate_screen.dart';
import 'package:multifactor_auth/Screens/otp_email_screen.dart';
import 'package:multifactor_auth/Screens/home_page/TabLayoutMy.dart';
import 'package:multifactor_auth/Screens/otp_phone_screen.dart';
import 'package:multifactor_auth/models/user.dart';
import 'package:multifactor_auth/shared/loading.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {



  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  initState(){
    super.initState();
  }

  bool loading = false;


  @override
  Widget build(BuildContext context) {

    String email,phone,displayName;
    bool oEmailVerified = false ;
    bool oPhoneVerified = false ;

    final CollectionReference users = FirebaseFirestore.instance.collection('Users');

    final user = Provider.of<Users>(context);



    if (user == null){
      return AuthScreen();
    }
    else{
      String uid = user.uid;
      return FutureBuilder(
          future:  users
              .where('uid', isEqualTo: uid)
              .get()
              .then((value) {
            print(value.docs.first.data());
            oEmailVerified = value.docs.first.data()['otp_email_verified'];
            oPhoneVerified = value.docs.first.data()['otp_phone_verified'];
            email = value.docs.first.data()['email'];
            phone= value.docs.first.data()['phone'];
            displayName = value.docs.first.data()['displayName'];
          } ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:  return  Scaffold(body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  strokeWidth: 5,
                ),
              ));
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else{
                  //return Text('Result: ${snapshot.data}');
                  if(oEmailVerified == true){
                    return OTPScreen(phone: phone,);
                  }
                  if(oPhoneVerified == true){
                    return TabLayoutMy(email: email,displayName: displayName,);
                  }
                  else{
                    return Otp(email: email);
                  }
                }
            }
          }
      );
    }
  }
}
