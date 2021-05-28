import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 250,
              width: 320,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Do you want to accept the order ?"),
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
                              ? Colors.amber[300]
                              : Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
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
                              ? Colors.amber[300]
                              : Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
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
                              ? Colors.amber[300]
                              : Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text("45"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Go Back"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 110,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
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
                                  .doc(FirebaseAuth.instance.currentUser.uid)
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
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
