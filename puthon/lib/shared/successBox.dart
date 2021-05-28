import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessBox extends StatelessWidget {
  final title, msg1, msg2;
  SuccessBox({this.msg1, this.msg2, this.title});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: Column(
          children: [
            Lottie.asset(
              "assets/animations/confirmation.json",
              repeat: false,
              height: 70,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.green[400],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                "\t${msg1}",
                textAlign: TextAlign.center,
              ),
              Text(
                "\n\t${msg2}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.greenAccent, Colors.green]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
