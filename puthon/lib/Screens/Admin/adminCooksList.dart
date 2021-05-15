import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/shared/loadingScreen.dart';

class AdminCooksList extends StatefulWidget {
  @override
  _AdminCooksListState createState() => _AdminCooksListState();
}

class _AdminCooksListState extends State<AdminCooksList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
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
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height:
                                MediaQuery.of(context).size.height * .6 + 80,
                            width: MediaQuery.of(context).size.width * .8,
                            child: Column(
                              children: [
                                Text(
                                  "Cook's Details...",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('cooks')
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .collection('details')
                                        .doc();
                                  },
                                  child: Text(
                                    "Add Cook",
                                    style: TextStyle(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.add),
            label: Text(
              "Add Cook",
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('cooks')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection('details')
                    .snapshots(),
                builder: (context, snapshot) {
                  // var info = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingScreen();
                  }
                  if (snapshot.hasData) {
                    return Text(
                      "Please Add cooks...",
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return Container(
                      child: Text("Cooks here ..."),
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }
}
