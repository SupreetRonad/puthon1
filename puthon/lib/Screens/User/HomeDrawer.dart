import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/authScreen.dart';
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
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        var info = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }
        return Center(
          child: BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  displayInfo(info),
                  const SizedBox(
                    height: 10,
                  ),
                  drawerButton(
                    "Edit profile",
                    icon: Icons.border_color,
                    func: () {
                      Navigator.pushNamed(context, '/detailScreen');
                    },
                  ),
                  drawerButton(
                    "My Orders",
                    icon: Icons.list_alt,
                    func: () {
                      Navigator.pushNamed(context, '/ordersHistory');
                    },
                  ),
                  info['admin']
                      ? const SizedBox()
                      : drawerButton(
                          "Register business",
                          icon: Icons.business,
                          func: () {
                            Navigator.pushNamed(
                                context, '/businessRegisterScreen');
                          },
                        ),
                  if (info["admin"])
                    drawerButton(
                      "Admin Mode",
                      icon: Icons.how_to_reg,
                      func: () {
                        Navigator.pushNamed(context, '/adminScreen');
                      },
                    ),
                  if (info["cook"])
                    drawerButton(
                      "Cook Mode",
                      icon: Icons.restaurant,
                      func: () {
                        Navigator.pushNamed(context, '/cookScreen');
                      },
                    ),
                  if (info['scanned'] != 2)
                    drawerButton(
                      "Log out",
                      icon: Icons.exit_to_app_rounded,
                      func: () {
                        _confirm(context);
                      },
                      primary: Colors.red,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      splashRadius: 25,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget drawerButton(
    String name, {
    required IconData icon,
    required Function() func,
    Color color = Colors.white,
    Color primary = Colors.black,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: TextButton(
          style: TextButton.styleFrom(
            primary: primary,
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: func,
          child: Container(
            height: 30,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  size: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                ),
              ],
            ),
          ),
        ),
      );

  Widget displayInfo(var info) => Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow[300],
            ),
            margin: EdgeInsets.only(top: 40),
          ),
          Container(
            height: 150,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                  width: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      info!['gender'] == 1
                          ? "assets/images/female2.png"
                          : "assets/images/male2.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        info['name'] ?? 'Name',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        info['email'] ?? 'name@email.com',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  void _confirm(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmBox(
          height: 180,
          b1: "Go Back",
          b2: "Log Out",
          color: [
            Colors.redAccent,
            Colors.red[300]!,
          ],
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (builder) => AuthScreen(),
              ),
            );
          },
          message: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Text(
                  "Logout ?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[300],
                    fontSize: 20,
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                const Text("Do you really want to logout ?"),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Once logged out, you will have to login again using credentils.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[200],
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
