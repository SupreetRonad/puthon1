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
        //height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 12,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Icon(
                        Icons.radio_button_checked,
                        color: widget.veg ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 270),
                        width: MediaQuery.of(context).size.width * 0.55,
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
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 15, 5),
                        child: Text(
                          "Rs. " +
                              (int.parse(widget.price) * widget.quantity)
                                  .toString(),
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width - 12,
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(45, 0, 0, 5),
                          child: Text(
                            "Rs. " + widget.price,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.fromLTRB(45, 0, 15, 5),
                          child: Text(
                            "x " + widget.quantity.toString(),
                            style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 1,
                      color: Colors.black12,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
