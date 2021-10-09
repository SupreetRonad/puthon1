import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Screens/User/homeScreen.dart';
import 'package:puthon/Shared/loadingScreen.dart';
import 'package:puthon/Utils/infoProvider.dart';
import 'package:puthon/Utils/pagesurf.dart';
import 'package:puthon/Utils/showMsg.dart';
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

  Info info = Info();

  void readData() async {
    _name.text = Info.name;
    _phone.text = Info.phone;
    dob = Info.dob;
    gender = Info.gender;
    register = Info.register;
    _isLoading1 = false;
    setState(() {});
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
        await info.readData(FirebaseAuth.instance.currentUser!.uid);
        replacePage(context, HomeScreen());
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
        await info.readData(FirebaseAuth.instance.currentUser!.uid);
        Navigator.pop(context);
      }
      _isLoading1 = true;
      _isLoading = false;
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
          image: AssetImage(
            "assets/images/amber1.jpg",
          ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Text(
                            "Your profile",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            register
                                ? "Tell us about yourself..."
                                : "Your information...",
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                            bgColor: Colors.white.withOpacity(.6),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CField(
                            controller: _phone,
                            label: 'Phone',
                            preIcon: Icons.phone,
                            bgColor: Colors.white.withOpacity(.6),
                            preText: '+91 ',
                            maxLen: 10,
                            inputType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              selectDate(),
                              const Text(
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
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (!register)
                                SizedBox(
                                  height: 50,
                                  child: TextButton(
                                    style: style(),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              _saveButton(),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _saveButton() => SizedBox(
        height: 50,
        width: 120,
        child: _isLoading
            ? const SpinKitFadingCircle(
                color: Colors.black54,
                size: 20.0,
              )
            : ElevatedButton(
                style: style(),
                onPressed: _isLoading ? null : saveInfo,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Save  ",
                      style: TextStyle(color: Colors.white),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
      );

  ButtonStyle style() => ElevatedButton.styleFrom(
        elevation: 5,
        primary: Colors.amber[600],
        shadowColor: Colors.amber[700]!.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
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
          color: gender == selectC
              ? Colors.white.withOpacity(.6)
              : Colors.transparent,
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
          color: Colors.white.withOpacity(.6),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 160,
        child: DateTimePicker(
          calendarTitle: "Select Date Of Birth",
          decoration: InputDecoration(
            prefixIcon: const Icon(
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
          icon: const Icon(Icons.event),
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
