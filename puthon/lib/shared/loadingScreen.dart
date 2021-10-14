import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/amber1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitChasingDots(
              color: Colors.white,
              size: 50,
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Text(
            //   "Loading...",
            //   style: GoogleFonts.roboto(
            //     fontSize: 12,
            //     color: Colors.black54,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
