import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/shared/loading.dart';
import 'package:puthon/shared/showMsg.dart';
import 'package:puthon/shared/textField.dart';

class EditResInfo extends StatefulWidget {
  const EditResInfo({Key? key}) : super(key: key);

  @override
  _EditResInfoState createState() => _EditResInfoState();
}

class _EditResInfoState extends State<EditResInfo> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var flag = [0, 0];
  String? resName = null, upi = null;

  void saveInfo() async {
    FocusScope.of(context).unfocus();
    if (_formkey.currentState!.validate() &&
        flag.reduce((a, b) => a = a + b) == 0) {
      Loading(context);
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'resName': resName,
        'upiId': upi,
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      showToast(
        "Please Enter valid info in the fields",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 280,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("admins")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
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
                resName = doc!['resName'];
                upi = doc!['upiId'];
                return Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Edit Info",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Divider(),
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
                          initialValue: resName,
                          keyboardType: TextInputType.name,
                          decoration: textField.copyWith(
                            labelText: "Restaurant Name",
                            labelStyle: TextStyle(
                              color: Colors.black.withOpacity(.35),
                            ),
                            prefixIcon: Icon(
                              Icons.streetview,
                              color: flag[0] == 1 ? Colors.red : Colors.black87,
                            ),
                          ),
                          validator: (val) {
                            flag[0] = val!.isEmpty ? 1 : 0;
                            resName = val;
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
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
                          initialValue: upi,
                          keyboardType: TextInputType.text,
                          decoration: textField.copyWith(
                            labelText: "Business UPI ID",
                            labelStyle: TextStyle(
                              color: Colors.black.withOpacity(.35),
                            ),
                            prefixIcon: Icon(
                              Icons.monetization_on,
                              color: flag[1] == 1 ? Colors.red : Colors.black87,
                            ),
                          ),
                          validator: (val) {
                            flag[1] = val!.isEmpty ? 1 : 0;
                            upi = val;
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .65,
                        child: const Text(
                          "Note : Please consult our team to change other informations.",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orangeAccent,
                              Colors.deepOrange[300]!
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white70,
                          ),
                          onPressed: saveInfo,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.save),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text("Save"),
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
  }
}
