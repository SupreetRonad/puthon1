import 'dart:ui';

import 'package:flutter/material.dart';

class ConfirmBox extends StatelessWidget {
  final String b1, b2;
  final Widget message;
  final List<Color> color;
  final Function function;
  final double height;
  ConfirmBox({
    required this.b1,
    required this.b2,
    required this.color,
    required this.message,
    required this.function,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10.0,
        sigmaY: 10.0,
      ),
      child: Container(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          child: SizedBox(
            height: height,
            width: MediaQuery.of(context).size.width - 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                message,
                SizedBox(
                  height: 20,
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).size.width - 80) / 2,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(b1),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 80) / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                        ),
                        gradient: LinearGradient(colors: color),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                        ),
                        onPressed: function(),
                        child: Text(
                          b2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
