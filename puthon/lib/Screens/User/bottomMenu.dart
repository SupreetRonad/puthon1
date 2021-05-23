import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Shared/orderCard.dart';
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

var loading = true;

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
      //backdropEnabled: true,
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
                              color: Colors.white70,
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
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.orange[600],
                        elevation: 20,
                        primary: Colors.white.withOpacity(.7),
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
                      child: Text(
                        "Pay & Exit",
                        style: TextStyle(color: Colors.green[400]),
                      ),
                    ),
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
                          Container(
                            height:
                                MediaQuery.of(context).size.height * .8 - 54,
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
