import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:puthon/Screens/User/homeScreen.dart';
import 'package:puthon/Shared/confirmBox.dart';
import 'package:puthon/Shared/loading.dart';
import 'package:puthon/Shared/successBox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cartCard.dart';

late SharedPreferences prefs;

class CartButton extends StatefulWidget {
  final Function refresh;
  static Map<String, List> orderList = {};
  CartButton({required this.refresh});
  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  final bool cart = false;
  bool loading = true;
  var sum = 0.0;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = false;
      sum = 0;
      for (var i = 0; i < HomeScreen.list.length; i++) {
        sum += (prefs.getInt(HomeScreen.list[i])! *
            int.parse(prefs.getString(HomeScreen.list[i] + "1")!));
        CartButton.orderList[HomeScreen.list[i]] = [
          prefs.getInt(HomeScreen.list[i]),
          prefs.getBool(HomeScreen.list[i] + "2")
        ];
      }
    });
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.shopping_cart),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Cart",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
          ),
          Container(
            child: loading
                ? const SpinKitFadingCircle(
                    color: Colors.black87,
                  )
                : HomeScreen.list.length == 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Lottie.asset(
                            "assets/animations/empty.json",
                            height: 150,
                            //repeat: false,
                          ),
                          const Text(
                            "Cart is empty",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      )
                    : Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemExtent: 90.0,
                          itemCount: HomeScreen.list.length,
                          itemBuilder: (BuildContext context, int index) {
                            var qty =
                                prefs.getInt("${HomeScreen.list[index]}") ?? 0;
                            var price =
                                prefs.getString("${HomeScreen.list[index]}1") ??
                                    "";
                            var veg =
                                prefs.getBool("${HomeScreen.list[index]}2") ??
                                    true;
                            return CartCard(
                              itemName: HomeScreen.list[index],
                              price: price,
                              quantity: qty,
                              veg: veg,
                            );
                          },
                        ),
                      ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (HomeScreen.list.length != 0)
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total : ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      "Rs. " + sum.toString(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Please wait...");
                      }
                      if (!snapshot.hasData || snapshot.hasError) {
                        return const Center(
                          child: Text(
                            "Please wait...",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        );
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          primary: snapshot.data['ordered']
                              ? Colors.grey[300]
                              : Colors.green[300],
                          textStyle: const TextStyle(color: Colors.white),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: snapshot.data['ordered']
                            ? () {
                                Fluttertoast.showToast(
                                  msg:
                                      "Please wait until your previous order arrives",
                                  gravity: ToastGravity.SNACKBAR,
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                              }
                            : () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmBox(
                                      b1: "Go Back",
                                      b2: "Confirm",
                                      color: [
                                        Colors.greenAccent,
                                        Colors.green[300]!,
                                      ],
                                      message: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Place order ?",
                                              style: GoogleFonts.roboto(
                                                fontSize: 20,
                                                color: Colors.greenAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Divider(),
                                            Text(
                                              "Do you want to place your order ?",
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "(Please check your cart again and confirm.)",
                                              style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                color: Colors.black54,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      height: 160,
                                      function: () async {
                                        Loading(context);

                                        var orderNo =
                                            prefs.getInt("orderNo") ?? 0;
                                        orderNo++;
                                        var timeStamp =
                                            Timestamp.now().toString();
                                        await FirebaseFirestore.instance
                                            .collection('admins')
                                            .doc(HomeScreen.resId)
                                            .collection('activeOrders')
                                            .doc(timeStamp)
                                            .set({
                                          "customerId": FirebaseAuth
                                              .instance.currentUser!.uid,
                                          "orderNo": FirebaseAuth
                                                  .instance.currentUser!.uid +
                                              orderNo.toString(),
                                          "timeStamp": timeStamp,
                                          "flag": 0,
                                          "duration": "0"
                                        });
                                        var hour = DateTime.now().hour > 12
                                            ? DateTime.now().hour - 12
                                            : DateTime.now().hour;
                                        var hour1 =
                                            hour < 10 ? "0${hour}" : "${hour}";
                                        var minute = DateTime.now().minute < 10
                                            ? "0${DateTime.now().minute}"
                                            : "${DateTime.now().minute}";
                                        var hh = DateTime.now().hour > 12
                                            ? "pm"
                                            : "am";
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .doc(FirebaseAuth
                                                    .instance.currentUser!.uid +
                                                orderNo.toString())
                                            .set({
                                          "total": sum,
                                          "tableNo": HomeScreen.table,
                                          "orderList": CartButton.orderList,
                                          "time": "${hour1} : ${minute} ${hh}",
                                          "flag": 0,
                                          "duration": "0",
                                          "acceptedTime":
                                              "${hour1} : ${minute} ${hh}",
                                          "timeStamp": timeStamp,
                                          "orderNo": FirebaseAuth
                                                  .instance.currentUser!.uid +
                                              orderNo.toString(),
                                          "bot": 0,
                                        });
                                        var total;
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .get()
                                            .then((value) {
                                          if (value.exists) {
                                            total = value['total'];
                                          }
                                        });
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          'ordered': true,
                                          'total': sum + total
                                        });
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          'ordered': true,
                                        });
                                        prefs.setInt("orderNo", orderNo);

                                        for (var i = 0;
                                            i < HomeScreen.list.length;
                                            i++) {
                                          prefs.remove(HomeScreen.list[i]);
                                          prefs
                                              .remove(HomeScreen.list[i] + "1");
                                          prefs
                                              .remove(HomeScreen.list[i] + "2");
                                        }
                                        HomeScreen.list = [];
                                        prefs.setStringList("orderList", []);
                                        CartButton.orderList = {};
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SuccessBox(
                                              title:
                                                  "Order Successfully Placed",
                                              msg1:
                                                  "Your order has been successfully sent to the cook.",
                                              msg2:
                                                  "Please wait while your order gets ready...",
                                            );
                                          },
                                        );
                                        widget.refresh();
                                      },
                                    );
                                  },
                                );
                                setState(() {});
                              },
                        child: Row(
                          children: [
                            const Text(
                              "Place Order",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        ),
                      );
                    }),
                const SizedBox(width: 15),
              ],
            ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
