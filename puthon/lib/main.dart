import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:puthon/shared/top.dart';
import 'package:flutter/services.dart';
import 'Screens/authScreen.dart';
import 'Screens/detailScreen.dart';
import 'Screens/homeScreen.dart';
import 'Screens/loadingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        errorColor: Color(0xffd32f2f),
        primarySwatch: Colors.lightGreen,
      ),
      routes: {
        '/loadingScreen': (context) => LoadingScreen(),
        '/authScreen': (context) => AuthScreen(),
        '/detailScreen': (context) => DetailScreen(),
        '/homeScreen': (context) => HomeScreen(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          final user = userSnapshot.data;
          // print("user : " + user.toString());
          if(user != null) {
            Top.uid = user.uid;
          }
          if (user != null && Top.register) {
            return DetailScreen(uid: user.uid);
          } else if (user != null) {
            return HomeScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
