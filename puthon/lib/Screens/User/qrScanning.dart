import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscans/qrscan.dart' as scanner;

import 'homeScreen.dart';

class QrScanning extends StatefulWidget {
  @override
  _QrScanningState createState() => _QrScanningState();
}

class _QrScanningState extends State<QrScanning> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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

              if (cameraScanResult.split("/*/").length == 2) {
                await FirebaseFirestore.instance
                    .collection('admins')
                    .doc(cameraScanResult.split("/*/")[1])
                    .get()
                    .then((value) {
                  if (value.exists) {
                    HomeScreen.resName = value['resName'];
                    HomeScreen.resId = cameraScanResult.split("/*/")[1];
                    HomeScreen.table = cameraScanResult.split("/*/")[0];
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .update({
                      'scanned': 2,
                    });
                    FirebaseFirestore.instance
                        .collection('orders')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .set({
                      'resId': HomeScreen.resId,
                      'table': HomeScreen.table,
                      'resName': HomeScreen.resName,
                      'ordered': false,
                      'total': 0,
                      'timeEntered': DateTime.now(),
                    });
                    FirebaseFirestore.instance
                        .collection('admins')
                        .doc(HomeScreen.resId)
                        .collection('tables')
                        .doc(HomeScreen.table)
                        .set({
                      'table': HomeScreen.table,
                      'customerId': FirebaseAuth.instance.currentUser.uid,
                      'timeEntered': DateTime.now(),
                    });
                    scanned = 2;
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
    );
  }
}
