import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/User/detailScreen.dart';
import 'package:puthon/shared/loadingScreen.dart';

import 'User/homeScreen.dart';

class DivergeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }
        scanned = snapshot.data['scanned'];
        return snapshot.data['register'] ? DetailScreen() : HomeScreen();
      },
    );
  }
}
