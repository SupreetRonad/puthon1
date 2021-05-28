import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Screens/User/paymentGateway.dart';
import 'package:puthon/Screens/User/paymentUPI.dart';
import 'package:puthon/Shared/orderCard.dart';
import 'package:puthon/Shared/itemCard.dart';
import 'package:puthon/Shared/loadingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'homeScreen.dart';
import 'payAndExit.dart';

class BottomMenu extends StatefulWidget {
  final SharedPreferences prefs;
  final Function refresh;
  BottomMenu({this.prefs, this.refresh});
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

var loading = true;
var upiId;

class _BottomMenuState extends State<BottomMenu> {
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          HomeScreen.resId = value['resId'];
          HomeScreen.table = value['table'];
          HomeScreen.resName = value['resName'];
          HomeScreen.total = value['total'];
          loading = false;
        });
      }
    });
    FirebaseFirestore.instance
        .collection('admins')
        .doc(HomeScreen.resId)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          upiId = value['upiId'];
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      backdropOpacity: 0,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      body: loading
          ? SpinKitWave(
              color: Colors.black87,
              size: 20,
            )
          : Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 125,
                          child: Text(
                            HomeScreen.resName ?? "RESTUARANT NAME",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Table. " + HomeScreen.table,
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            );
                          }
                          if (!snapshot.hasData || snapshot.hasError) {
                            return Center(
                              child: Text(
                                "No Active Orders...",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.white54,
                              elevation: 10,
                              primary: Colors.white.withOpacity(.7),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: snapshot.data['total'] == 0
                                ? () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .update({'scanned': 1});
                                  }
                                : () {
                                    if (!snapshot.data['ordered']) {
                                      PayAndExit(widget.prefs, widget.refresh);
                                      // TODO: Storing order number in cloud, as it can be overwritten in some extreme cases
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              // PaymentGateway(),
                                              PaymentUPI(
                                            upiId: upiId,
                                            amount: snapshot.data['total'],
                                          ),
                                        ),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg:
                                            "Please wait until your order gets delivered",
                                        gravity: ToastGravity.SNACKBAR,
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.black54,
                                        textColor: Colors.white,
                                      );
                                    }
                                  },
                            child: Row(
                              children: [
                                Icon(
                                  snapshot.data['total'] == 0
                                      ? Icons.exit_to_app
                                      : Icons.credit_card,
                                  color: Colors.green,
                                  size: 19,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.data['total'] == 0 ? "Exit" : "Pay",
                                  style: GoogleFonts.righteous(
                                    color: Colors.green,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection(FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData ||
                        snapshot.hasError ||
                        snapshot.data.docs.length == 0) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "No Orders Placed Yet...",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                              bottom: kFloatingActionButtonMargin + 160,
                            ),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              var order = snapshot.data
                                  .docs[snapshot.data.docs.length - index - 1];

                              return OrderCard(
                                order: order,
                                timeStamp: order["timeStamp"],
                                cookOrder: false,
                              );
                            }),
                      );
                    }
                  },
                ),
              ],
            ),
      color: Colors.transparent,
      minHeight: 80,
      maxHeight: MediaQuery.of(context).size.height - 155,
      panel: Container(
        width: double.infinity,
        child: scanned != 2
            ? LoadingScreen()
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admins')
                    .doc(HomeScreen.resId)
                    .collection('menu')
                    .orderBy('category')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitWave(
                      color: Colors.green,
                      size: 20,
                    );
                  }
                  if (!snapshot.hasData) {
                    return Text(
                      "No Items...",
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 20, 0, 5),
                            height: 4,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border: Border.all(
                                color: Colors.black.withOpacity(.1),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Menu",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  bottom: kFloatingActionButtonMargin + 60),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = snapshot.data.docs[index];
                                return !item['inMenu']
                                    ? SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 0),
                                        child: ItemCard(
                                          item: item,
                                          order: true,
                                        ),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }
}
