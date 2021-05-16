import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:puthon/Shared/textField.dart';
import 'package:qrscans/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

class AdminGenerateQR extends StatefulWidget {
  @override
  _AdminGenerateQRState createState() => _AdminGenerateQRState();
}

String cameraScanResult, qrContent;
Uint8List result = Uint8List(0);
var valid = 0;

class _AdminGenerateQRState extends State<AdminGenerateQR> {
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
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .6 + 80,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10, 0.0, 8),
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
                          hintText: "Enter Table number...",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(.35),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (qrContent.isNotEmpty &&
                          (RegExp(r'^[0-9]{1}$').hasMatch(qrContent) ||
                              RegExp(r'^[0-9]{2}$').hasMatch(qrContent))) {
                        result = await scanner.generateBarCode(
                            "${qrContent}/*/${FirebaseAuth.instance.currentUser.uid}");
                        valid = 1;
                      } else {
                        valid = 2;
                      }
                      setState(() {});
                    },
                    child: Text("Generate Code"),
                  ),
                  if (valid == 0)
                    SizedBox(
                      height: 10,
                    ),
                  if (valid > 0)
                    Text(
                      valid == 1 ? "QR code generated" : "Invalid table number",
                      style: TextStyle(
                        color: valid == 1 ? Colors.green : Colors.red,
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .25,
                    child: result.isEmpty
                        ? Center(
                            child: Text(
                              'Empty code ... ',
                              style: TextStyle(
                                color: Colors.black38,
                              ),
                            ),
                          )
                        : Image.memory(result),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final save = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(result),
                          quality: 60,
                          name: qrContent);
                      print(save);
                    },
                    child: Text("Save to Gallery"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
