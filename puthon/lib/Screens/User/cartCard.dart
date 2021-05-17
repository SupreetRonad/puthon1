import 'package:flutter/material.dart';

class CartCard extends StatefulWidget {
  final itemName, price, veg, quantity;

  const CartCard({this.itemName, this.price, this.veg, this.quantity});

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(
                      Icons.radio_button_checked,
                      color: widget.veg ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        widget.itemName,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * .05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width - 12,
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(45, 0, 0, 5),
                          child: Text(
                            "Rs. " + widget.price,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.fromLTRB(45, 0, 15, 5),
                          child: Text(
                            "x " + widget.quantity.toString(),
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black54,
                  height: 10,
                  thickness: 2,
                  indent: 10,
                  endIndent: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
