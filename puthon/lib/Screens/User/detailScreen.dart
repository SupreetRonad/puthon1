import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Shared/loadingScreen.dart';
import 'package:puthon/shared/textField.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();

  var dob = null, gender = 1, register = true;
  bool _isLoading = false, _isLoading1 = true;
  var flag = [0, 0, 0, 0], flag1 = 0;

  void readData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          _name.text = value.data()!["name"];
          _phone.text = value.data()!["phone"];
          dob = value.data()!["dob"];
          gender = value.data()!["gender"];
          register = value.data()!["register"];
          _isLoading1 = false;
        });
      }
    });
  }

  void saveInfo() async {
    _isLoading = true;
    final _isValid = _formkey.currentState!.validate();
    _formkey.currentState!.save();
    if (_isValid && flag[0] == 0 && flag[1] == 0) {
      if (register) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'name': _name.text,
          'phone': _phone.text,
          'dob': dob,
          'gender': gender,
          'register': false,
          'scanned': 1,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'name': _name.text,
          'phone': _phone.text,
          'dob': dob,
          'gender': gender,
          'register': false,
        });
      }
      _isLoading1 = true;
      _isLoading = false;
      setState(() {
        flag[0] = 0;
        flag[1] = 0;
      });

      if (!register) {
        Navigator.pop(context);
      }
    }
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/leaves1.jpg"),
          fit: BoxFit.cover,
        ),
        color: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: _isLoading1
            ? LoadingScreen()
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(20),
                        ),
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
                                  register
                                      ? "Tell us about yourself"
                                      : "Edit Profile",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 15),
                                  CField(
                                    controller: _name,
                                    label: 'Name',
                                    preIcon: Icons.person,
                                    bgColor: Colors.white70,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CField(
                                    controller: _phone,
                                    label: 'Phone',
                                    preIcon: Icons.phone,
                                    bgColor: Colors.white70,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      selectDate(),
                                      Text(
                                        "|",
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.black26,
                                        ),
                                      ),
                                      imageRadio(
                                        "assets/images/female2.png",
                                        selectC: 1,
                                      ),
                                      imageRadio(
                                        "assets/images/male2.png",
                                        selectC: 2,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      if (!register)
                                        Container(
                                          height: 60,
                                          width: 70,
                                          child: Card(
                                            shadowColor: Colors.white70,
                                            color: Colors.white60,
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.0),
                                            ),
                                            child: TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Icon(
                                                Icons.close_rounded,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      Container(
                                        height: 60,
                                        width: 120,
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: TextButton(
                                            onPressed: _isLoading
                                                ? null
                                                : saveInfo,
                                            child: _isLoading
                                                ? SpinKitFadingCircle(
                                                    color: Colors.black,
                                                    size: 20.0,
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Save  ",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontSize: 15),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_forward_ios,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget imageRadio(
    String img, {
    required int selectC,
  }) =>
      Container(
        padding: EdgeInsets.all(0),
        height: 55,
        width: 55,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          color: gender == selectC ? Colors.white : Colors.transparent,
          child: ClipOval(
            child: TextButton(
              onPressed: () {
                setState(() {
                  gender = selectC;
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.asset(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );

  Widget selectDate() => Card(
        color: Colors.white70,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              child: DateTimePicker(
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
                    color: Colors.black.withOpacity(.35),
                  ),
                ),
                type: DateTimePickerType.date,
                dateMask: 'd MMM, yyyy',
                initialValue: dob ?? "2000-05-07 18:51:51.502031",
                firstDate: DateTime(1850),
                lastDate: DateTime(2003),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (val) => setState(() => dob = val),
                validator: (val) {
                  setState(() => dob = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(
                  () => dob = val ?? '',
                ),
              ),
            ),
          ],
        ),
      );
}
