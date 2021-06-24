import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/Admin/adminScreen.dart';
import 'Screens/User/businessRegisterScreen.dart';
import 'Screens/User/ordersHistory.dart';
import 'Screens/authScreen.dart';
import 'Screens/Cook/cookScreen.dart';
import 'Screens/User/detailScreen.dart';
import 'Screens/divergeScreen.dart';
import 'Screens/User/homeScreen.dart';
import 'shared/loadingScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          title: 'Puthon',
          theme: ThemeData(
            errorColor: Color(0xffd32f2f),
            primarySwatch: Colors.lightGreen,
          ),
          routes: {
            '/loadingScreen': (context) => LoadingScreen(),
            '/authScreen': (context) => AuthScreen(),
            '/detailScreen': (context) => DetailScreen(),
            '/homeScreen': (context) => HomeScreen(),
            '/businessRegisterScreen': (context) => RegisterBusiness(),
            '/adminScreen': (context) => AdminScreen(),
            '/cookScreen': (context) => CookScreen(),
            '/ordersHistory': (context) => OrdersHistory(),
          },
          home: snapshot.connectionState != ConnectionState.done
              ? LoadingScreen()
              : FirebaseAuth.instance.currentUser != null
                  ? DivergeScreen()
                  : AuthScreen(),
        );
      },
    );
  }
}
