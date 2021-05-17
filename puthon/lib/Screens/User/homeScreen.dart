import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expanding_button/expanding_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/Admin/itemCard.dart';
import 'package:puthon/Screens/User/HomeDrawer.dart';
import 'package:puthon/Shared/loadingScreen.dart';
import 'cartButton.dart';
import 'package:qrscans/qrscan.dart' as scanner;

var name = "Name",
    email = "email@email.com",
    dob = "00/00/0000",
    phone = "1081081081",
    gender = 1;

var resId, table;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool scanned = false;

String cameraScanResult, qrContent;
Uint8List result = Uint8List(0);

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      if (value.exists) {
        setState(() {
          scanned = value['scanned'];
          resId = value['resId'];
          table = value['table'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandingButton(
        tag: "Hello",
        child: Text('This can be any widget'),
        // onTap: () {
        //   print('This can be any voidcallback which is called on tapping');
        // },
      ),
      endDrawer: HomeDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("PUTHON"),
      ),
      body: Container(
        //color: Colors.amber,
        width: double.infinity,
        child: scanned
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admins')
                    .doc(resId)
                    .collection('menu')
                    .orderBy('itemName')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingScreen();
                  }
                  if (!snapshot.hasData) {
                    return Text(
                      "Please Add Items...",
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Table. " + table,
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: Colors.white,
                                //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () async {
                                scanned = false;
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .update({
                                  'scanned': false,
                                  'resId': null,
                                  'table': null,
                                });
                                setState(() {});
                              },
                              child: Text("Pay & Exit"),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        Container(
                          //color: Colors.blue,
                          height: MediaQuery.of(context).size.height - 141,
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              var item = snapshot.data.docs[index];
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: ItemCard(item: item, order: true),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      primary: Colors.white,
                      //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      cameraScanResult = await scanner.scan();
                      print(cameraScanResult);

                      if (cameraScanResult.split("/*/").length == 2) {
                        await FirebaseFirestore.instance
                            .collection('admins')
                            .doc(cameraScanResult.split("/*/")[1])
                            .get()
                            .then((value) {
                          if (value.exists) {
                            scanned = true;
                            resId = cameraScanResult.split("/*/")[1];
                            table = cameraScanResult.split("/*/")[0];
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .update({
                              'scanned': true,
                              'resId': resId,
                              'table': table,
                            });
                          }
                        });
                      } else {
                        scanned = false;
                      }
                      setState(() {});
                    },
                    child: Text("Scan"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(cameraScanResult == null
                      ? "Please scan QR code first"
                      : cameraScanResult.split("/*/")[0]),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
      ),
    );
  }
}
