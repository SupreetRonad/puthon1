import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '/shared/textField.dart';

var email, pass, confirm_pass;

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
              .update({'deviceToken': deviceToken});
        });
      } else {
        _userCreds = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[400], Colors.purple[300]],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: BackButton(color: Colors.blue),
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35, 10, 35, 0),
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
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        key: ValueKey('email'),
                        onEditingComplete: () => node.nextFocus(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: textField.copyWith(
                          labelText: "Email",
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black87,
                          ),
                        ),
                        
                        validator: (val) =>
                            val.isEmpty ? "Enter your Username" : null,
                        onSaved: (val) {
                          setState(() => email = val);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        key: ValueKey('password'),
                        textInputAction: !isLogin
                            ? TextInputAction.next
                            : TextInputAction.done,
                        onEditingComplete: () =>
                            !isLogin ? node.nextFocus() : node.unfocus(),
                        keyboardType: TextInputType.text,
                        decoration: textField.copyWith(
                          hintText: "Password",
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black87,
                          ),
                        ),
                        obscureText: true,
                        validator: (val) => val.isEmpty || val.length < 6
                            ? "Enter your Password not less than 6 characters"
                            : null,
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
                          textInputAction: TextInputAction.done,
                          key: ValueKey('confirmPassword'),
                          onEditingComplete: () => node.unfocus(),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: textField.copyWith(
                            labelText: "Confirm Password",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (val) => confirm_pass == pass
                              ? "Confirm your Password"
                              : null,
                          onChanged: (val) {
                            setState(() => confirm_pass = val);
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
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : !isLogin
                                    ? TextButton(
                                        onPressed: () {
                                          _formkey.currentState.validate();
                                          _formkey.currentState.save();
                                          _trySubmit(email, confirm_pass, false,
                                              context);
                                        },
                                        child: Row(
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
                                        onPressed: () {
                                          _formkey.currentState.validate();
                                          _formkey.currentState.save();
                                          _trySubmit(
                                              email, pass, true, context);
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
      ),
    );
  }
}