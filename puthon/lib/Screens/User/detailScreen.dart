import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Shared/loadingScreen.dart';
import 'package:puthon/shared/showMsg.dart';
import 'package:puthon/shared/textField.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();

  String? dob = null;
  int gender = 1;
  bool _isLoading = false, _isLoading1 = true, register = true;

  void readData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          _name.text = value.data()!["name"] ?? '';
          _phone.text = value.data()!["phone"] ?? '';
          dob = value.data()!["dob"] ?? '';
          gender = value.data()!["gender"] ?? 0;
          register = value.data()!["register"] ?? true;
          _isLoading1 = false;
        });
      }
    });
  }

  void saveInfo() async {
    _isLoading = true;
    setState(() {});
    if (_name.text.isNotEmpty && _phone.text.isNotEmpty) {
      if (!RegExp(r'^[0-9]{10}$').hasMatch(_phone.text)) {
        showSnack(
          context,
          'Please enter valid mobile number!',
          color: Colors.red,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
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

      if (!register) {
        Navigator.pop(context);
      }
    } else {
      showSnack(
        context,
        'Please fill in all the fields!',
        color: Colors.red,
      );
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                                      preText: '+91 ',
                                      maxLen: 10,
                                      inputType: TextInputType.phone,
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
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        if (!register)
                                          SizedBox(
                                            height: 50,
                                            child: TextButton(
                                              style: style(Colors.white38),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Icon(
                                                Icons.close_rounded,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          height: 50,
                                          width: 120,
                                          child: _isLoading
                                              ? SpinKitFadingCircle(
                                                  color: Colors.white60,
                                                  size: 20.0,
                                                )
                                              : TextButton(
                                                  style: style(
                                                    Colors.white70,
                                                  ),
                                                  onPressed: _isLoading
                                                      ? null
                                                      : saveInfo,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Save  ",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                    ],
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
                  ],
                ),
              ),
      ),
    );
  }

  ButtonStyle style(Color primary) => ElevatedButton.styleFrom(
        primary: primary,
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      );

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

  Widget selectDate() => Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(20),
        ),
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
      );
}
