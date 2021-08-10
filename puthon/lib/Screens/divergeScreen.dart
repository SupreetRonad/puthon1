import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/User/detailScreen.dart';
import 'package:puthon/Utils/infoProvider.dart';
import 'package:puthon/shared/loadingScreen.dart';
import 'package:puthon/Utils/pagesurf.dart';

import 'User/homeScreen.dart';

class DivergeScreen extends StatelessWidget {
  void readData(BuildContext context) async {
    Info info = Info();
    await info.readData(FirebaseAuth.instance.currentUser!.uid);

    if (Info.register) {
      replacePage(context, DetailScreen());
    } else {
      replacePage(context, HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    readData(context);
    return LoadingScreen();
  }
}
