import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:puthon/Screens/User/homeScreen.dart';
import 'package:puthon/Shared/confirmBox.dart';
import 'package:puthon/Shared/successBox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cartCard.dart';

SharedPreferences prefs;

class CartButton extends StatefulWidget {
  final Function refresh;
  static Map<String, int> orderList = {};
  CartButton({this.refresh});
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
        sum += (prefs.getInt(HomeScreen.list[i]) *
            int.parse(prefs.getString(HomeScreen.list[i] + "1")));
        CartButton.orderList[HomeScreen.list[i]] =
            prefs.getInt(HomeScreen.list[i]);
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
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Cart",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close))
              ],
            ),
          ),
          Container(
            child: loading
                ? SpinKitWave(
                    color: Colors.black87,
                  )
                : HomeScreen.list.length == 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Lottie.asset(
                            "assets/animations/empty.json",
                            height: 150,
                            //repeat: false,
                          ),
                          Text(
                            "Cart is empty",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: ListView.builder(
                          itemExtent: 90.0,
                          itemCount: HomeScreen.list.length,
                          itemBuilder: (BuildContext context, int index) {
                            var qty =
                                prefs.getInt("${HomeScreen.list[index]}") ?? 0;
                            // var qty = 0;
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
          SizedBox(
            height: 10,
          ),
          if (HomeScreen.list.length != 0)
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total : ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      "Rs. " + sum.toString(),
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.green[300],
                    textStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmBox(
                          b1: "Go Back",
                          b2: "Confirm",
                          color: Colors.green[300],
                          message: Text("Do you want to place order ?"),
                          height: 120,
                          function: () async {
                            var orderNo = prefs.getInt("orderNo") ?? 0;
                            orderNo++;
                            prefs.setInt("orderNo", orderNo);
                            await FirebaseFirestore.instance
                                .collection('admins')
                                .doc(HomeScreen.resId)
                                .collection('activeOrders')
                                .doc(DateTime.now().toString())
                                .update({
                              "customerId":
                                  FirebaseAuth.instance.currentUser.uid,
                              "orderNo": FirebaseAuth.instance.currentUser.uid +
                                  orderNo.toString(),
                            });
                            await FirebaseFirestore.instance
                                .collection('orders')
                                .doc(HomeScreen.resId)
                                .collection(
                                    FirebaseAuth.instance.currentUser.uid)
                                .doc(FirebaseAuth.instance.currentUser.uid +
                                    orderNo.toString())
                                .set({
                              "total": sum,
                              "tableNo": HomeScreen.table,
                              "orderList": CartButton.orderList
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                            for (var i = 0; i < HomeScreen.list.length; i++) {
                              prefs.remove(HomeScreen.list[i]);
                              prefs.remove(HomeScreen.list[i] + "1");
                              prefs.remove(HomeScreen.list[i] + "2");
                            }
                            HomeScreen.list = [];
                            prefs.setStringList("orderList", []);
                            CartButton.orderList = {};
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SuccessBox(
                                  title: "Order Successfully Placed",
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
                      Text(
                        "Place Order",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(width: 15),
              ],
            ),
        ],
      ),
    );
  }
}
