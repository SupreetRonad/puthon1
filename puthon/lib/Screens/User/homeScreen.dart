import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Screens/User/bottomMenu.dart';
import 'package:puthon/Screens/User/homeDrawer.dart';
import 'package:puthon/Screens/User/qrScanning.dart';
import 'package:puthon/Shared/loadingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cartButton.dart';

var name = "Name",
    email = "email@email.com",
    dob = "00/00/0000",
    phone = "1081081081",
    gender = 1;

class HomeScreen extends StatefulWidget {
  static List<String> list = [];
  static var resId, table, resName, total;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var scanned = 0;

late String cameraScanResult, qrContent;
Uint8List result = Uint8List(0);

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late SharedPreferences prefs;

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
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/bg3.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 0,
          sigmaY: 0,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context,AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return const Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }
            return Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: snapshot.data['scanned'] == 1
                  ? null
                  : FloatingActionButton(
                      backgroundColor: Colors.deepOrange[300]!.withOpacity(.9),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return CartButton(refresh: refresh);
                          },
                        );
                      },
                      child: const Icon(
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
              body: snapshot.data['scanned'] == 0
                  ? const SpinKitFadingCircle(color: Colors.black, size: 20)
                  : snapshot.data['scanned'] == 1
                      ? QrScanning()
                      : BottomMenu(
                          prefs: prefs,
                          refresh: refresh,
                        ),
            );
          },
        ),
      ),
    );
  }
}
