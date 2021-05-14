import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import '/shared/textField.dart';

// ignore: non_constant_identifier_names
var email, pass, confirm_pass;
var flag = [0, 0, 0];

bool match = false;

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false;
  final _store = FirebaseFirestore.instance;
  bool _isLoading = false;
  String deviceToken = '';

  void _trySubmit(
      String email, String password, bool isLogin, BuildContext ctx) async {
    UserCredential _userCreds;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _userCreds = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        await FirebaseMessaging.instance.getToken().then((token) async {
          deviceToken = token;
          await _store
              .collection('users')
              .doc(_userCreds.user.uid)
              .update({'deviceToken': deviceToken, 'register': false});
        });
      } else {
        _userCreds = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseMessaging.instance.getToken().then((token) async {
          deviceToken = token;
          await _store.collection('users').doc(_userCreds.user.uid).set({
            'uid': _userCreds.user.uid,
            'email': _userCreds.user.email,
            'register': true,
            'deviceToken': deviceToken,
            'name': null,
            'phone': null,
            'dob': '2000-01-01',
            'gender': 1,
            'admin': false,
            'cook': false
          });
        });
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your credentials';

      if (err.message != null) {
        message = err.message;
      }
      setState(() {
        _isLoading = false;
      });
      print(message);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
        ),
      );
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35, 5, 35, 0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * .3,
                        child: Lottie.asset('assets/animations/login1.json'),
                      ),
                    ),
                    Text(
                      "PUTHON",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * .035,
                          color: Colors.amber),
                    ),
                    Text(
                      "Your virtual waiter..",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * .018,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .018),
                    Card(
                      //color: Colors.white.withOpacity(.7),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        onChanged: (val) {
                          flag[0] = 0;
                          setState(() {});
                        },
                        textInputAction: TextInputAction.next,
                        key: ValueKey('email'),
                        onEditingComplete: () => node.nextFocus(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: textField.copyWith(
                          labelText:
                              flag[0] == 1 ? "Please enter an Email" : "Email",
                          labelStyle: TextStyle(
                              color: flag[0] == 1
                                  ? Colors.red
                                  : Colors.black.withOpacity(.35),
                              fontSize: flag[0] == 1 ? 13 : 17),
                          prefixIcon: const Icon(
                            Icons.email,
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
                          setState(() => email = val);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        onChanged: (val) {
                          flag[1] = 0;
                          setState(() {
                            pass = val;
                            flag[2] = val != confirm_pass ? 1 : 0;

                            if (val.isNotEmpty) {
                              match = val != confirm_pass ? false : true;
                            } else {
                              match = false;
                            }
                          });
                        },
                        key: ValueKey('password'),
                        textInputAction: !isLogin
                            ? TextInputAction.next
                            : TextInputAction.done,
                        onEditingComplete: () =>
                            !isLogin ? node.nextFocus() : node.unfocus(),
                        keyboardType: TextInputType.text,
                        decoration: textField.copyWith(
                          labelText: flag[1] == 1
                              ? "Enter a password with length 6 or more"
                              : "Password",
                          labelStyle: TextStyle(
                              color: flag[1] == 1
                                  ? Colors.red
                                  : Colors.black.withOpacity(.35),
                              fontSize: flag[1] == 1 ? 13 : 17),
                          prefixIcon: Icon(
                            Icons.lock,
                            color:
                                match == true ? Colors.green : Colors.black87,
                          ),
                        ),
                        obscureText: true,
                        validator: (val) {
                          if (val.isNotEmpty) {
                            setState(() {
                              flag[1] = val.length < 6 ? 1 : 0;
                            });
                            return null;
                          }

                          setState(() {
                            flag[1] = 0;
                          });
                          return null;
                        },
                        onSaved: (val) {
                          setState(() => pass = val);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    if (!isLogin)
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextFormField(
                          onChanged: (val) {
                            flag[2] = 0;
                            setState(() {
                              confirm_pass = val;
                              flag[2] = val != pass ? 1 : 0;
                              if (val.isNotEmpty && confirm_pass.isNotEmpty) {
                                match = val != pass ? false : true;
                              } else {
                                match = false;
                              }
                            });
                          },
                          textInputAction: TextInputAction.done,
                          key: ValueKey('confirmPassword'),
                          onEditingComplete: () => node.unfocus(),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: textField.copyWith(
                            labelText: flag[2] == 1
                                ? "Passwords do not match"
                                : "Confirm Password",
                            labelStyle: TextStyle(
                                color: flag[2] == 1
                                    ? Colors.red
                                    : Colors.black.withOpacity(.35),
                                fontSize: flag[2] == 1 ? 13 : 17),
                            prefixIcon: Icon(
                              Icons.lock,
                              color:
                                  match == true ? Colors.green : Colors.black87,
                            ),
                          ),
                          validator: (val) {
                            if (val.isNotEmpty && confirm_pass.isNotEmpty) {
                              setState(() {
                                flag[2] = val != pass ? 1 : 0;
                              });
                              return null;
                            }
                            flag[2] = 0;
                            setState(() {});
                            return null;
                          },
                        ),
                      ),
                    SizedBox(height: !isLogin ? 10 : 0),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          height: 60,
                          width: !isLogin ? 160 : 80,
                          child: Card(
                            color: Colors.amber[400].withOpacity(.9),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: !isLogin
                                ? TextButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            final _isValid = _formkey
                                                .currentState
                                                .validate();
                                            FocusScope.of(context).unfocus();
                                            if (_isValid) {
                                              _formkey.currentState.save();
                                              _trySubmit(email, confirm_pass,
                                                  false, context);
                                              match = false;
                                            }
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
                                            final _isValid = _formkey
                                                .currentState
                                                .validate();
                                            FocusScope.of(context).unfocus();
                                            if (_isValid) {
                                              _formkey.currentState.save();
                                              _trySubmit(
                                                  email, pass, true, context);
                                              flag[2] = 0;
                                              pass = null;
                                            }
                                          },
                                    child: _isLoading
                                        ? SpinKitWave(
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
                    SizedBox(height: !isLogin ? 30 : 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(!isLogin
                            ? "Already registered ? "
                            : "Don't have an account ? "),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                flag[0] = 0;
                                flag[1] = 0;
                                flag[2] = 0;
                                match = false;
                                confirm_pass = null;
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(
                              !isLogin ? "Login" : "Register",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .03)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
