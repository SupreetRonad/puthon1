import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Shared/confirmBox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/shared/loadingScreen.dart';
import 'cartButton.dart';
import 'homeScreen.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        var info = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 10, 0),
            child: Column(
              children: [
                Container(
                  height: 500,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Drawer(
                      elevation: 10,
                      child: Column(
                        children: [
                          Container(
                            height: 140,
                            child: Row(
                              children: [
                                SizedBox(width: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.red.withOpacity(.6),
                                  ),
                                  width: 90,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5.0, sigmaY: 5.0),
                                      child: Image.asset(
                                        info['gender'] == 1
                                            ? "assets/images/female2.png"
                                            : "assets/images/male2.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 130,
                                      child: Text(
                                        info['name'] ?? 'Name',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      width: 130,
                                      child: Text(
                                        info['email'] ?? 'name@email.com',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black45),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (info["admin"])
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/adminScreen');
                                        },
                                        child: Text(
                                          "Admin Mode",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.red[400],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    if (info["cook"])
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/cookScreen');
                                        },
                                        child: Text(
                                          "Cook Mode",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.red[400],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/detailScreen');
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/ordersHistory');
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.list_alt,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "  My Orders",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                info['admin']
                                    ? SizedBox()
                                    : TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              '/businessRegisterScreen');
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.list_alt,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "  Register my business",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (prefs.getInt('orderNo') == 0)
                                  Row(
                                    children: [
                                      Spacer(),
                                      Container(
                                        width: 110,
                                        decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(.7),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: TextButton(
                                            onPressed: () {
                                              _confirm(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.exit_to_app_rounded,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "  Log out",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirm(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmBox(
          b1: "Go Back",
          b2: "Log Out",
          color: Colors.red[300],
          function: () async {
            for (var i = 0; i < HomeScreen.list.length; i++) {
              prefs.remove(HomeScreen.list[i]);
              prefs.remove(HomeScreen.list[i] + "1");
              prefs.remove(HomeScreen.list[i] + "2");
            }
            HomeScreen.list = [];
            prefs.setStringList("orderList", []);
            CartButton.orderList = {};
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pop();
          },
          message: Column(
            children: [
              Icon(
                Icons.exit_to_app_rounded,
                size: 130,
                color: Colors.red[300],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Do you really want to "),
                  Text(
                    "Log out ?",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
