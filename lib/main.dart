import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multifactor_auth/models/user.dart';
import 'package:multifactor_auth/route/wrapper.dart';
import 'package:multifactor_auth/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );

  }
}
