import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/shared/loadingScreen.dart';

class OrdersHistory extends StatelessWidget {
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
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text("Order History"),
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('history')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _loading();
              }
              if (!snapshot.hasData || snapshot.hasError) {
                return const Center(
                  child: Text(
                    "You haven't finished any orders...",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              }

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var order =
                      snapshot.data.docs[snapshot.data.docs.length - index - 1];
                  var timeEntered =
                      order['timeEntered'].toDate().toString().split(" ");
                  var date = timeEntered[0];
                  var time = timeEntered[1].split(":");
                  var hh = int.parse(time[0]);
                  var hh1 = hh > 12
                      ? hh - 12
                      : hh == 0
                          ? 12
                          : hh;
                  var gg = hh >= 12 ? "pm" : "am";
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.white60,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 180,
                                  child: Text(
                                    order['resName'],
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Text(
                                        hh1.toString() +
                                            " : " +
                                            time[1] +
                                            " " +
                                            gg,
                                        style: GoogleFonts.raleway(
                                          color: Colors.black54,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(date,
                                        style: GoogleFonts.raleway(
                                          color: Colors.black45,
                                          fontSize: 14,
                                          //fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            const Divider(),
                            for (var item in order['orderList'].keys)
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: order['orderList'][item][1]
                                          ? Colors.green[300]
                                          : Colors.red[300],
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        item,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text("x " +
                                        order['orderList'][item][0].toString()),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            const Divider(),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Rs. " + order['total'].toString(),
                                  style: TextStyle(
                                    color: Colors.green[300],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _loading() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitFadingCircle(
            color: Colors.black,
            size: 40,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Loading...",
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      );
}
