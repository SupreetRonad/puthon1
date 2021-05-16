import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CookScreen extends StatefulWidget {
  @override
  _CookScreenState createState() => _CookScreenState();
}

class _CookScreenState extends State<CookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Spacer(),
            RichText(
              text: TextSpan(
                text: 'PUTHON ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
                children: [
                  TextSpan(
                    text: "Cook",
                    style: GoogleFonts.dancingScript(
                      textStyle: TextStyle(
                        color: Colors.amber
                      ),
                      fontSize: 20,
                      //fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.white,
            //     //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            //     shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(20)
            //   ),
            //   ),
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(context, '/homeScreen');
            //   },
            //   child: Text(
            //     "User mode",
            //     style: TextStyle(),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
