import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Shared/itemCard.dart';
import 'package:puthon/Screens/User/HomeDrawer.dart';
import 'package:puthon/Shared/loadingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cartButton.dart';
import 'package:qrscans/qrscan.dart' as scanner;

var name = "Name",
    email = "email@email.com",
    dob = "00/00/0000",
    phone = "1081081081",
    gender = 1;

class HomeScreen extends StatefulWidget {
  static List<String> list = [];
  static var resId, table;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var scanned = 0;

String cameraScanResult, qrContent;
Uint8List result = Uint8List(0);

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;

  SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getStringList("orderList") == null) {
        prefs.setStringList("orderList", []);
      }
      HomeScreen.list = prefs.getStringList('orderList') ?? [];
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      if (value.exists) {
        setState(() {
          scanned = value['scanned'];
          HomeScreen.resId = value['resId'];
          HomeScreen.table = value['table'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[300],
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            builder: (BuildContext context) {
              return CartButton(refresh: refresh);
            },
          );
        },
        child: Icon(
          Icons.shopping_cart,
          size: 20,
        ),
      ),
      endDrawer: HomeDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("PUTHON"),
      ),
      body: Container(
        width: double.infinity,
        child: scanned == 0 ?  LoadingScreen() : scanned == 2 
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admins')
                    .doc(HomeScreen.resId)
                    .collection('menu')
                    .orderBy('category')
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
                              "Table. " + HomeScreen.table,
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () async {
                                scanned = 1;
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .update({
                                  'scanned': 1,
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
                          height: MediaQuery.of(context).size.height - 141,
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              var item = snapshot.data.docs[index];
                              return !item['inMenu'] ? SizedBox() : Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: ItemCard(
                                  item: item,
                                  order: true,
                                ),
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
                            scanned = 2;
                            HomeScreen.resId = cameraScanResult.split("/*/")[1];
                            HomeScreen.table = cameraScanResult.split("/*/")[0];
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .update({
                              'scanned': 2,
                              'resId': HomeScreen.resId,
                              'table': HomeScreen.table,
                            });
                          }
                        });
                      } else {
                        scanned = 1;
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
