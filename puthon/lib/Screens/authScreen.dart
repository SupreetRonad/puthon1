import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Screens/divergeScreen.dart';
import 'package:puthon/Utils/pagesurf.dart';
import 'package:puthon/Utils/showMsg.dart';
import 'dart:ui';
import '/shared/textField.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _store = FirebaseFirestore.instance;
  bool _isLoading = false;

  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();

  void _trySubmit(bool isLogin, BuildContext ctx) async {
    String message = 'Something went wrong!';

    if (_email.text.isEmpty ||
        _pass.text.isEmpty ||
        (!isLogin && _confirmPass.text.isEmpty)) {
      message = 'Please fill in all the fields!';
      showSnack(
        context,
        message,
        color: Colors.red,
      );
      return;
    } else if (!isLogin && (_pass.text != _confirmPass.text)) {
      message = 'Passwords do not match!';
      showSnack(
        context,
        message,
        color: Colors.red,
      );
      return;
    }

    UserCredential _userCreds;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        try {
          _userCreds = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text.trim(),
            password: _pass.text.trim(),
          );
        } catch (e) {
          log(e.toString());
          message = e.toString().split('] ')[1];
          if (message.contains('invalid')) {
            message = 'Invalid credentials!';
          } else {
            message = 'Something went wrong!';
          }
          showSnack(
            context,
            message,
            color: Colors.red,
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      } else {
        try {
          _userCreds =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.text.trim(),
            password: _pass.text.trim(),
          );
        } catch (e) {
          message = e.toString().split('] ')[1];
          if (message.contains('already in use')) {
            message = 'Email address aready in use!';
          } else {
            message = 'Something went wrong!';
          }
          showSnack(
            context,
            message,
            color: Colors.red,
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        await _store.collection('users').doc(_userCreds.user!.uid).set({
          'uid': _userCreds.user!.uid,
          'email': _userCreds.user!.email,
          'register': true,
          'name': null,
          'phone': null,
          'dob': '2000-01-01',
          'gender': 1,
          'admin': false,
          'cook': false,
          'orderNo': null,
          'cooking': false,
          'scanned': 1,
          'resId': null,
        });
      }
      replacePage(context, DivergeScreen());
    } catch (err) {
      showSnack(
        context,
        message,
        color: Colors.red,
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/amber1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            heading(context),
            SizedBox(
              height: MediaQuery.of(context).size.height * .025,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .018,
                  ),
                  CField(
                    controller: _email,
                    preIcon: Icons.email,
                    label: 'Email',
                    bgColor: Colors.white.withOpacity(.6),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CField(
                    controller: _pass,
                    preIcon: Icons.lock,
                    label: 'Password',
                    bgColor: Colors.white.withOpacity(.6),
                    hidden: true,
                  ),
                  const SizedBox(height: 20),
                  if (!isLogin)
                    CField(
                      controller: _confirmPass,
                      preIcon: Icons.lock,
                      label: 'Confirm password',
                      bgColor: Colors.white.withOpacity(.6),
                      hidden: true,
                    ),
                  SizedBox(height: !isLogin ? 20 : 0),
                  authButton(),
                  const SizedBox(height: 30),
                  changeAuthType(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget authButton() => Row(
        children: [
          const Spacer(),
          _isLoading
              ? SizedBox(
                  width: 80,
                  child: const SpinKitFadingCircle(
                    color: Colors.white,
                    size: 20.0,
                  ),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          _trySubmit(
                            !isLogin ? false : true,
                            context,
                          );
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isLogin)
                        const Text(
                          "Register  ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
        ],
      );

  Widget heading(context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "PUTHON",
            style: GoogleFonts.righteous(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * .050,
              color: Colors.white,
            ),
          ),
          Text(
            "Your virtual waiter..",
            style: GoogleFonts.raleway(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * .017,
            ),
          ),
        ],
      );

  Widget changeAuthType() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            !isLogin ? "Already registered ? " : "Don't have an account ? ",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _email.clear();
                _pass.clear();
                _confirmPass.clear();
                isLogin = !isLogin;
              });
            },
            child: Text(
              !isLogin ? "Login" : "Register",
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
}
