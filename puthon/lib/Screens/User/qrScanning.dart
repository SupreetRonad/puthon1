import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:puthon/Screens/User/paymentGateway.dart';
import 'package:puthon/Utils/infoProvider.dart';
import 'package:puthon/Utils/requestPermission.dart';
import 'package:puthon/shared/showMsg.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'homeScreen.dart';

class QrScanning extends StatefulWidget {
  @override
  _QrScanningState createState() => _QrScanningState();
}

class _QrScanningState extends State<QrScanning> {
  void scanQR() async {
    log("entered");
    await checkPermission();
    try {
      cameraScanResult = await scanner.scan();
    } catch (e) {
      log(e.toString());
      showSnack(context, 'Invalid QR');
    }

    log(cameraScanResult ?? 'Null');

    if (cameraScanResult!.split("/*/").length == 2) {
      log('Check');
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(cameraScanResult!.split("/*/")[1])
          .get()
          .then((value) {
        if (value.exists) {
          
          EnteredRes.resName = value['resName'];
          EnteredRes.resId = cameraScanResult!.split("/*/")[1];
          EnteredRes.table = cameraScanResult!.split("/*/")[0];

          FirebaseFirestore.instance.collection('users').doc(Info.uid).update({
            'scanned': 2,
          });
          FirebaseFirestore.instance.collection('orders').doc(Info.uid).set({
            'resId': EnteredRes.resId,
            'table': EnteredRes.table,
            'resName': EnteredRes.resName,
            'ordered': false,
            'total': 0,
            'timeEntered': DateTime.now(),
          });
          FirebaseFirestore.instance
              .collection('admins')
              .doc(EnteredRes.resId)
              .collection('tables')
              .doc(EnteredRes.table)
              .set({
            'table': EnteredRes.table,
            'customerId': Info.uid,
            'timeEntered': DateTime.now(),
          });
          scanned = 2;
          Info.scanned = 2;
        }
      });
    } else {
      scanned = 1;
      Info.scanned = 1;
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
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  "Hey, Welcome",
                  style: GoogleFonts.josefinSans(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Your virtual waiter is at your service..",
              style: GoogleFonts.josefinSans(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
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
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: false
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => PaymentScreen(
                                upi: 'supreet.ronad@axisbank',
                                amount: 10,
                              ),
                            ),
                          );
                        }
                      : scanQR,
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
