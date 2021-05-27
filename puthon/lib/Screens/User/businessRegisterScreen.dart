import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Screens/User/tnc.dart';
import 'package:puthon/shared/textField.dart';

class RegisterBusiness extends StatefulWidget {
  @override
  _RegisterBusinessState createState() => _RegisterBusinessState();
}

var resName, building, street, city, state, pincode, name, phone, email, upi;
var flag = [0, 0, 0, 0, 0, 0, 0];
bool flag1 = false, loading = false;

class _RegisterBusinessState extends State<RegisterBusiness> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void readData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          name = value.data()["name"];
          phone = value.data()["phone"];
          email = FirebaseAuth.instance.currentUser.email;
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
    return Theme(
      data: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.white,
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: Colors.white)),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/res5.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Register My Business",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 750,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Enter the Name of your restaurant..",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  color: Colors.white.withOpacity(.4),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      flag[0] = 0;
                                      if (val.isEmpty) {
                                        flag[0] = 1;
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('resname'),
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.text,
                                    decoration: textField.copyWith(
                                      labelText: "Restaurant name",
                                      labelStyle: TextStyle(
                                        color: Colors.black.withOpacity(.35),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.restaurant,
                                        color: flag[0] == 1
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                    validator: (val) {
                                      flag[0] = val.isEmpty ? 1 : 0;
                                      resName = val;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Enter business details..",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  color: Colors.white.withOpacity(.4),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      flag[5] = 0;
                                      if (val.isEmpty) {
                                        flag[5] = 1;
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('upi'),
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.text,
                                    decoration: textField.copyWith(
                                      labelText: "Upi ID",
                                      labelStyle: TextStyle(
                                        color: Colors.black.withOpacity(.35),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.monetization_on,
                                        color: flag[5] == 1
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                    validator: (val) {
                                      flag[5] = val.isEmpty ? 1 : 0;
                                      upi = val;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Tell us where it is located..",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  color: Colors.white.withOpacity(.4),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      flag[1] = 0;
                                      if (val.isEmpty) {
                                        flag[1] = 1;
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('buildingname'),
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.streetAddress,
                                    decoration: textField.copyWith(
                                      labelText:
                                          "Building info (number, floor etc.)",
                                      labelStyle: TextStyle(
                                        color: Colors.black.withOpacity(.35),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.business,
                                        color: flag[1] == 1
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                    validator: (val) {
                                      flag[1] = val.isEmpty ? 1 : 0;
                                      building = val;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  color: Colors.white.withOpacity(.4),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      flag[2] = 0;
                                      if (val.isEmpty) {
                                        flag[2] = 1;
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('streetname'),
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.streetAddress,
                                    decoration: textField.copyWith(
                                      labelText: "Street name",
                                      labelStyle: TextStyle(
                                        color: Colors.black.withOpacity(.35),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.streetview,
                                        color: flag[2] == 1
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                    validator: (val) {
                                      flag[2] = val.isEmpty ? 1 : 0;
                                      street = val;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  color: Colors.white.withOpacity(.4),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      flag[3] = 0;
                                      if (val.isEmpty) {
                                        flag[3] = 1;
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('cityname'),
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.text,
                                    decoration: textField.copyWith(
                                      labelText: "City ",
                                      labelStyle: TextStyle(
                                        color: Colors.black.withOpacity(.35),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.location_city,
                                        color: flag[3] == 1
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                    validator: (val) {
                                      flag[3] = val.isEmpty ? 1 : 0;
                                      city = val;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      color: Colors.white.withOpacity(.4),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          flag[4] = 0;
                                          if (val.isEmpty) {
                                            flag[4] = 1;
                                          }
                                          return null;
                                        },
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        key: ValueKey('statename'),
                                        onEditingComplete: () =>
                                            node.nextFocus(),
                                        keyboardType: TextInputType.text,
                                        decoration: textField.copyWith(
                                          labelText: "State",
                                          labelStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(.35),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.room,
                                            color: flag[4] == 1
                                                ? Colors.red
                                                : Colors.black87,
                                          ),
                                        ),
                                        validator: (val) {
                                          flag[4] = val.isEmpty ? 1 : 0;
                                          state = val;
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .34,
                                      color: Colors.white.withOpacity(.4),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          flag[5] = 0;
                                          if (val.isEmpty) {
                                            flag[5] = 1;
                                          }
                                          return null;
                                        },
                                        maxLength: 6,
                                        textInputAction: TextInputAction.done,
                                        key: ValueKey('pincode'),
                                        onEditingComplete: () => node.unfocus(),
                                        keyboardType: TextInputType.phone,
                                        decoration: textField.copyWith(
                                          counterText: "",
                                          labelText: "Pincode",
                                          labelStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(.35),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.pin_drop,
                                            color: flag[5] == 1
                                                ? Colors.red
                                                : Colors.black87,
                                          ),
                                        ),
                                        validator: (val) {
                                          flag[5] = val.isEmpty
                                              ? 1
                                              : val.length < 6
                                                  ? 1
                                                  : 0;
                                          pincode = val;
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        flag1
                            ? "Please fill all the fields with valid info"
                            : "",
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            child: loading
                                ? SpinKitFadingCircle(
                                    color: Colors.black,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.arrow_forward_ios,
                                  ),
                            onPressed: () {
                              _formkey.currentState.validate();
                              setState(() {
                                loading = true;
                              });
                              FocusScope.of(context).unfocus();
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                setState(() {
                                  loading = false;
                                  if (flag.reduce((a, b) => a + b) == 0) {
                                    flag1 = false;
                                    _formkey.currentState.save();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return TnC(
                                          city: city,
                                          street: street,
                                          resName: resName,
                                          pincode: pincode,
                                          state: state,
                                          building: building,
                                          name: name,
                                          phone: phone,
                                          email: email,
                                          upi: upi,
                                        );
                                      },
                                    );
                                  } else {
                                    flag1 = true;
                                  }
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
