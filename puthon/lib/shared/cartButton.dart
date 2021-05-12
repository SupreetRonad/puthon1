import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CartButton extends StatefulWidget {
  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool cart = false;
  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            cart
                ? Container(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width * .65,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var i = 0; i < 20; i++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                  height: 20,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red[400],
                onPrimary: Colors.white,
                shadowColor: Colors.red,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                )
              ),
              onPressed: () {
                setState(() {
                  cart = !cart;
                });
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: cart
                    ? Icon(
                        Icons.close,
                        size: 20,
                      )
                    : Icon(
                        Icons.shopping_cart,
                        size: 20,
                      ),
              ),
            ),
          ],
        );
  }
}