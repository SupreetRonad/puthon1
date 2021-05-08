import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puthon/shared/textField.dart';

import 'addDetails.dart';

var email, pass, confirm_pass;

var flag = [0, 0, 0];

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool isLogin = false;
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
                      onEditingComplete: () => node.unfocus(),
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
                        onEditingComplete: () => node.nextFocus(),
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

                                    for (var i = 0; i < 3; i++) {
                                      if (flag[i] != 0) {
                                        f = 1;
                                      }
                                    }

                                    if (f == 0) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.fade,
                                          child: addInfo(),
                                        ),
                                      );
                                    }
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

                                    for (var i = 0; i < 3; i++) {
                                      if (flag[i] != 0) {
                                        f = 1;
                                      }
                                    }

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
