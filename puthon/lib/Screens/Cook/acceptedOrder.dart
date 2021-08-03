import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Screens/Cook/cookTimer.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AcceptedOrder extends StatefulWidget {
  final orderNo;
  AcceptedOrder(this.orderNo);

  @override
  _AcceptedOrderState createState() => _AcceptedOrderState();
}

class _AcceptedOrderState extends State<AcceptedOrder> {
  late String cameraScanResult;
  var botNo;
  final databaseRef = FirebaseDatabase.instance.reference();

  void assignBot(AsyncSnapshot snapshot) async {
    cameraScanResult = await scanner.scan() ?? '';

    setState(() {
      botNo = cameraScanResult.split("/*/")[0];
    });

    // Loading(context);

    databaseRef.child(snapshot.data!['resId']).child(botNo.toString()).set({
      'tableNo': int.parse(snapshot.data['table']),
      'delivered': false,
    });

    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderNo.substring(0, 28))
        .collection(widget.orderNo.substring(0, 28))
        .doc(widget.orderNo)
        .update({
      'flag': 2,
      'bot': int.parse(botNo),
    });

    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderNo.substring(0, 28))
        .update({
      'ordered': false,
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'cooking': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/oranges3.jpg"), fit: BoxFit.cover),
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
                        textStyle: TextStyle(color: Colors.orange[400]),
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .doc(widget.orderNo.substring(0, 28))
                .collection(widget.orderNo.substring(0, 28))
                .doc(widget.orderNo)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading"),
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
              var order = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 35,
                        child: Image.asset("assets/images/cooking.png"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Cooking...",
                        style: GoogleFonts.righteous(
                          color: Colors.black87,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Table " + order!['tableNo'],
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Ordered at " + order['time'],
                        style: GoogleFonts.raleway(
                          color: Colors.black87.withOpacity(.7),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  CookTimer(
                    time: order['acceptedTime'],
                    duration: int.parse(order['duration']),
                  ),
                  displayOrder(order),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Note : Once you are done, please scan the QR code on bot after placing the order on it.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('orders')
                          .doc(widget.orderNo.substring(0, 28))
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Text("Loading"),
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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              child: Row(
                                children: [
                                  Text("Assign a Bot  "),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  )
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.white54,
                                  elevation: 5,
                                  primary: Colors.white70,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(20)),
                              onPressed: () async {
                                assignBot(snapshot);
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        );
                      }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget displayOrder(var order) => Container(
        height: MediaQuery.of(context).size.height * .4,
        child: Scrollbar(
          child: SingleChildScrollView(
            //reverse: true,
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              for (var item in order['orderList'].keys)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.radio_button_checked,
                        color: order['orderList'][item][1]
                            ? Colors.green[300]
                            : Colors.red[300],
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          item,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "x " + order['orderList'][item][0].toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
            ]),
          ),
        ),
      );
}
