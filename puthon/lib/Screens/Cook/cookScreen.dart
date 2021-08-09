import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/Cook/activeOrders.dart';
import 'package:puthon/Shared/loadingScreen.dart';

import 'acceptedOrder.dart';

class CookScreen extends StatefulWidget {
  @override
  _CookScreenState createState() => _CookScreenState();
}

class _CookScreenState extends State<CookScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return const Center(
            child: Text(
              "No Active Orders...",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          );
        }
        return snapshot.data['cooking']
            ? AcceptedOrder(snapshot.data['orderNo'])
            : ActiveOrders();
      },
    );
  }
}
