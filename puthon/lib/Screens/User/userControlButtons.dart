import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/Admin/addMenuItem.dart';

class UserControlButtons extends StatefulWidget {
  var item;
  UserControlButtons({this.item});
  @override
  _UserControlButtonsState createState() => _UserControlButtonsState();
}

class _UserControlButtonsState extends State<UserControlButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 155,
      decoration: BoxDecoration(
        color: Colors.red[300],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Text("Hii"),
    );
  }
}
