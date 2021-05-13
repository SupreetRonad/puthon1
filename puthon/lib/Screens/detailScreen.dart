import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/shared/textField.dart';

import 'loadingScreen.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

var name, phone, dob = null, gender = 1, register;
// ignore: unused_element
bool _isLoading = false, _isLoading1 = true;
var flag = [0, 0, 0, 0], flag1 = 0;

class _DetailScreenState extends State<DetailScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void readData() async {
    //print("######\n");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      if (value.exists) {
        //print(value.data()["name"]);
        setState((){
          name = value.data()["name"];
          phone = value.data()["phone"];
          dob = value.data()["dob"];
          gender = value.data()["gender"];
          register = value.data()["register"];
          _isLoading1 = false;
        });
        
      }
    });
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    
    final node = FocusScope.of(context);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/kiwi.jpg"),
            fit: BoxFit.cover,
          ),
          color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: _isLoading1 ? LoadingScreen() : Form(
            key: _formkey,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Welcome to..",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .028,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * .06,
                        child: Image.asset(
                          "assets/images/puthon2.png",
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            "Tell us about yourself..",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: TextFormField(
                                initialValue: name ,
                                onChanged: (val) {
                                  setState(() {
                                    flag[0] = 0;
                                    if (val.isEmpty) {
                                      flag[0] = 1;
                                    }
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                key: ValueKey('name'),
                                onEditingComplete: () => node.nextFocus(),
                                keyboardType: TextInputType.emailAddress,
                                decoration: textField.copyWith(
                                  labelText: flag[0] == 1
                                      ? "Please enter your name here"
                                      : "Name",
                                  labelStyle: TextStyle(
                                      color: flag[0] == 1
                                          ? Colors.red
                                          : Colors.black.withOpacity(.35),
                                      fontSize: flag[0] == 1 ? 13 : 17),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.black87,
                                  ),
                                ),
                                validator: (val) {
                                  if (val.isEmpty) {
                                    setState(() {
                                      flag[0] = 1;
                                    });
                                    return null;
                                  }

                                  setState(() {
                                    flag[0] = 0;
                                  });
                                  return null;
                                },
                                onSaved: (val) {
                                  setState(() => name = val);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: TextFormField(
                                initialValue: phone,
                                onChanged: (val) {
                                  setState(() {
                                    flag[1] = 0;
                                    if (!RegExp(r'^[0-9]{10}$').hasMatch(val)) {
                                      flag[1] = 1;
                                    }
                                  });
                                },
                                textInputAction: TextInputAction.done,
                                key: ValueKey('phone'),
                                onEditingComplete: () => node.unfocus(),
                                keyboardType: TextInputType.phone,
                                decoration: textField.copyWith(
                                    labelText: flag[1] == 1
                                        ? "Please enter a valid phone number"
                                        : "Phone number",
                                    labelStyle: TextStyle(
                                        color: flag[1] == 1
                                            ? Colors.red
                                            : Colors.black.withOpacity(.35),
                                        fontSize: flag[1] == 1 ? 13 : 17),
                                    prefixIcon: const Icon(
                                      Icons.phone,
                                      color: Colors.black87,
                                    ),
                                    prefixText: "+91 "),
                                validator: (val) {
                                  if (val.isEmpty ||
                                      !RegExp(r'^[0-9]{10}$').hasMatch(val)) {
                                    setState(() {
                                      flag[1] = 1;
                                    });
                                    return null;
                                  }

                                  setState(() {
                                    flag[1] = 0;
                                  });
                                  return null;
                                },
                                onSaved: (val) {
                                  phone = val;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 160,
                                        child: DateTimePicker(
                                          //enableInteractiveSelection: true,
                                          calendarTitle: "Select Date Of Birth",
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.date_range,
                                              color: Colors.black,
                                            ),
                                            labelText: "DOB",
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            labelStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(.35),
                                            ),
                                          ),

                                          type: DateTimePickerType.date,
                                          dateMask: 'd MMM, yyyy',
                                          initialValue: dob ??
                                              "2000-05-07 18:51:51.502031",
                                          firstDate: DateTime(1850),
                                          lastDate: DateTime(2003),
                                          icon: Icon(Icons.event),
                                          dateLabelText: 'Date',
                                          timeLabelText: "Hour",
                                          onChanged: (val) =>
                                              setState(() => dob = val),
                                          validator: (val) {
                                            setState(() => dob = val ?? '');
                                            return null;
                                          },
                                          onSaved: (val) =>
                                              setState(() => dob = val ?? ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "|",
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.black26,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(0),
                                  height: 55,
                                  width: 55,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    color: gender == 1
                                        ? Colors.lightGreen
                                        : Colors.transparent,
                                    elevation: gender == 1 ? 0 : 0,
                                    child: ClipOval(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            gender = 1;
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image.asset(
                                            "assets/images/female2.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(0),
                                  height: 55,
                                  width: 55,
                                  child: Card(
                                    elevation: gender == 2 ? 0 : 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    color: gender == 2
                                        ? Colors.lightGreen
                                        : Colors.transparent,
                                    child: ClipOval(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            gender = 2;
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image.asset(
                                            "assets/images/male2.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Container(
                                  height: 60,
                                  width: 200,
                                  child: Card(
                                    color: Colors.lightGreen,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: TextButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () async {
                                              _isLoading = true;
                                              final _isValid = _formkey
                                                  .currentState
                                                  .validate();
                                              _formkey.currentState.save();
                                              if (_isValid &&
                                                  flag[0] == 0 &&
                                                  flag[1] == 0) {
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser.uid)
                                                    .update({
                                                  'name': name,
                                                  'phone': phone,
                                                  'dob': dob,
                                                  'gender': gender,
                                                  'register': false,
                                                });
                                                _isLoading1 = true;
                                                _isLoading = false;
                                                setState(() {
                                                  flag[0] = 0;
                                                  flag[1] = 0;
                                                });
                                                
                                                if(!register) {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  //Navigator.pushReplacementNamed(context, '/homeScreen');
                                                }
                                              }
                                              _isLoading = false;
                                            },
                                      child: _isLoading
                                          ? SpinKitWave(
                                              color: Colors.white,
                                              size: 20.0,
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Save and Continue ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {    
  //   super.dispose();
  // }
}
