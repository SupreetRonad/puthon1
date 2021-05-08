import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '/shared/textField.dart';

var email, pass, confirm_pass, temp_variable;

var flag = [0, 0, 0];

var f='sss';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false;
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  bool _isLoading = false;
  String deviceToken = '';

  void _trySubmit(String email, String password, bool isLogin,
      BuildContext ctx) async {

    UserCredential _userCreds;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _userCreds = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        await FirebaseMessaging.instance.getToken().then((token) async {
          deviceToken = token;
          await _store
              .collection('users')
              .doc(_userCreds.user.uid)
              .update({'deviceToken': deviceToken});
        });
      } else {
        _userCreds = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseMessaging.instance.getToken().then((token) async {
          deviceToken = token;
          await _store.collection('users').doc(_userCreds.user.uid).set({
            'uid': _userCreds.user.uid,
            'deviceToken': deviceToken,
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
    return Scaffold(
      //backgroundColor: Color(#e8a87c),
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    child: Lottie.asset('assets/animations/login1.json'),
                  ),
                  Text(
                    "Welcome !",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 10,
                    //color: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                      decoration: textField.copyWith(
                        labelText: "Email",
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black87,
                        ),
                      ),
                      validator: (val) {
                        if (val == null) {
                          flag[0] = 1;
                          return null;
                        }
                        flag[0] = 0;
                        return null;
                      },
                      onSaved: (String val) {
                        email = val;
                      },
                    ),
                  ),
                  flag[0] == 1
                      ? Text(
                          "Please enter email",
                          style: TextStyle(color: Colors.red),
                        )
                      : SizedBox(height: 10),
                  Card(
                    elevation: 10,
                    //color: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextFormField(
                      textInputAction: !isLogin
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onEditingComplete: () => !isLogin ? node.nextFocus() : node.unfocus(),
                      decoration: textField.copyWith(
                        labelText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black87,
                        ),
                      ),
                      obscureText: true,
                      validator: (val) {
                        if (val == null) {
                          flag[1] = 1;
                          return null;
                        }
                        flag[1] = 0;
                        return null;
                      },
                      onSaved: (String val) {
                        pass = val;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  if (!isLogin)
                    Card(
                      elevation: 10,
                      //color: Colors.tealAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () => node.unfocus(),
                        obscureText: true,
                        decoration: textField.copyWith(
                          labelText: "Confirm Password",
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black87,
                          ),
                        ),
                        validator: (val) {
                          if (val == null) {
                            flag[2] = 1;
                            return null;
                          } else if (val != pass) {
                            flag[2] = 2;
                          }
                          flag[2] = 0;
                          return null;
                        },
                        onChanged: (val) {
                          confirm_pass = pass;
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
                                  onPressed: () {
                                    var f = 0;
                                    _formkey.currentState.validate();

                                    _trySubmit(email, confirm_pass, false, context);
                                    // for (var i = 0; i < 3; i++) {
                                    //   if (flag[i] != 0) {
                                    //     f = 1;
                                    //   }
                                    // }

                                    // if (f == 0) {
                                    //   Navigator.pop(context);
                                    //   Navigator.push(
                                    //     context,
                                    //     PageTransition(
                                    //       type: PageTransitionType.fade,
                                    //       child: DetailScreen(),
                                    //     ),
                                    //   );
                                    // }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  onPressed: () {
                                    var f = 0;
                                    _formkey.currentState.validate();

                                    _trySubmit(email, confirm_pass, true, context);
                                    // for (var i = 0; i < 3; i++) {
                                    //   if (flag[i] != 0) {
                                    //     f = 1;
                                    //   }
                                    // }

                                    _formkey.currentState.save();
                                  },
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: !isLogin ? 30 : 110),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(!isLogin
                          ? "Already registered ? "
                          : "Don't have an account ? "),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            !isLogin ? "Login" : "Register",
                            style: TextStyle(color: Colors.amber),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
