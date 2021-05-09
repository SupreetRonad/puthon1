import 'dart:ui';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/shared/textField.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

var name, phone, dob, gender = 0;
bool _isLoading = false;
var flag = [0, 0, 0, 0];

class _DetailScreenState extends State<DetailScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var _controller1 = TextEditingController(text: DateTime.now().toString());
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/kiwi.jpg"),
            fit: BoxFit.cover,
          ),
          color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Form(
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
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Text(
                      //   "PUTHON",
                      //   style: TextStyle(
                      //     fontSize: 50,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      Container(
                        height: 50,
                        child: Image.asset(
                          "assets/puthon2.png",
                        ),
                      ),
                    ],
                  ),
                ),
                //Spacer(),

                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Column(children: [
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
                            //color: Colors.white,
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
                            //color: Colors.white.withOpacity(.7),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: TextFormField(
                              onChanged: (val) {
                                flag[0] = 0;
                                setState(() {});
                              },
                              textInputAction: TextInputAction.next,
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
                                flag[0] = 0;
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
                            //color: Colors.white.withOpacity(.7),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: TextFormField(
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
                              keyboardType: TextInputType.emailAddress,
                              decoration: textField.copyWith(
                                  labelText: flag[1] == 1
                                      ? "Please enter a valid phone number"
                                      : "Pnone number",
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
                                if (val.isEmpty) {
                                  setState(() {
                                    flag[1] = 1;
                                  });
                                  return null;
                                }
                                flag[1] = 0;
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Icon(Icons.date_range),
                                    //SizedBox(width: 5,),
                                    Container(
                                      width: 150,
                                      child: DateTimePicker(
                                        enableInteractiveSelection: true,
                                        calendarTitle: "Select Date Of Birth",
                                        decoration: InputDecoration(                                      
                                          prefixIcon: Icon(Icons.date_range, color: Colors.black,),
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
                                        controller: _controller1,
                                        //initialValue: _initialValue,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100),
                                        icon: Icon(Icons.event),
                                        dateLabelText: 'Date',
                                        timeLabelText: "Hour",
                                        //use24HourFormat: false,
                                        //locale: Locale('pt', 'BR'),

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
                              Spacer(),
                              Container(
                                height: 55,
                                width: 55,
                                child: Card(
                                  elevation: gender == 0 ? 0 : 0,
                                  color: gender == 0
                                      ? Colors.lightGreen
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: ClipOval(
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          gender = 0;
                                        });
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: Image.asset(
                                          "assets/other.png",
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
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
                                          "assets/female2.png",
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
                                      borderRadius: BorderRadius.circular(100)),
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
                                          "assets/male2.png",
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
                                        : () {
                                            _formkey.currentState.validate();
                                            _formkey.currentState.save();
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
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            child: Icon(
                              Icons.exit_to_app,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
