import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Shared/loading.dart';
import 'package:puthon/Utils/infoProvider.dart';
import '/Shared/confirmBox.dart';

class CookECard extends StatelessWidget {
  final doc;
  final bool flag;
  CookECard({this.doc, required this.flag});

  void _addRemoveCook(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmBox(
          b1: "Go Back",
          b2: flag ? "Add" : "Remove",
          color: flag
              ? [Colors.lightBlue[300]!, Colors.blue]
              : [Colors.redAccent, Colors.red[300]!],
          function: () async {
            Loading(context);
            if (flag) {
              FirebaseFirestore.instance
                  .collection('admins')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('cooks')
                  .doc(doc["uid"])
                  .set({
                'registeredOn': DateTime.now(),
                'uid': doc["uid"],
              });
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(doc["uid"])
                  .update({
                'cook': true,
                'resId': Info.uid,
              });
              Navigator.of(context).pop();
            } else {
              FirebaseFirestore.instance
                  .collection('admins')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('cooks')
                  .doc(doc["uid"])
                  .delete();
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(doc["uid"])
                  .update({'cook': false});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${doc['name']} has been removed successfully!",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.black,
                ),
              );
            }
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          height: 160,
          message: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${flag ? "Add" : "Remove"} Cook ?",
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: flag ? Colors.blue[300] : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Text("Do you really want to " +
                  (flag ? "Add" : "Remove") +
                  " the cook"),
              Text(
                "${doc["name"]} ?",
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white30,
          border: Border.all(
            color: flag ? Colors.transparent : Colors.amber,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      doc['gender'] == 1
                          ? "assets/images/female2.png"
                          : "assets/images/male2.png",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            doc['name'],
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          doc['email'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 13,
                              ),
                              const Icon(
                                Icons.phone,
                                size: 15,
                                color: Colors.black54,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                doc['phone'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 13,
                              ),
                              const Icon(
                                Icons.date_range,
                                size: 15,
                                color: Colors.black54,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                doc['dob'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          color: Colors.white38,
                        ),
                        child: TextButton(
                          onPressed: () {
                            _addRemoveCook(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                flag
                                    ? Icons.person_add_alt_1
                                    : Icons.person_remove_rounded,
                                size: 20,
                                color: flag ? Colors.blue : Colors.red,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                flag ? "Add Cook" : "Remove",
                                style: TextStyle(
                                  color: flag ? Colors.blue : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
