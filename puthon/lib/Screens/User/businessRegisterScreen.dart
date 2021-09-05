import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Screens/User/tnc.dart';
import 'package:puthon/Utils/showMsg.dart';
import 'package:puthon/shared/textField.dart';

class RegisterBusiness extends StatefulWidget {
  @override
  _RegisterBusinessState createState() => _RegisterBusinessState();
}

class _RegisterBusinessState extends State<RegisterBusiness> {
  bool flag1 = false, loading = false;
  String? name, phone, email;

  TextEditingController _resName = TextEditingController();
  TextEditingController _upi = TextEditingController();
  TextEditingController _building = TextEditingController();
  TextEditingController _street = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _pincode = TextEditingController();

  void readData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          name = value.data()!["name"];
          phone = value.data()!["phone"];
          email = FirebaseAuth.instance.currentUser!.email;
        });
      }else{
        showSnack(context, 'Something went wrong!');
        Navigator.pop(context);
      }
    });
  }

  void onSubmit() {
    setState(() {
      loading = true;
    });
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        loading = false;
        if (_resName.text.isNotEmpty &&
            _upi.text.isNotEmpty &&
            _building.text.isNotEmpty &&
            _street.text.isNotEmpty &&
            _city.text.isNotEmpty &&
            _state.text.isNotEmpty &&
            _pincode.text.isNotEmpty) {
          if (!RegExp(r'^[0-9]{6}$').hasMatch(_pincode.text)) {
            showSnack(
              context,
              'Enter valid pincode!',
              color: Colors.red,
            );
            loading = false;
            setState(() {});
            return;
          }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return TnC(
                city: _city.text,
                street: _street.text,
                resName: _resName.text,
                pincode: _pincode.text,
                state: _state.text,
                building: _building.text,
                name: name,
                phone: phone,
                email: email,
                upi: _upi.text,
              );
            },
          );
        } else {
          showSnack(
            context,
            'Please fill in all the fields!',
            color: Colors.red,
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.black,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
      ),
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
                reverse: true,
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 750,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          head("Restaurant information.."),
                          const SizedBox(
                            height: 10,
                          ),
                          CField(
                            controller: _resName,
                            bgColor: Colors.white38,
                            label: 'Restaurant name',
                            preIcon: Icons.restaurant,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CField(
                            controller: _upi,
                            bgColor: Colors.white38,
                            label: 'Merchant UPI ID',
                            preIcon: Icons.monetization_on,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          head("Tell us where it is located.."),
                          const SizedBox(
                            height: 10,
                          ),
                          CField(
                            controller: _building,
                            bgColor: Colors.white38,
                            label: 'Building info (number, floor etc.)',
                            preIcon: Icons.business,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CField(
                            controller: _street,
                            bgColor: Colors.white38,
                            label: 'Street name',
                            preIcon: Icons.streetview,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CField(
                            controller: _city,
                            bgColor: Colors.white38,
                            label: 'City',
                            preIcon: Icons.location_city,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Flexible(
                                child: CField(
                                  controller: _state,
                                  bgColor: Colors.white38,
                                  label: 'State',
                                  preIcon: Icons.room,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .34,
                                child: CField(
                                  controller: _pincode,
                                  bgColor: Colors.white38,
                                  label: 'Pincode',
                                  preIcon: Icons.pin_drop,
                                  maxLen: 6,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                                  size: 20,
                                )
                              : Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black87,
                                ),
                          onPressed: onSubmit,
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
    );
  }

  Widget head(String head) => Row(
        children: [
          const Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            head,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      );
}