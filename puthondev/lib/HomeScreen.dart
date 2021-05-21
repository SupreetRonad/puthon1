import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void trySubmit(email, password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  var email, password;
  bool _isLoading = false;
  var flag = [0, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2,
            horizontal: 20,
          ),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: TextFormField(
                      onChanged: (val) {
                        flag[0] = 0;
                        setState(() {});
                      },
                      key: ValueKey("email"),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: flag[0] == 1
                                ? Colors.red
                                : Colors.black.withOpacity(.35),
                            fontSize: flag[0] == 1 ? 13 : 17),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black87,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelText: "Email",
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
                    height: 20,
                  ),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: TextFormField(
                      onChanged: (val) {
                        flag[1] = 0;
                        setState(() {});
                      },
                      key: ValueKey("email"),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: flag[1] == 1
                                ? Colors.red
                                : Colors.black.withOpacity(.35),
                            fontSize: flag[1] == 1 ? 13 : 17),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black87,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelText: "Password",
                      ),
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
                        setState(() => password = val);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                      elevation: 10,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            final _isValid = _formKey.currentState.validate();
                            FocusScope.of(context).unfocus();
                            if (_isValid) {
                              _formKey.currentState.save();
                              trySubmit(email, password);
                            }
                          },
                    child: _isLoading
                        ? SpinKitWave(
                            color: Colors.white,
                            size: 20.0,
                          )
                        : Row(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
