import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var name = "Arnold Schwarzenegger",
    email = "arnold12340@gmail.com",
    dob,
    phone;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        endDrawer: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Drawer(
              elevation: 10,
              child: Column(children: [
                Container(
                  child: DrawerHeader(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .25,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width *
                                            .25)),
                                child: Image.asset(
                                  "assets/male2.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .04),
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      minWidth: 100, maxWidth: 150),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              .045,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  email,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              .03,
                                      color: Colors.black45),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.tealAccent,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          
                        },
                        child: Row(
                          children: [
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
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.exit_to_app_rounded,
                              color: Colors.red,
                            ),
                            Text(
                              "  Log out",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ])),
        ),
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
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.menu),
              // )
            ],
          ),
        ),
        body: Center(),
      ),
    );
  }
}
