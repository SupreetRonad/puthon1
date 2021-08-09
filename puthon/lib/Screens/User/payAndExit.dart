import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puthon/shared/infoProvider.dart';

import 'cartButton.dart';
import 'homeScreen.dart';

Future<void> PayAndExit(var prefs, Function refresh) async {
  var timeStamp = Timestamp.now().toString();
  var orderList = {};
  var total, resName, table, time;

  for (var i = 0; i < HomeScreen.list.length; i++) {
    prefs.remove(HomeScreen.list[i]);
    prefs.remove(HomeScreen.list[i] + "1");
    prefs.remove(HomeScreen.list[i] + "2");
  }
  HomeScreen.list = [];
  prefs.setStringList("orderList", <String>[]);
  CartButton.orderList = {};
  prefs.setInt("orderNo", 0);

  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    'scanned': 1,
  });

  refresh();
  cameraScanResult = '';
  Info.scanned = 1;

  var data = await FirebaseFirestore.instance
      .collection('orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(FirebaseAuth.instance.currentUser!.uid)
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
  });

  await FirebaseFirestore.instance
      .collection('orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    if (value.exists) {
      total = value.data()!['total'];
      resName = value.data()!['resName'];
      table = value.data()!['table'];
      time = value.data()!['timeEntered'];
    }
  });

  await FirebaseFirestore.instance
      .collection('admins')
      .doc(HomeScreen.resId)
      .collection('tables')
      .doc(HomeScreen.table)
      .delete();

  await FirebaseFirestore.instance
      .collection('history')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(FirebaseAuth.instance.currentUser!.uid)
      .doc(timeStamp)
      .set({
    'orderList': orderList,
    'total': total,
    'table': table,
    'resName': resName,
    'timeEntered': time
  });

  await FirebaseFirestore.instance
      .collection('admins')
      .doc(HomeScreen.resId)
      .collection('completedOrders')
      .doc(timeStamp)
      .set({
    "customerId": FirebaseAuth.instance.currentUser!.uid,
    "timeStamp": timeStamp,
  });

  await FirebaseFirestore.instance
      .collection('admins')
      .doc(HomeScreen.resId)
      .collection('activeOrders')
      .where('customerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("admins")
          .doc(HomeScreen.resId)
          .collection('activeOrders')
          .doc(element['timeStamp'])
          .delete();
    });
  });

  await FirebaseFirestore.instance
      .collection('orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .delete();
  await FirebaseFirestore.instance
      .collection('orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("orders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(element.id)
          .delete();
    });
  });

  
}
