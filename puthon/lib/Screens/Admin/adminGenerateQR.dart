import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:puthon/Shared/textField.dart';
import 'package:qrscans/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

class AdminGenerateQR extends StatefulWidget {
  @override
  _AdminGenerateQRState createState() => _AdminGenerateQRState();
}

class _AdminGenerateQRState extends State<AdminGenerateQR> {
  late String qrContent, table;
  Uint8List result = Uint8List(0);
  var valid = 0, flag = 0;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10.0,
        sigmaY: 10.0,
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .45 + 80,
            width: MediaQuery.of(context).size.width * .8,
            child: Column(
              children: [
                Text(
                  "Generate QR Code",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          qrContent = val;
                        });
                      },
                      textInputAction: TextInputAction.done,
                      key: ValueKey('table'),
                      keyboardType: TextInputType.number,
                      decoration: textField.copyWith(
                        hintText: flag == 0
                            ? "Enter Table number..."
                            : "Enter Bot number...",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(.35),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 70,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                flag = 0;
                                result = Uint8List(0);
                                valid = 0;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: flag == 0
                                      ? Colors.greenAccent
                                      : Colors.grey,
                                  size: flag == 0 ? 17 : 14,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Table",
                                  style: TextStyle(
                                    color: flag == 0
                                        ? Colors.black87
                                        : Colors.black45,
                                    fontSize: flag == 0 ? 17 : 14,
                                    fontWeight: flag == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                flag = 1;
                                result = Uint8List(0);
                                valid = 0;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: flag == 1
                                      ? Colors.greenAccent
                                      : Colors.grey,
                                  size: flag == 1 ? 17 : 14,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Bot",
                                  style: TextStyle(
                                    color: flag == 1
                                        ? Colors.black87
                                        : Colors.black45,
                                    fontSize: flag == 1 ? 17 : 14,
                                    fontWeight: flag == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Colors.white,
                        //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        if (qrContent.isNotEmpty &&
                            (RegExp(r'^[0-9]{1}$').hasMatch(qrContent) ||
                                RegExp(r'^[0-9]{2}$').hasMatch(qrContent))) {
                          FocusScope.of(context).unfocus();
                          result = await scanner.generateBarCode(
                              "${qrContent}/*/${FirebaseAuth.instance.currentUser!.uid}");
                          table = qrContent;
                          valid = 1;
                        } else {
                          valid = 2;
                          result = Uint8List(0);
                        }
                        setState(() {});
                      },
                      child: Text("Generate Code"),
                    ),
                  ],
                ),
                if (valid == 0)
                  SizedBox(
                    height: 20,
                  ),
                if (valid > 0)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      valid == 1
                          ? "QR code generated for ${flag == 0 ? "Table" : "Bot"} ${table}"
                          : "Invalid table number",
                      style: TextStyle(
                        color: valid == 1 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .25,
                  child: result.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.qr_code_scanner,
                            color: Colors.black38,
                            size: 50,
                          ),
                        )
                      : Image.memory(
                          result,
                        ),
                ),
                Spacer(),
                if (valid == 1)
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.greenAccent,
                          Colors.green[300]!,
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.transparent,

                        //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        await ImageGallerySaver.saveImage(
                            Uint8List.fromList(result),
                            quality: 60,
                            name: "${qrContent}${flag == 0 ? "Table" : "Bot"}");
                        Fluttertoast.showToast(
                            msg: "QR code saved to Gallery",
                            gravity: ToastGravity.SNACKBAR,
                            backgroundColor: Colors.white,
                            textColor: Colors.black);
                      },
                      child: Text(
                        "Save to Gallery",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
