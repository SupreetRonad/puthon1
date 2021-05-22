import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Shared/orderCard.dart';
import 'package:qrscans/qrscan.dart' as scanner;

class AcceptedOrder extends StatefulWidget {
  final orderNo;
  AcceptedOrder(this.orderNo);

  @override
  _AcceptedOrderState createState() => _AcceptedOrderState();
}

class _AcceptedOrderState extends State<AcceptedOrder> {
  String cameraScanResult;
  var botNo;
  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderNo.substring(0, 28))
          .collection(widget.orderNo.substring(0, 28))
          .doc(widget.orderNo)
          .snapshots(),
      builder: (context, snapshot) {
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
        return Column(
          children: [
            OrderCard(
              order: snapshot.data,
              customerId: widget.orderNo.substring(0, 28),
              orderNo: widget.orderNo,
              cookOrder: false,
            ),
            SizedBox(
              height: 20,
            ),
            Text(botNo != null ? botNo.toString() : "Scan please"),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .doc(widget.orderNo.substring(0, 28))
                    .snapshots(),
                builder: (context, snapshot) {
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
                  return ElevatedButton(
                    child: Text("Assign a Bot"),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Color.fromRGBO(213, 165, 101, 1),
                      elevation: 10,
                      primary: Color.fromRGBO(213, 165, 101, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      cameraScanResult = await scanner.scan();
                      setState(() {
                        botNo = cameraScanResult.split("/*/")[0];
                      });
                      
                      databaseRef.child(snapshot.data['resId']).child(botNo.toString()).set({
                        'tableNo': snapshot.data['table'],
                        'delivered': false,
                      });
                    },
                  );
                }),
          ],
        );
      },
    );
  }
}
