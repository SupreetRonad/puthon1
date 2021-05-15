import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/shared/loadingScreen.dart';
import 'package:puthon/shared/textField.dart';

class AdminCooksList extends StatefulWidget {
  @override
  _AdminCooksListState createState() => _AdminCooksListState();
}

class _AdminCooksListState extends State<AdminCooksList> {
  String query;

  Widget ECard(var doc) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ExpansionCard(
        margin: const EdgeInsets.only(top: 8),
        borderRadius: 20,
        background: Image.asset('assets/images/white.jpg'),
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                doc['name'],
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              Text(
                doc['email'],
                style: TextStyle(fontSize: 20, color: Colors.black),
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
                    Text(
                      doc['phone'],
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      doc['dob'],
                      style: TextStyle(fontSize: 15, color: Colors.black),
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
                                  "Cook's Details...",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 10, 8.0, 8),
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
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.search,
                                        key: ValueKey('cook'),
                                        keyboardType: TextInputType.text,
                                        decoration: textField.copyWith(
                                          labelText: "Search Cook...",
                                          labelStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(.35),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('email', isEqualTo: query)
                                        .orderBy('name')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SpinKitWave(
                                          color: Colors.black,
                                          size: 20,
                                        );
                                      }
                                      return ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ECard(
                                              snapshot.data.docs[index]);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //     primary: Colors.white,
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(20)),
                                //   ),
                                //   onPressed: () {
                                //     FirebaseFirestore.instance
                                //         .collection('admins')
                                //         .doc(FirebaseAuth
                                //             .instance.currentUser.uid)
                                //         .collection('cooks')
                                //         .doc("<cooks-uid>")
                                //         .set({});
                                //     FirebaseFirestore.instance
                                //         .collection('users')
                                //         .doc("<cooks-uid>")
                                //         .update({'cook': true});
                                //   },
                                //   child: Text(
                                //     "Add Cook",
                                //     style: TextStyle(),
                                //   ),
                                // ),
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
                  // var info = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingScreen();
                  }
                  if (snapshot.hasData) {
                    return Text(
                      "Please Add cooks...",
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return Container(
                      child: Text("Cooks here ..."),
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }
}
