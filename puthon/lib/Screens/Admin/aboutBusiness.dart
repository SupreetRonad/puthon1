import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:puthon/Shared/loading.dart';
import 'package:puthon/Shared/textField.dart';

import 'adminGenerateQR.dart';

class AboutBusiness extends StatefulWidget {
  @override
  _AboutBusinessState createState() => _AboutBusinessState();
}

class _AboutBusinessState extends State<AboutBusiness> {
  var resName, upi;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('admins')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitFadingCircle(
            color: Colors.black54,
            size: 20,
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text("Cannot fetch the details at the moment"),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  //color: Colors.white60,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width - 30,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Text(
                      snapshot.data!["resName"],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          "Building info : ",
                          style: TextStyle(fontSize: 13, color: Colors.black54
                              //fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          snapshot.data["building"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "Street : ",
                          style: TextStyle(fontSize: 13, color: Colors.black54
                              //fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          snapshot.data["street"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "State : ",
                          style: TextStyle(fontSize: 13, color: Colors.black54
                              //fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          snapshot.data["state"] + ', ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          snapshot.data["country"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "Pincode : ",
                          style: TextStyle(fontSize: 13, color: Colors.black54
                              //fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          snapshot.data["pincode"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      backgroundColor: Colors.white60,
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  onPressed: () {
                    _editInfo();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.border_color,
                        size: 30,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Edit your business' info.",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      backgroundColor: Colors.white60,
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AdminGenerateQR();
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        size: 30,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Generate QR code",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Generate QR code for tables or bots.",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _editInfo() {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        var flag = [0, 0];
        //var node = FocusScope.of(context);
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 280,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("admins")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context,AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text(
                        "Please wait...",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Row(
                      children: [
                        Text(
                          "Something went wrong...",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red[400],
                          ),
                        ),
                      ],
                    );
                  } else {
                    var doc = snapshot.data;
                    return Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Edit Info",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Divider(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: TextFormField(
                              onChanged: (val) {
                                flag[0] = 0;
                                if (val.isEmpty) {
                                  flag[0] = 1;
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              key: ValueKey('resName'),
                              initialValue: doc!['resName'],
                              keyboardType: TextInputType.name,
                              decoration: textField.copyWith(
                                labelText: "Restaurant Name",
                                labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(.35),
                                ),
                                prefixIcon: Icon(
                                  Icons.streetview,
                                  color: flag[0] == 1
                                      ? Colors.red
                                      : Colors.black87,
                                ),
                              ),
                              validator: (val) {
                                flag[0] = val!.isEmpty ? 1 : 0;
                                resName = val;
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: TextFormField(
                              onChanged: (val) {
                                flag[1] = 0;
                                if (val.isEmpty) {
                                  flag[1] = 1;
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.done,
                              key: ValueKey('upi'),
                              initialValue: doc['upiId'],
                              keyboardType: TextInputType.text,
                              decoration: textField.copyWith(
                                labelText: "Business UPI ID",
                                labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(.35),
                                ),
                                prefixIcon: Icon(
                                  Icons.monetization_on,
                                  color: flag[1] == 1
                                      ? Colors.red
                                      : Colors.black87,
                                ),
                              ),
                              validator: (val) {
                                flag[1] = val!.isEmpty ? 1 : 0;
                                upi = val;
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .65,
                            child: Text(
                              "Note : Please consult our team to change other informations.",
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.orangeAccent,
                                Colors.deepOrange[300]!
                              ]),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: TextButton(
                              style:
                                  TextButton.styleFrom(primary: Colors.white70),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formkey.currentState!.validate() &&
                                    flag.reduce((a, b) => a = a + b) == 0) {
                                  Loading(context);
                                  await FirebaseFirestore.instance
                                      .collection('admins')
                                      .doc(
                                          FirebaseAuth.instance.currentUser!.uid)
                                      .update({
                                    'resName': resName ?? doc['resName'],
                                    'upiId': upi ?? doc['upiId'],
                                  });
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Please Enter valid info in the fields",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Save"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
