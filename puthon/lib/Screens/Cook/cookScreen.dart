import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Shared/orderCard.dart';
import 'package:puthon/Screens/User/homeScreen.dart';
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
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: Text(
              "No Active Orders...",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        }
        return snapshot.data['cooking']
            ? AcceptedOrder(snapshot.data['orderNo'])
            : Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg2.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: Row(
                      children: [
                        Spacer(),
                        RichText(
                          text: TextSpan(
                            text: 'PUTHON ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: "Cook",
                                style: GoogleFonts.dancingScript(
                                  textStyle: TextStyle(color: Colors.amber),
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('admins')
                        .doc(HomeScreen.resId)
                        .collection('activeOrders')
                        .where("flag", isEqualTo: 0)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SpinKitWave(
                          size: 20,
                          color: Colors.black54,
                        );
                      }
                      if (!snapshot.hasData ||
                          snapshot.hasError ||
                          snapshot.data.docs.length == 0) {
                        return Center(
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
                              bottom: kFloatingActionButtonMargin + 60),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var order = snapshot.data.docs[index];
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(order['customerId'])
                                  .collection(order['customerId'])
                                  .doc(order['orderNo'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
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
                                  return Center(
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
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              );
      },
    );
  }
}
