import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var name = "Arnold Schwarzenegger", email = "arnold12340@gmail.com", dob, phone;

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
                                      "assets/male2.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
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
                                          fontSize: 18,
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
                                          fontSize: 13, color: Colors.black45),
                                    )
                                  ],
                                ),
                              ],
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
                                        borderRadius: BorderRadius.circular(15),
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

  void _confirm(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Container(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 120,
                    width: 320,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Do you really want to "),
                            Text(
                              "Log out ?",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Go back"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 110,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.red[300],
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Log out",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
