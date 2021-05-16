import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:puthon/Screens/Admin/cookECard.dart';
import 'package:puthon/shared/loadingScreen.dart';
import 'package:puthon/shared/textField.dart';

class AdminCooksList extends StatefulWidget {
  @override
  _AdminCooksListState createState() => _AdminCooksListState();
}

class _AdminCooksListState extends State<AdminCooksList> {
  String query;

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
                                          color: Colors.black.withOpacity(.35),
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
                                            return CookECard(
                                                doc: snapshot.data.docs[index],
                                                flag: true);
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
                            child: CookECard(doc: cook, flag: false),
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
