import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Utils/infoProvider.dart';
import 'package:puthon/shared/orderCard.dart';

class ActiveOrders extends StatelessWidget {
  const ActiveOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg2.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: title(),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('admins')
              .doc(Info.resId)
              .collection('activeOrders')
              .where("flag", isEqualTo: 0)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SpinKitFadingCircle(
                size: 20,
                color: Colors.black54,
              );
            }
            if (!snapshot.hasData ||
                snapshot.hasError ||
                (snapshot.data.docs.length == 0)) {
              log('2nd stream  --  ' + Info.resId);
              return const Center(
                child: Text(
                  "No Active Orders...",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: kFloatingActionButtonMargin + 60,
                ),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot order1 = snapshot.data.docs[index];
                  return displayOrder(order1);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget displayOrder(QueryDocumentSnapshot order) => StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(order['customerId'])
            .collection(order['customerId'])
            .doc(order['orderNo'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(
              child: Text(
                "No Active Orders...",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
          return OrderCard(
            order: snapshot.data,
            customerId: order['customerId'],
            orderNo: order['orderNo'],
            timeStamp: order['timeStamp'],
            cookOrder: true,
            acceptedOrder: false,
          );
        },
      );

  Widget title() => Row(
        children: [
          const Spacer(),
          RichText(
            text: TextSpan(
              text: 'PUTHON ',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: "Cook",
                  style: GoogleFonts.dancingScript(
                    textStyle: const TextStyle(
                      color: Colors.amber,
                    ),
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
