import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puthondev/requestScreen.dart';

import 'homeScreen.dart';
import 'loadingScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Puthon Dev',
          theme: ThemeData(
            errorColor: Color(0xffd32f2f),
            primarySwatch: Colors.lightGreen,
          ),
          home: snapshot.connectionState != ConnectionState.done
              ? LoadingScreen()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return LoadingScreen();
                    }
                    if (userSnapshot.data != null) {
                      return RequestScreen();
                    }
                    return HomeScreen();
                  },
                ),
        );
      },
    );
  }
}
