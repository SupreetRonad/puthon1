import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
                    scanned = 2;
                    HomeScreen.resId = cameraScanResult.split("/*/")[1];
                    HomeScreen.table = cameraScanResult.split("/*/")[0];
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser.uid)
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
          // QrImage(
          //   data: 'Hello1234 asdhbf asdbf asdfj asdkjfh asdjf',
          //   version: QrVersions.auto,
          //   size: 320,
          //   gapless: false,
          //   eyeStyle: const QrEyeStyle(
          //     eyeShape: QrEyeShape.circle,
          //     color: Color(0xff128760),
          //   ),
          //   dataModuleStyle: const QrDataModuleStyle(
          //     dataModuleShape: QrDataModuleShape.circle,
          //     color: Color(0xff1a5441),
          //   ),
          //   embeddedImage: AssetImage('assets/images/cardbg2.jpg'),
          //   embeddedImageStyle: QrEmbeddedImageStyle(
          //     size: Size(80, 80),
          //   ),
          // ),
        ],
      ),
    );
  }
}
