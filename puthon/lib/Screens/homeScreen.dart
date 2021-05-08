import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: TextButton(
          onPressed: (){
            FirebaseAuth.instance.signOut();
          },
          child: Text("Home Screen"),
        ),
      ),
    );
  }
}
