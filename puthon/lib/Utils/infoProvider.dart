import 'package:cloud_firestore/cloud_firestore.dart';

class Info {
  static String uid = '';
  static String name = '';
  static String dob = '';
  static String email = '';
  static String phone = '';
  static int gender = 1;

  static bool register = true;
  static bool admin = false;
  static bool cook = false;

  Future<void> readData(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then(
      (value) {
        if (value.exists) {
          Info.uid = uid;
          Info.name = value['name'] ?? '';
          Info.phone = value['phone'] ?? '';
          Info.dob = value['dob'] ?? '';
          Info.email = value['email'] ?? '';
          Info.gender = value['gender'] ?? '';

          Info.register = value['register'] ?? true;
          Info.admin = value['admin'] ?? false;
          Info.cook = value['cook'] ?? false;
          
          EnteredRes.scanned = value['scanned'] ?? 1;

          ResCook.cooking = value['cooking'] ?? false;
          ResCook.resId = value['resId'] ?? '';
          ResCook.orderNo = value['orderNo'] ?? '';
        }
      },
    );
  }
}

class EnteredRes {
  static String resId = '';
  static String? resName = '';
  static String? table = '';
  static var total; // Actually double, but for fixing error
  static List<String> list = [];
  static int scanned = 0;
}

class ResCook {
  static String resId = '';
  static String? orderNo = '';
  static bool cooking = false;
}
