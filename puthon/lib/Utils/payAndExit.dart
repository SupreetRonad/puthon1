import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puthon/Utils/infoProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/User/cartButton.dart';
import '../Screens/User/homeScreen.dart';

Future<void> PayAndExit(Function refresh) async {
  var timeStamp = Timestamp.now().toString();
  var orderList = {};
  var total, resName, table, time;

  SharedPreferences prefs = await SharedPreferences.getInstance();

  for (var i = 0; i < EnteredRes.list.length; i++) {
    prefs.remove(EnteredRes.list[i]);
    prefs.remove(EnteredRes.list[i] + "1");
    prefs.remove(EnteredRes.list[i] + "2");
  }
  EnteredRes.list = [];
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
  EnteredRes.scanned = 1;

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
      .doc(EnteredRes.resId)
      .collection('tables')
      .doc(EnteredRes.table)
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
      .doc(EnteredRes.resId)
      .collection('completedOrders')
      .doc(timeStamp)
      .set({
    "customerId": FirebaseAuth.instance.currentUser!.uid,
    "timeStamp": timeStamp,
  });

  await FirebaseFirestore.instance
      .collection('admins')
      .doc(EnteredRes.resId)
      .collection('activeOrders')
      .where('customerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("admins")
          .doc(EnteredRes.resId)
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
