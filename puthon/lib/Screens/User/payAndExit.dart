import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cartButton.dart';
import 'homeScreen.dart';

Future<void> PayAndExit(var prefs, Function refresh) async {
  var timeStamp = Timestamp.now().toString();
  var orderList = {};
  var total, resName, table, time;

  // for (var i = 0; i < HomeScreen.list.length; i++) {
  //   prefs.remove(HomeScreen.list[i]);
  //   prefs.remove(HomeScreen.list[i] + "1");
  //   prefs.remove(HomeScreen.list[i] + "2");
  // }
  // HomeScreen.list = [];
  // prefs.setStringList("orderList", <String>[]);
  // CartButton.orderList = {};
  // prefs.setInt("orderNo", 0);
  // var id = await FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(FirebaseAuth.instance.currentUser.uid)
  //     .update({
  //   'scanned': 1,
  // });
  // scanned = 1;
  // refresh();
  // cameraScanResult = null;

  var data = await FirebaseFirestore.instance
      .collection('orders')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection(FirebaseAuth.instance.currentUser.uid)
      .snapshots();
  

  data.forEach((element) {
    var len = element.docs.length;
    for (var i = 0; i < len; i++) {
      var doc = element.docs[i].data();
      for (var j in doc['orderList'].keys) {
        if (orderList.containsKey(j)) {
          orderList[j][0] = orderList[j][0] + doc['orderList'][j][0];
        } else {
          orderList[j] = doc['orderList'][j];
        }
      }
    }
    print(orderList.toString());
  });

  await FirebaseFirestore.instance
      .collection('orders')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .get()
      .then((value) {
    if (value.exists) {
      total = value.data()['total'];
      resName = value.data()['resName'];
      table = value.data()['table'];
      time = value.data()['timeEntered'];
    }
  });

  

  await FirebaseFirestore.instance
      .collection('history')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection(timeStamp)
      .doc(timeStamp)
      .set({
        'orderList': orderList,
        'total': total,
        'table': table,
        'resName': resName,
        'timeEntered': time
      });
  ;
}
