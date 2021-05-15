import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puthon/Screens/Admin/adminMenuList.dart';
import 'package:puthon/Screens/Admin/adminCooksList.dart';
import 'package:puthon/Screens/Admin/adminInsights.dart';
import 'package:puthon/shared/textField.dart';

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
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/homeScreen');
              },
              child: Text(
                "User mode",
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 10, 60, 8),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(1),
                ),
                child: TextFormField(
                  onChanged: (val) {},
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.search,
                  key: ValueKey('resname'),
                  keyboardType: TextInputType.text,
                  decoration: textField.copyWith(
                    labelText: "Search...",
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(.35),
                    ),
                  ),
                  validator: (val) {
                    return null;
                  },
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      (AppBar().preferredSize.height +
                          MediaQuery.of(context).padding.top +
                          90),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: screenList[flag],
                ),
              ),
              Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          flag = 0;
                        });
                      },
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          "Cooks",
                          style: GoogleFonts.kalam(
                            textStyle: TextStyle(
                              color:
                                  flag == 0 ? Colors.black87 : Colors.black26,
                            ),
                            fontSize: 20,
                            fontWeight:
                                flag == 0 ? FontWeight.w700 : FontWeight.normal,
                            //fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          flag = 1;
                        });
                      },
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          "Menu",
                          style: GoogleFonts.kalam(
                            textStyle: TextStyle(
                              color:
                                  flag == 1 ? Colors.black87 : Colors.black26,
                            ),
                            fontSize: 20,
                            fontWeight:
                                flag == 1 ? FontWeight.w700 : FontWeight.normal,
                            //fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          flag = 2;
                        });
                      },
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          "Insights",
                          style: GoogleFonts.kalam(
                            textStyle: TextStyle(
                              color:
                                  flag == 2 ? Colors.black87 : Colors.black26,
                            ),
                            fontSize: 20,
                            fontWeight:
                                flag == 2 ? FontWeight.w700 : FontWeight.normal,
                            //fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
