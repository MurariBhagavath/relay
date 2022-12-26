import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relay/provider/google_sign_in.dart';
import 'package:relay/screens/authentication/login_screen.dart';
import 'package:relay/screens/dashboard/helper_screen.dart';
import 'package:relay/screens/dashboard/home_screen.dart';
import 'package:relay/server/mongoDB.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MDB.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Relay',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: 'FredokaOne',
          scaffoldBackgroundColor: Color.fromARGB(255, 240, 240, 240),
        ),
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error!"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return HelperScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
