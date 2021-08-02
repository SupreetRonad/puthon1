import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/User/homeScreen.dart';

import 'loading.dart';

class DurationConfirm extends StatefulWidget {
  final order, customerId, timeStamp, orderNo;
  const DurationConfirm(
      {this.order, this.customerId, this.timeStamp, this.orderNo});

  @override
  _DurationConfirmState createState() => _DurationConfirmState();
}

var dur = ["15", "30", "45"];

class _DurationConfirmState extends State<DurationConfirm> {
  var duration = 1;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10.0,
        sigmaY: 10.0,
      ),
      child: Container(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 180,
            width: (MediaQuery.of(context).size.width - 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Accept order ?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 20,
                  ),
                ),
                Divider(),
                Text(
                  "Please select cooking duration.",
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          duration = 1;
                        });
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.black54,
                        backgroundColor: duration == 1
                            ? Colors.yellow
                            : Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text("15"),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          duration = 2;
                        });
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.black54,
                        backgroundColor: duration == 2
                            ? Colors.yellow
                            : Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text("30"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          duration = 3;
                        });
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.black54,
                        backgroundColor: duration == 3
                            ? Colors.yellow
                            : Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text("45"),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).size.width - 80)/2,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Go Back"),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.yellow, Colors.amber]),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20))),
                      width: (MediaQuery.of(context).size.width - 80)/2,
                      child: TextButton(
                        onPressed: () async {
                          Loading(context);

                          var hour = DateTime.now().hour > 12
                              ? DateTime.now().hour - 12
                              : DateTime.now().hour;
                          var hour1 = hour < 10 ? "0${hour}" : "${hour}";
                          var minute = DateTime.now().minute < 10
                              ? "0${DateTime.now().minute}"
                              : "${DateTime.now().minute}";
                          var hh = DateTime.now().hour > 12 ? "pm" : "am";
                          await FirebaseFirestore.instance
                              .collection('admins')
                              .doc(HomeScreen.resId)
                              .collection('activeOrders')
                              .doc(widget.timeStamp)
                              .update({
                            "flag": 1,
                          });
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(widget.customerId)
                              .collection(widget.customerId)
                              .doc(widget.orderNo)
                              .update({
                            "flag": 1,
                            "duration": dur[duration - 1],
                            "acceptedTime": "${hour1} : ${minute} ${hh}",
                          });
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "cooking": true,
                            "orderNo": widget.orderNo,
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
