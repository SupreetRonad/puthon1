import 'package:flutter/material.dart';

void replacePage(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (builder) => page,
    ),
  );
}
