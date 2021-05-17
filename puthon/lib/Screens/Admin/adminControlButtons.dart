import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Shared/confirmBox.dart';

import 'addMenuItem.dart';

class AdminControlButtons extends StatelessWidget {
  final item;
  AdminControlButtons({this.item});
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
      child: Row(
        children: [
          Container(
            height: 40,
            width: 50,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmBox(
                      height: 150,
                      b1: "Go Back",
                      b2: "Delete",
                      color: Colors.red[300],
                      message: Column(
                        children: [
                          Text("Do you want to delete"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            item["itemName"] + " ?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300],
                                fontSize: 20),
                          )
                        ],
                      ),
                      function: () async {
                        await FirebaseFirestore.instance
                            .collection('admins')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .collection("menu")
                            .doc(item["itemName"])
                            .delete();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            height: 40,
            width: 105,
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 50,
                  child: TextButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmBox(
                              height: 150,
                              b1: "Go Back",
                              b2: item["inMenu"] ? "Disable" : "Enable",
                              color: item["inMenu"]
                                  ? Colors.red[300]
                                  : Colors.green[300],
                              message: Column(
                                children: [
                                  Text(item["inMenu"]
                                      ? "Do you want to disable"
                                      : "Do you want to enable"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    item["itemName"] + " ?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: item["inMenu"]
                                            ? Colors.red[300]
                                            : Colors.green[300],
                                        fontSize: 20),
                                  )
                                ],
                              ),
                              function: () async {
                                await FirebaseFirestore.instance
                                    .collection('admins')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .collection('menu')
                                    .doc(item["itemName"])
                                    .update({"inMenu": !item["inMenu"]});
                                Navigator.of(context).pop();
                              },
                            );
                          });
                    },
                    child: Icon(
                      item["inMenu"]
                          ? Icons.arrow_circle_down_outlined
                          : Icons.arrow_circle_up_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddMenuItem(
                              modify: true,
                              itemName: item["itemName"],
                            );
                          });
                    },
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}