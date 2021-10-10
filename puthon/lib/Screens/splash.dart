import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/amber1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            heading(context),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
          ],
        ),
      ),
    );
  }

  Widget heading(context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "PUTHON",
            style: GoogleFonts.righteous(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * .050,
              color: Colors.white,
            ),
          ),
          Text(
            "Your virtual waiter..",
            style: GoogleFonts.raleway(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * .017,
            ),
          ),
        ],
      );
}
