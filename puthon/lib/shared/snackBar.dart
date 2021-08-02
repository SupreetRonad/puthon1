import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showMsg(
  BuildContext context, {
  required String msg,
  Color color = Colors.amber,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
    ),
  );
}
