import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/User/homeScreen.dart';
import 'package:puthon/Shared/confirmBox.dart';
import 'package:puthon/Shared/durationConfirm.dart';

class OrderCard extends StatefulWidget {
  final order, customerId, orderNo, timeStamp;
  OrderCard({this.order, this.customerId, this.orderNo, this.timeStamp});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool loading = false;
  var duration = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: widget.order["orderList"].length * 24.0 + 130,
      child: Card(
        elevation: 18,
        shadowColor: Colors.white38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Table.  ",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  widget.order['tableNo'].toString(),
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  widget.order['time'],
                  style: TextStyle(
                    color: Colors.red[300],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            for (var item in widget.order['orderList'].keys)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.radio_button_checked,
                      color: widget.order['orderList'][item][1]
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
                      ),
                    ),
                    Spacer(),
                    Text("x " + widget.order['orderList'][item][0].toString()),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.red[400],
                      elevation: 0,
                      primary: Colors.red[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmBox(
                            b1: "Go Back",
                            b2: "Decline",
                            height: 150,
                            color: Colors.red[300],
                            message: Text("Do you want to cancel the order ?"),
                            function: () async {
                              Navigator.pop(context);
                              await FirebaseFirestore.instance
                                  .collection('admins')
                                  .doc(HomeScreen.resId)
                                  .collection('activeOrders')
                                  .doc(widget.timeStamp)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(HomeScreen.resId)
                                  .collection(widget.customerId)
                                  .doc(widget.orderNo)
                                  .delete();
                            },
                          );
                        },
                      );
                    },
                    child: Text("Decline"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.green[400],
                      elevation: 0,
                      primary: Colors.green[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DurationConfirm(
                            order: widget.order,
                            timeStamp: widget.timeStamp,
                            orderNo: widget.orderNo,
                            customerId: widget.customerId,
                          );
                        },
                      );
                    },
                    child: Text("Accept"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
