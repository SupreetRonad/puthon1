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
    return Container(
      
    );
  }
}