import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Screens/Admin/editResInfo.dart';

import 'adminGenerateQR.dart';

class AboutBusiness extends StatefulWidget {
  @override
  _AboutBusinessState createState() => _AboutBusinessState();
}

class _AboutBusinessState extends State<AboutBusiness> {
  var resName, upi;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('admins')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitFadingCircle(
            color: Colors.black54,
            size: 20,
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text("Cannot fetch the details at the moment"),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  //color: Colors.white60,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width - 30,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Text(
                      snapshot.data!["resName"],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    displayInfo("Building info : ", snapshot.data["building"]),
                    SizedBox(
                      height: 5,
                    ),
                    displayInfo("Street : ", snapshot.data["street"]),
                    SizedBox(
                      height: 5,
                    ),
                    displayInfo(
                      "State : ",
                      snapshot.data["state"] + ', ' + snapshot.data["country"],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    displayInfo("Pincode : ", snapshot.data["pincode"]),
                  ],
                ),
              ),
              tileButton(
                head: 'Edit',
                subHead: 'Edit your business\' info.',
                icon: Icons.border_color,
                dialog: EditResInfo(),
              ),
              tileButton(
                head: 'QR Code',
                subHead: "Generate QR code for tables or bots.",
                icon: Icons.qr_code_scanner,
                dialog: AdminGenerateQR(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget displayInfo(String head, String value) => Row(
        children: [
          Text(
            head,
            style: TextStyle(fontSize: 13, color: Colors.black54
                //fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      );

  Widget tileButton({
    required String head,
    required String subHead,
    required IconData icon,
    required Widget dialog,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            backgroundColor: Colors.white60,
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => dialog,
            );
          },
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    head,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subHead,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
