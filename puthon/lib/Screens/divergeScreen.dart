import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/User/detailScreen.dart';
import 'package:puthon/shared/loadingScreen.dart';
import 'package:puthon/shared/pagesurf.dart';

import 'User/homeScreen.dart';

class DivergeScreen extends StatelessWidget {
  void readData(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (value) {
        if (value.exists) {
          if (value['register']) {
            replacePage(context, DetailScreen());
          } else {
            replacePage(context, HomeScreen());
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    readData(context);
    return LoadingScreen();
  }
}
