import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Shared/confirmBox.dart';

class CookECard extends StatelessWidget {
  final doc;
  final bool flag;
  CookECard({this.doc, this.flag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ExpansionCard(
        margin: const EdgeInsets.only(top: 8),
        borderRadius: 20,
        background: Image.asset(
          flag ? 'assets/images/cardbg2.jpg' : 'assets/images/cardbg1.jpg',
          fit: BoxFit.fill,
        ),
        title: Container(
          child: Row(
            children: [
              Container(
                width: 60,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(100)),
                child: Image.asset(
                  doc['gender'] == 1
                      ? "assets/images/female2.png"
                      : "assets/images/male2.png",
                ),
              ),
              SizedBox(
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
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      doc['email'],
                      style: TextStyle(
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.phone,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            doc['phone'],
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.date_range,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            doc['dob'],
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              primary: Colors.white60,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmBox(
                                    b1: "Go Back",
                                    b2: flag ? "Add" : "Remove",
                                    color: flag
                                        ? Colors.lightBlue[300]
                                        : Colors.red[300],
                                    function: () async {
                                      if (flag) {
                                        FirebaseFirestore.instance
                                            .collection('admins')
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .collection('cooks')
                                            .doc(doc["uid"])
                                            .set({
                                          'registeredOn': DateTime.now(),
                                          'uid': doc["uid"],
                                          'name': doc["name"],
                                          'email': doc["email"],
                                          'gender': doc["gender"],
                                          'phone': doc["phone"],
                                          'dob': doc["dob"]
                                        });
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(doc["uid"])
                                            .update({'cook': true});
                                        Navigator.of(context).pop();
                                      } else {
                                        FirebaseFirestore.instance
                                            .collection('admins')
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
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
                                    },
                                    message: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: flag ? 30 : 25,
                                            ),
                                            Icon(
                                              flag
                                                  ? Icons
                                                      .person_add_alt_1_rounded
                                                  : Icons
                                                      .person_remove_alt_1_rounded,
                                              color: flag
                                                  ? Colors.blue[300]
                                                  : Colors.red[300],
                                              size: 130,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text("Do you really want to " +
                                            (flag ? "Add" : "Remove")),
                                        Text(
                                          "${doc["name"]} ?",
                                          style: TextStyle(
                                            color: flag
                                                ? Colors.blue[300]
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
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
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  flag ? "Add Cook" : "Remove",
                                  style: TextStyle(
                                      color: flag ? Colors.blue : Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
