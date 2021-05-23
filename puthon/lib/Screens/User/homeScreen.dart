import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Screens/User/bottomMenu.dart';
import 'package:puthon/Screens/User/homeDrawer.dart';
import 'package:puthon/Screens/User/qrScanning.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cartButton.dart';

var name = "Name",
    email = "email@email.com",
    dob = "00/00/0000",
    phone = "1081081081",
    gender = 1;

class HomeScreen extends StatefulWidget {
  static List<String> list = [];
  static var resId, table, resName;
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
      if (prefs.getInt("orderNo") == null) {
        prefs.setInt("orderNo", 0);
      }
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
        });
      }
    });
    // TODO: need to change here
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/veg1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: scanned == 1 ? null : FloatingActionButton(
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
          body: scanned == 0
              ? SpinKitWave(color: Colors.black, size: 20)
              : scanned == 1
                  ? QrScanning()
                  : BottomMenu(
                      prefs: prefs,
                      refresh: refresh,
                    ),
        ),
      ),
    );
  }
}
