import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multifactor_auth/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');


  bool oEmailVerified = false ;
  bool oPhoneVerified = false ;

  Future<void> userSetup(String displayName,String mail,String phone) async {

    String uid = FirebaseAuth.instance.currentUser.uid.toString();

    String email = _auth.currentUser.email;
    return await
    users.doc(uid)
        .set({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phone': phone,
      'otp_email_verified': oEmailVerified,
      'otp_phone_verified': oPhoneVerified,
    });
  }


  // create user obj based on firebase user
  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Users> get user {
    return _auth.authStateChanges()
    //.map((User user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}