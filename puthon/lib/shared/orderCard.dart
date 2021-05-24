import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Screens/User/orderTimer.dart';
import 'package:puthon/Shared/durationConfirm.dart';

class OrderCard extends StatefulWidget {
  final order, customerId, orderNo, timeStamp;
  final bool cookOrder, acceptedOrder;
  OrderCard(
      {this.order,
      this.customerId,
      this.orderNo,
      this.timeStamp,
      this.cookOrder,
      this.acceptedOrder});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool loading = false;
  var duration = 1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(20),
            ),
            height: widget.order["orderList"].length * 24.0 +
                (widget.cookOrder ? 110 : 65),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    if (widget.cookOrder)
                      Text(
                        "Table.  ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    if (widget.cookOrder)
                      Text(
                        widget.order['tableNo'].toString(),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (!widget.cookOrder)
                      OrderTimer(
                        time: widget.order['acceptedTime'],
                        duration: int.parse(widget.order['duration']),
                        flag: widget.order['flag'],
                        cookOrder: widget.cookOrder,
                      ),
                    Spacer(),
                    Text(
                      "Ordered at ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      widget.order['time'],
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Divider(),
                for (var item in widget.order['orderList'].keys)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.radio_button_checked,
                          color: widget.order['orderList'][item][1]
                              ? Colors.green[300]
                              : Colors.red[300],
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            item,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                        ),
                        Spacer(),
                        Text("x " +
                            widget.order['orderList'][item][0].toString()),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.cookOrder)
                  SizedBox(
                    height: 5,
                  ),
                Spacer(),
                if (widget.cookOrder)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: [
                        // Container(
                        //   height: 40,
                        //   width: 40,
                        //   decoration: BoxDecoration(
                        //       color: Colors.black12,
                        //       borderRadius: BorderRadius.circular(100)),
                        //   child: IconButton(
                        //     splashColor: Colors.red,
                        //     onPressed: () {
                        //       showDialog(
                        //         context: context,
                        //         builder: (BuildContext context) {
                        //           return ConfirmBox(
                        //             b1: "Go Back",
                        //             b2: "Decline",
                        //             height: 150,
                        //             color: Colors.red[300],
                        //             message:
                        //                 Text("Do you want to cancel the order ?"),
                        //             function: () async {
                        //               Navigator.pop(context);
                        //               await FirebaseFirestore.instance
                        //                   .collection('admins')
                        //                   .doc(HomeScreen.resId)
                        //                   .collection('activeOrders')
                        //                   .doc(widget.timeStamp)
                        //                   .delete();
                        //               await FirebaseFirestore.instance
                        //                   .collection('orders')
                        //                   .doc(widget.customerId)
                        //                   .collection(widget.customerId)
                        //                   .doc(widget.orderNo)
                        //                   .update({
                        //                 "flag": 1,
                        //               });
                        //             },
                        //           );
                        //         },
                        //       );
                        //     },
                        //     icon: Icon(
                        //       Icons.close,
                        //       color: Colors.red,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        Expanded(
                          child: Container(
                            height: 45,
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [Colors.white.withOpacity(.0), Colors.green[400].withOpacity(.3), Colors.green[400]]),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: TextButton(
                              //splashColor: Colors.green,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DurationConfirm(
                                      order: widget.order,
                                      timeStamp: widget.timeStamp,
                                      orderNo: widget.orderNo,
                                      customerId: widget.customerId,
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Accept",
                                    style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 10)
                                ],
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
