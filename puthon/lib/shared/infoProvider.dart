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
  static bool cooking = false;
  static int scanned = 0;

  static String resId = '';
  static String orderNo = '';

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
          Info.cooking = value['cooking'] ?? false;
          Info.scanned = value['scanned'] ?? 1;

          Info.resId = value['resId'] ?? '';
          Info.orderNo = value['orderNo'] ?? '';

        }
      },
    );
  }
}
