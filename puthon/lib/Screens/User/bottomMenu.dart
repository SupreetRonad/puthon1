import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Screens/User/menu.dart';
import 'package:puthon/Screens/User/paymentGateway.dart';
import 'package:puthon/Shared/orderCard.dart';
import 'package:puthon/Utils/infoProvider.dart';
import 'package:puthon/Utils/pagesurf.dart';
import 'package:puthon/shared/loadingScreen.dart';
import 'package:puthon/Utils/showMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomMenu extends StatefulWidget {
  final SharedPreferences prefs;
  final Function refresh;
  BottomMenu({required this.prefs, required this.refresh});
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  bool loading = true;
  String? upiId;

  void exit() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Info.uid)
        .update({'scanned': 1});

    await FirebaseFirestore.instance
        .collection('admins')
        .doc(EnteredRes.resId)
        .collection('tables')
        .doc(EnteredRes.table)
        .delete();

    EnteredRes.scanned = 1;
  }

  init() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(Info.uid)
        .get()
        .then((value) {
      if (value.exists) {
        EnteredRes.resId = value['resId'];
        EnteredRes.upiId = value['upiId'];
        EnteredRes.table = value['table'];
        EnteredRes.resName = value['resName'];
        EnteredRes.total = (value['total']);
      }
    });
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(EnteredRes.resId)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          upiId = value['upiId'];
          loading = false;
        });
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
    return SlidingUpPanel(
      backdropEnabled: true,
      backdropOpacity: 0,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      body: loading
          ? const SpinKitFadingCircle(
              color: Colors.black87,
              size: 20,
            )
          : Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    resInfo(),
                    const Spacer(),
                    payExitButton(context),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .doc(Info.uid)
                      .collection(Info.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
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
                      return const Expanded(
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
                              acceptedOrder: false,
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
      color: Colors.transparent,
      minHeight: 80,
      maxHeight: MediaQuery.of(context).size.height - 155,
      panel: loading ? LoadingScreen() : Menu(),
    );
  }

  Widget payExitButton(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc(Info.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            "Loading...",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          );
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return const SizedBox();
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
              ? exit
              : () {
                  if (!snapshot.data['ordered']) {
                    // TODO: Storing order number in cloud, as it can be overwritten in some extreme cases
                    // PayAndExit(widget.refresh);
                    pushPage(
                      context,
                      PaymentScreen(
                        amount: snapshot.data['total'],
                        refresh: widget.refresh,
                      ),
                    );
                  } else {
                    showToast(
                      "Please wait until your order gets delivered",
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
              const SizedBox(
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
      },
    );
  }

  Widget resInfo() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 125,
            child: Text(
              EnteredRes.resName ?? "RESTUARANT NAME",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Table. " + EnteredRes.table!,
            style: const TextStyle(
              color: Colors.black38,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
