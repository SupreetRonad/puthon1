import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Screens/divergeScreen.dart';
import 'package:puthon/shared/showMsg.dart';
import 'dart:ui';
import '/shared/textField.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false;
  final _store = FirebaseFirestore.instance;
  bool _isLoading = false;

  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();

  void _trySubmit(
    bool isLogin,
    BuildContext ctx,
  ) async {
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
        _userCreds = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _pass.text.trim(),
        );

        // await _store.collection('users').doc(_userCreds.user!.uid).update(
        //   {'register': false},
        // );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (builder) => DivergeScreen(),
          ),
        );
      } else {
        _userCreds = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _pass.text.trim(),
        );

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
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (builder) => DivergeScreen(),
          ),
        );
      }
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/amber1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PUTHON",
                        style: GoogleFonts.righteous(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * .040,
                            color: Colors.white),
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
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .025,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    color: Colors.white.withOpacity(.0),
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
                        SizedBox(
                          height: 20,
                        ),
                        CField(
                          controller: _pass,
                          preIcon: Icons.lock,
                          label: 'Password',
                          bgColor: Colors.white.withOpacity(.6),
                          hidden: true,
                        ),
                        SizedBox(height: 20),
                        if (!isLogin)
                          CField(
                            controller: _confirmPass,
                            preIcon: Icons.lock,
                            label: 'Confirm password',
                            bgColor: Colors.white.withOpacity(.6),
                            hidden: true,
                          ),
                        SizedBox(height: !isLogin ? 20 : 0),
                        Row(
                          children: [
                            Spacer(),
                            Container(
                              height: 60,
                              width: !isLogin ? 160 : 80,
                              child: Card(
                                shadowColor: Colors.amber.withOpacity(.5),
                                color: Colors.amber.withOpacity(1),
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: !isLogin
                                    ? TextButton(
                                        onPressed: _isLoading
                                            ? null
                                            : () {
                                                _trySubmit(
                                                  false,
                                                  context,
                                                );
                                              },
                                        child: _isLoading
                                            ? SpinKitFadingCircle(
                                                color: Colors.white,
                                                size: 20.0,
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Register  ",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                      )
                                    : TextButton(
                                        onPressed: _isLoading
                                            ? null
                                            : () {
                                                _trySubmit(
                                                  true,
                                                  context,
                                                );
                                              },
                                        child: _isLoading
                                            ? SpinKitFadingCircle(
                                                color: Colors.white,
                                                size: 20.0,
                                              )
                                            : Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                              ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
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
          ),
        ),
      ),
    );
  }

  Widget changeAuthType() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(!isLogin ? "Already registered ? " : "Don't have an account ? "),
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
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
}
