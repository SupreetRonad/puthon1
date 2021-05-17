import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/User/HomeDrawer.dart';
import 'package:puthon/shared/cartButton.dart';
import 'package:qrscans/qrscan.dart' as scanner;

var name = "Name",
    email = "email@email.com",
    dob = "00/00/0000",
    phone = "1081081081",
    gender = 1;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String cameraScanResult, qrContent;
Uint8List result = Uint8List(0);

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      floatingActionButton: CartButton(),
      endDrawer: HomeDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("PUTHON"),
      ),
      body: Container(
        //color: Colors.amber,
        width: double.infinity,
        child: Column(
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
                setState(() {});
              },
              child: Text("Scan"),
            ),
            SizedBox(
              height: 10,
            ),
            Text(cameraScanResult == null ?  "Please scan QR code first" : cameraScanResult.split("/*/")[0]),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
