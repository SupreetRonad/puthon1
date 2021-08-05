import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Shared/confirmBox.dart';
import 'package:puthon/Shared/loading.dart';

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
        color: Colors.black12,
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
                      height: 200,
                      b1: "Go Back",
                      b2: "Delete",
                      color: [
                        Colors.redAccent,
                        Colors.red[300]!,
                      ],
                      message: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Delete item ?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300],
                                fontSize: 20,
                              ),
                            ),
                            const Divider(),
                            const Text("Do you want to delete the item"),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              item["itemName"] + " ?",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Once deleted, all the info related to item will be deleted. Cannot be restored.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red[200],
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      function: () async {
                        Loading(context);
                        await FirebaseFirestore.instance
                            .collection('admins')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("menu")
                            .doc(item["itemName"])
                            .delete();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              child: Icon(
                Icons.delete,
                color: Colors.red[300],
                size: 20,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
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
                              height: 200,
                              b1: "Go Back",
                              b2: item["inMenu"] ? "Disable" : "Enable",
                              color: item["inMenu"]
                                  ? [Colors.grey[200]!, Colors.black54]
                                  : [Colors.greenAccent, Colors.green[300]!],
                              message: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      item["inMenu"]
                                          ? "Disable item ?"
                                          : "Enable item ?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: item["inMenu"]
                                            ? Colors.black54
                                            : Colors.green[400],
                                        fontSize: 20,
                                      ),
                                    ),
                                    const Divider(),
                                    Text(item["inMenu"]
                                        ? "Do you want to disable the item"
                                        : "Do you want to enable the item"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      item["itemName"] + " ?",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      item["inMenu"]
                                          ? "Once disabled, the item will no longer be visible to the customers."
                                          : "Once enabled, the item will be visible to the customers to order from.",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              function: () async {
                                Loading(context);
                                await FirebaseFirestore.instance
                                    .collection('admins')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('menu')
                                    .doc(item["itemName"])
                                    .update({"inMenu": !item["inMenu"]});
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            );
                          });
                    },
                    child: Icon(
                      item["inMenu"]
                          ? Icons.download_rounded
                          : Icons.publish_rounded,
                      color: Colors.black54,
                      size: 20,
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.black12,
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
                        },
                      );
                    },
                    child: const Icon(
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
