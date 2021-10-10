import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/authScreen.dart';
import 'package:puthon/Shared/confirmBox.dart';
import 'package:puthon/Utils/infoProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cartButton.dart';

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
    return Center(
      child: BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              displayInfo(),
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
              Info.admin
                  ? const SizedBox()
                  : drawerButton(
                      "Register business",
                      icon: Icons.business,
                      func: () {
                        Navigator.pushNamed(context, '/businessRegisterScreen');
                      },
                    ),
              if (Info.admin)
                drawerButton(
                  "Admin Mode",
                  icon: Icons.how_to_reg,
                  func: () {
                    Navigator.pushNamed(context, '/adminScreen');
                  },
                ),
              if (Info.cook)
                drawerButton(
                  "Cook Mode",
                  icon: Icons.restaurant,
                  func: () {
                    Navigator.pushNamed(context, '/cookScreen');
                  },
                ),
              if (EnteredRes.scanned != 2)
                drawerButton(
                  "Log out",
                  icon: Icons.exit_to_app_rounded,
                  func: () {
                    _confirm(context);
                  },
                  primary: Colors.white,
                  color: Colors.red.withOpacity(0.6),
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
  }

  Widget drawerButton(
    String name, {
    required IconData icon,
    required Function() func,
    Color color = Colors.white70,
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

  Widget displayInfo() => Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow[300],
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/amber1.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.only(top: 40),
          ),
          Container(
            height: 155,
            child: Column(
              children: [
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      Info.gender == 2
                          ? "assets/images/male2.png"
                          : "assets/images/female2.png",
                      fit: BoxFit.cover,
                      height: 90,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        Info.name,
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
                        Info.email,
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
            for (var i = 0; i < EnteredRes.list.length; i++) {
              prefs.remove(EnteredRes.list[i]);
              prefs.remove(EnteredRes.list[i] + "1");
              prefs.remove(EnteredRes.list[i] + "2");
            }
            EnteredRes.list = [];
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
