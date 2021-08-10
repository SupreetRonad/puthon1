import 'package:flutter/material.dart';

void replacePage(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (builder) => page,
    ),
  );
}
void pushPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (builder) => page,
    ),
  );
}


