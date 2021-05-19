import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/Cook/orderCard.dart';
import 'package:puthon/Shared/itemCard.dart';
import 'package:puthon/Shared/loadingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'cartButton.dart';
import 'homeScreen.dart';

class BottomMenu extends StatefulWidget {
  final SharedPreferences prefs;
  final Function refresh;
  BottomMenu({this.prefs, this.refresh});
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      body: Column(
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
                      HomeScreen.resName ?? "RESTUARANT NAME 12435654324543245",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
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
                      color: Colors.orange,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.white70,
                  elevation: 10,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  for (var i = 0; i < HomeScreen.list.length; i++) {
                    prefs.remove(HomeScreen.list[i]);
                    prefs.remove(HomeScreen.list[i] + "1");
                    prefs.remove(HomeScreen.list[i] + "2");
                  }
                  HomeScreen.list = [];
                  widget.prefs.setStringList("orderList", []);
                  CartButton.orderList = {};
                  widget.prefs.setInt("orderNo", 0);
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .update({
                    'scanned': 1,
                    'resId': null,
                    'table': null,
                  });
                  scanned = 1;
                  setState(() {
                    widget.refresh();
                    cameraScanResult = null;
                  });
                },
                child: Text("Pay & Exit"),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .doc(HomeScreen.resId)
                .collection(FirebaseAuth.instance.currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              // var order =
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
              if (!snapshot.hasData || snapshot.hasError) {
                return Center(
                  child: Text(
                    "No Orders Placed...",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                          bottom: kFloatingActionButtonMargin + 160),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var order = snapshot.data.docs[index];
                        return OrderCard(
                          order: order,
                          timeStamp: order["time"],
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
      maxHeight: MediaQuery.of(context).size.height * 0.8,
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
                    return LoadingScreen();
                  }
                  if (!snapshot.hasData) {
                    return Text(
                      "No Items...",
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
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
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).size.height * .8 - 69,
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
