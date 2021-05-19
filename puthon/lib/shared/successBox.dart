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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              Text("\t${msg1}"),
              Text("\n\t${msg2}"),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
