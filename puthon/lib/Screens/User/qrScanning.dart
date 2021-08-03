import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'homeScreen.dart';

class QrScanning extends StatefulWidget {
  @override
  _QrScanningState createState() => _QrScanningState();
}

class _QrScanningState extends State<QrScanning> {
  void scanQR() async {
    cameraScanResult = await scanner.scan() ?? '';

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
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'scanned': 2,
          });
          FirebaseFirestore.instance
              .collection('orders')
              .doc(FirebaseAuth.instance.currentUser!.uid)
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
            'customerId': FirebaseAuth.instance.currentUser!.uid,
            'timeEntered': DateTime.now(),
          });
          scanned = 2;
        }
      });
    } else {
      scanned = 1;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  "Hey, Welcome",
                  style: GoogleFonts.josefinSans(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.black54),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your virtual waiter is at your service..",
              style: GoogleFonts.josefinSans(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            Expanded(
              child: Container(
                height: 200,
                child: Lottie.asset("assets/animations/scan_menu.json"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Scan QR code",
                  style: GoogleFonts.josefinSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black54),
                ),
                SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10)),
                  onPressed: scanQR,
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 30,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
