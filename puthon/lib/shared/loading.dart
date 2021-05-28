import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void Loading(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SpinKitCircle(
              color: Colors.black87,
              size: 30,
            ),
          ),
        ),
      );
    },
  );
}
