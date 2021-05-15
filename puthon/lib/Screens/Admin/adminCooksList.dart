import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:puthon/shared/loadingScreen.dart';
import 'package:puthon/shared/textField.dart';

class AdminCooksList extends StatefulWidget {
  @override
  _AdminCooksListState createState() => _AdminCooksListState();
}

class _AdminCooksListState extends State<AdminCooksList> {
  String query;

  Widget ECard(var doc, bool flag) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ExpansionCard(
        margin: const EdgeInsets.only(top: 8),
        borderRadius: 20,
        background: Image.asset('assets/images/white.jpg'),
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
                Column(
                  children: [
                    Row(
                      children: [
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
                      height: 10,
                    ),
                    Row(
                      children: [
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            primary:
                                flag ? Colors.lightBlue[400] : Colors.red[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            if (flag) {
                              FirebaseFirestore.instance
                                  .collection('admins')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
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
                            } else {
                              FirebaseFirestore.instance
                                  .collection('admins')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('cooks')
                                  .doc(doc["uid"])
                                  .delete();
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(doc["uid"])
                                  .update({'cook': false});
                            }
                          },
                          child: Text(
                            flag ? "Add Cook" : "Remove",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
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
                        backgroundColor: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height:
                                MediaQuery.of(context).size.height * .6 + 80,
                            width: MediaQuery.of(context).size.width * .8,
                            child: Column(
                              children: [
                                Text(
                                  "Add Cook",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 10, 0.0, 8),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white.withOpacity(1),
                                      ),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {
                                            query = val;
                                          });
                                        },
                                        textInputAction: TextInputAction.search,
                                        key: ValueKey('cook'),
                                        keyboardType: TextInputType.text,
                                        decoration: textField.copyWith(
                                          hintText: "Search User...",
                                          hintStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(.35),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('email',
                                            isEqualTo: query ?? "@gmail.com")
                                        .where('email',
                                            isNotEqualTo: FirebaseAuth
                                                .instance.currentUser.email)
                                        // .where('çook', isEqualTo: false)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SpinKitWave(
                                          color: Colors.black,
                                          size: 20,
                                        );
                                      }
                                      if (snapshot.hasData &&
                                          snapshot.data.docs.length > 0) {
                                        return ListView.builder(
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (snapshot.data.docs[index]
                                                    ['cook'] ==
                                                true) {
                                              return Text(
                                                  "Role as Cook given!");
                                            }
                                            return ECard(
                                                snapshot.data.docs[index],
                                                true);
                                          },
                                        );
                                      }
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Lottie.asset(
                                            "assets/animations/notfound.json",
                                            height: 100,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "No results found...",
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.add),
            label: Text(
              "Add Cook",
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admins')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection('cooks')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingScreen();
                  }
                  if (!snapshot.hasData) {
                    return Text(
                      "Please Add cooks...",
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var cook = snapshot.data.docs[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: ECard(cook, false),
                          );
                        });
                  }
                }),
          ),
        ),
      ],
    );
  }
}
