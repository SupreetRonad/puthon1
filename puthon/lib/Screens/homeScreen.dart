import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/loadingScreen.dart';
import 'package:puthon/shared/cartButton.dart';
import 'package:puthon/shared/logOut.dart';

var name = "Name",
    email = "email@email.com",
    dob = "00/00/0000",
    phone = "1081081081",
    gender = 1;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CartButton(),
      endDrawer: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/detailScreen');
                                },
                                child: Container(
                                  height: 140,
                                  color: Colors.grey[400],
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 15),
                                      Container(
                                        width: 110,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Image.asset(
                                            info['gender'] == 1
                                                ? "assets/images/female2.png"
                                                : "assets/images/male2.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                minWidth: 100, maxWidth: 150),
                                            child: Text(
                                              info['name'] ?? 'Name',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            info['email'] ?? 'email@email.com',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black45),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {},
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
                                    SizedBox(
                                      height: 250,
                                    ),
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
          }),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            SizedBox(
              width: 0,
            ),
            Text("PUTHON"),
            Spacer(),
          ],
        ),
      ),
      body: Center(),
    );
  }

  void _confirm(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogOut();
      },
    );
  }
}
