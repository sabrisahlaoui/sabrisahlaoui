import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp/flutter_otp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multifactor_auth/Screens/Authenticate_screen.dart';
import 'package:multifactor_auth/Screens/home.dart';
import 'package:multifactor_auth/Screens/otp_phone_screen.dart';
import 'package:multifactor_auth/services/auth.dart';
import 'package:multifactor_auth/shared/loading.dart';
import 'package:pinput/pin_put/pin_put.dart';


class Otp extends StatefulWidget {

  final String email;


  Otp({
    Key key,
    @required this.email,
  }) ;


  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {

  bool loading = false;

  String otp = '';

  FlutterOtp Otp = FlutterOtp();

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  void sendOTP() async {
    EmailAuth.sessionName = "Test session";
    var res = await EmailAuth.sendOtp(receiverMail: widget.email);
    if (res) {
      print("otp sent");
      Fluttertoast.showToast(
          msg: "OTP has sent to your email.");
    }
    else{
      print("We could not sent the otp");
      Fluttertoast.showToast(
          msg: "Could not sent the otp");
    }
  }

  void verifyOTP() {
    var res = EmailAuth.validate(receiverMail: widget.email,userOTP:otp);
    if(res){
      print("verification done");

        setState(() {
          loading = true; });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
                (route) => false);
    }
    else{
      setState(() => loading = false);
      Fluttertoast.showToast(
          msg: "Verify your otp code");
    }
  }
  String email;
  String displayName;
  String phone ;
  bool oEmailVerified = true ;

  final CollectionReference user = FirebaseFirestore.instance.collection('Users');

  String uid = FirebaseAuth.instance.currentUser.uid.toString();

  Future<void> updateUser() {
    return user
        .doc(uid)
        .update({
      'otp_email_verified': oEmailVerified,
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: FutureBuilder(
      future:  user
          .where('uid', isEqualTo: uid)
          .get()
          .then((value) {
      print(value.docs.first.data());
      phone = value.docs.first.data()['phone'];
      email = value.docs.first.data()['email'];
      displayName = value.docs.first.data()['displayName'];
      } ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 18,
                  ),
                   Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/gmail.png',
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Email Verification',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter OTP code sent to your email address ${widget.email}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        PinPut(
                          fieldsCount: 6,
                          textStyle: const TextStyle(
                              fontSize: 25.0, color: Colors.white),
                          eachFieldWidth: 30.0,
                          eachFieldHeight: 50.0,
                          focusNode: _pinPutFocusNode,
                          onChanged: (val) {
                            setState(() => otp = val);
                          },
                          controller: _pinPutController,
                          submittedFieldDecoration: pinPutDecoration,
                          selectedFieldDecoration: pinPutDecoration,
                          followingFieldDecoration: pinPutDecoration,
                          pinAnimationType: PinAnimationType.fade,
                          onSubmit: (pin) async {
                            try {
                              var res = EmailAuth.validate(
                                  receiverMail: widget.email, userOTP: pin);
                              if (res) {
                                updateUser();
                                Otp.generateOtp();
                                Otp.sendOtp(phone);

                                Fluttertoast.showToast(
                                    msg: "otp has sent to your mobile phone");

                                setState(() => loading = true);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => OTPScreen(phone: phone,)));
                              }
                              else {
                                setState(() => loading = false);
                                Fluttertoast.showToast(
                                    msg: "Verify your otp code");
                              }
                            } catch (e) {
                              FocusScope.of(context).unfocus();
                              _scaffoldkey.currentState
                                  .showSnackBar(
                                  SnackBar(content: Text('invalid OTP')));
                            }
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Didn't you receive any code?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  MaterialButton(
                    onPressed: () => sendOTP(),
                    child: Text(
                      "Resend New Code",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await AuthService().signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthScreen()),
                              (route) => false);
                    },
                    child: Text(
                      "Login Signup !",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}