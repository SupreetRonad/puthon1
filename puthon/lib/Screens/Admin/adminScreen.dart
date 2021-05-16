import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:puthon/Screens/Admin/adminGenerateQR.dart';
import 'package:puthon/Screens/Admin/adminMenuList.dart';
import 'package:puthon/Screens/Admin/adminCooksList.dart';
import 'package:puthon/Screens/Admin/adminInsights.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

var flag = 0;
var screenList = [AdminCooksList(), AdminMenuList(), AdminInsights()];

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white.withOpacity(.95),
      appBar: AppBar(
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
                    fontWeight: FontWeight.w600),
                children: [
                  TextSpan(
                    text: "Admin",
                    style: GoogleFonts.dancingScript(
                      textStyle: TextStyle(color: Colors.red),
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext context) => HawkFabMenu(
          icon: AnimatedIcons.menu_arrow,
          fabColor: Colors.white,
          iconColor: Colors.black,
          items: [
            HawkFabMenuItem(
              label: 'Cooks List',
              ontap: () {
                setState(() {
                  flag = 0;
                });
              },
              icon: Icon(Icons.home),
              color: Colors.white,
              //labelColor: Colors.blue,
            ),
            HawkFabMenuItem(
              label: 'Menu',
              ontap: () {
                setState(() {
                  flag = 1;
                });
              },
              icon: Icon(Icons.menu_book),
              color: Colors.white,
            ),
            HawkFabMenuItem(
              label: 'Generate QR',
              ontap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AdminGenerateQR();
                  },
                );
              },
              icon: Icon(Icons.qr_code_scanner),
              color: Colors.white,
            ),
          ],
          body: Center(
            child: screenList[flag],
          ),
        ),
      ),
    );
  }
}
