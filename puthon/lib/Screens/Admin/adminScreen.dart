import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Screens/Admin/aboutBusiness.dart';
import 'package:puthon/Screens/Admin/adminMenuList.dart';
import 'package:puthon/Screens/Admin/adminCooksList.dart';

import 'adminTables.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

var screenList = [AdminCooksList(), AdminMenuList(), AboutBusiness()];

class _AdminScreenState extends State<AdminScreen> {
  var flag = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/amber1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                const Spacer(),
                RichText(
                  text: TextSpan(
                    text: 'PUTHON ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: "Admin",
                        style: GoogleFonts.dancingScript(
                          textStyle: TextStyle(color: Colors.red),
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("admins")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text(
                          "Please wait...",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Row(
                        children: [
                          Text(
                            "Something went wrong...",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red[400],
                            ),
                          ),
                        ],
                      );
                    } else {
                      var doc = snapshot.data;
                      return Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['resName'],
                                style: GoogleFonts.roboto(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    doc['city'] + ", ",
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    doc['state'] + ", ",
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    doc['country'],
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                              fontSize: 12),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tabs: [
                            const Tab(
                              child: Text("Cooks"),
                            ),
                            const Tab(
                              child: Text("Menu"),
                            ),
                            const Tab(
                              child: Text("Tables"),
                            ),
                            const Tab(
                              child: Text("More"),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            child: TabBarView(
                              children: [
                                AdminCooksList(),
                                AdminMenuList(),
                                AdminTables(),
                                AboutBusiness(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
