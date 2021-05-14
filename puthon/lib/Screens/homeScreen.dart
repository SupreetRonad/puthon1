import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/HomeDrawer.dart';
import 'package:puthon/shared/cartButton.dart';

var name = "Name",
    email = "email@email.com",
    dob = "00/00/0000",
    phone = "1081081081",
    gender = 1;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CartButton(),
      endDrawer: HomeDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("PUTHON"),
      ),
      body: Center(),
    );
  }
}
