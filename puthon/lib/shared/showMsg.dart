import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showSnack(
  BuildContext context,
  String msg, {
  Color color = Colors.amber,
  Color textColor = Colors.white,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: TextStyle(
          color: textColor,
        ),
      ),
      backgroundColor: color,
    ),
  );
}

void showToast(
  String msg, {
  Color bgColor = Colors.black54,
  Color textColor = Colors.white,
}) {
  Fluttertoast.showToast(
    msg: "Please wait until your order gets delivered",
    gravity: ToastGravity.SNACKBAR,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: bgColor,
    textColor: textColor,
  );
}
