import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:puthon/Shared/orderCard.dart';

class AdminTables extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('admins')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("tables")
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitFadingCircle(
              color: Colors.black54,
              size: 20,
            );
          }
          if (!snapshot.hasData) {
            return const Text(
              "No Tables occupied yet...",
              style: TextStyle(fontSize: 20),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                    bottom: kFloatingActionButtonMargin + 60),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var table = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      showMaterialModalBottomSheet(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (context) => TablesInfo(
                          customerId: table['customerId'],
                          tableNo: table['table'],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              table['table'],
                              style: GoogleFonts.righteous(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class TablesInfo extends StatefulWidget {
  final customerId, tableNo;
  TablesInfo({this.customerId, this.tableNo});

  @override
  _TablesInfoState createState() => _TablesInfoState();
}

class _TablesInfoState extends State<TablesInfo> {
  var bill, timeEntered, hh, mm, date, hh1, gg, time;
  bool loading = true;

  void init() async {    
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.customerId)
        .get()
        .then((value) {
      if (value.exists) {
        bill = value['total'];
        timeEntered = value['timeEntered'].toDate().toString().split(" ");
        date = timeEntered[0];
        time = timeEntered[1].split(":");
        mm = hh = int.parse(time[1]);
        hh = int.parse(time[0]);
        hh1 = hh > 12
            ? hh - 12
            : hh == 0
                ? 12
                : hh;
        gg = hh >= 12 ? "pm" : "am";
      }
    });
    setState(() {
      loading = false;
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
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.customerId)
            .collection(widget.customerId)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitFadingCircle(
              size: 15,
              color: Colors.black,
            );
          }
          if (!snapshot.hasData) {
            return const Text("No orders placed");
          }

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 160,
            ),
            child: loading
                ? const SpinKitFadingCircle(
                    size: 20,
                    color: Colors.black54,
                  )
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.tableNo,
                              style: GoogleFonts.righteous(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Entered at  ",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            Text(
                              hh1.toString() + " : " + mm.toString() + " " + gg,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              "Total Rs. ",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            Text(
                              bill.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var or = snapshot.data
                                  .docs[snapshot.data.docs.length - index - 1];
                              return OrderCard(
                                order: or,
                                timeStamp: or["timeStamp"],
                                cookOrder: false,
                                acceptedOrder: false,
                              );
                            }),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
