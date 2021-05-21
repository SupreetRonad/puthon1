import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthondev/requestCard.dart';

class RequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puthon - Requests"),
        actions: [
          
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("requests").snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitWave(
              color: Colors.black,
              size: 20,
            );
          }
          if (!snapshot.hasData) {
            return Text("No Request Pending...");
          }
          var req = snapshot.data.docs;
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: req.length,
            itemBuilder: (BuildContext context, int index) {
              return RequestCard(req[index]);
            },
          );
        },
      ),
    );
  }
}
