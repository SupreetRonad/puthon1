import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/shared/top.dart';


class LogOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
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
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (Top.fromDetail == 1) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                    FirebaseAuth.instance.signOut();
                                                                       
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
  }
}