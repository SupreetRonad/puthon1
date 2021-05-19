import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Screens/Cook/orderCard.dart';
import 'package:puthon/Screens/User/homeScreen.dart';
import 'package:puthon/Shared/loadingScreen.dart';

class CookScreen extends StatefulWidget {
  @override
  _CookScreenState createState() => _CookScreenState();
}

class _CookScreenState extends State<CookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            .where("orderAccepted", isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
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
          } else {
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.only(
                  bottom: kFloatingActionButtonMargin + 60),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var order = snapshot.data.docs[index];
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .doc(HomeScreen.resId)
                      .collection(order['customerId'])
                      .doc(order['orderNo'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    } else {
                      return OrderCard(
                        order: snapshot.data,
                        customerId: order['customerId'],
                        orderNo: order['orderNo'],
                        timeStamp: order['timeStamp'],
                        cookOrder: true,
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
