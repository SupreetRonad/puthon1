import 'dart:ui';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Screens/detailScreen.dart';
import 'package:puthon/shared/top.dart';

var name = "Name",
    email = "email@email.com",
    dob = "00/00/0000",
    phone = "1081081081",
    gender = 1;
bool _isLoading1 = true, cart = false;

class HomeScreen extends StatefulWidget {
  final uid;
  HomeScreen({this.uid});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void readData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((value) {
      if (value.exists) {
        //print('Document exists on the database');
        // print(value.data()["name"]);
        setState(() {
          name = value.data()["name"];
          phone = value.data()["phone"];
          dob = value.data()["dob"];
          gender = value.data()["gender"];
          email = value.data()["email"];
        });
      }
    });
    _isLoading1 = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readData();
  }

  @override
  Widget build(BuildContext context) {
    Top.fromHome = 1;
    return Container(
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            cart
                ? Container(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width * .65,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var i = 0; i < 20; i++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                  height: 20,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red[400],
                onPrimary: Colors.white,
                shadowColor: Colors.red,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                )
              ),
              onPressed: () {
                setState(() {
                  cart = !cart;
                });
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: cart
                    ? Icon(
                        Icons.close,
                        size: 20,
                      )
                    : Icon(
                        Icons.shopping_cart,
                        size: 20,
                      ),
              ),
            ),
          ],
        ),
        endDrawer: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 10, 0),
            child: Column(
              children: [
                Container(
                  height: 500,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Drawer(
                      elevation: 10,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailScreen(uid: widget.uid)),
                              );
                            },
                            child: _isLoading1
                                ? Container(
                                    color: Colors.grey[400],
                                    height: 140,
                                    child: SpinKitWave(
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[400],
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 15),
                                        Container(
                                          width: 110,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.yellow,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Image.asset(
                                              gender == 1
                                                  ? "assets/female2.png"
                                                  : "assets/male2.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  minWidth: 100, maxWidth: 150),
                                              child: Text(
                                                name ?? 'Name',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              email ?? 'email@email.com',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.list_alt,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "  My Orders",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 250,
                                ),
                                Row(
                                  children: [
                                    Spacer(),
                                    Container(
                                      width: 110,
                                      decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(.7),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: TextButton(
                                          onPressed: () {
                                            _confirm(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.exit_to_app_rounded,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "  Log out",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              SizedBox(
                width: 0,
              ),
              Text("PUTHON"),
              Spacer(),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.menu),
              // )
            ],
          ),
        ),
        body: Center(),
      ),
    );
  }

  void _confirm(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Container(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 120,
                    width: 320,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Do you really want to "),
                            Text(
                              "Log out ?",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Go back"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 110,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.red[300],
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    if (Top.fromDetail == 1) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(
                                    "Log out",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
