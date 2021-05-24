import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/shared/loadingScreen.dart';

class OrdersHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("PUTHON"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('history')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: Text(
                "You haven't finished any orders...",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Text("llalalala");
            },
          );
        },
      ),
    );
  }
}
