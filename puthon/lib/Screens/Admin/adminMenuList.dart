import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Screens/Admin/addMenuItem.dart';
import 'package:puthon/Shared/loadingScreen.dart';

class AdminMenuList extends StatefulWidget {
  @override
  _AdminMenuListState createState() => _AdminMenuListState();
}

class _AdminMenuListState extends State<AdminMenuList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              _addItem();
            },
            icon: Icon(
              Icons.restaurant_menu_rounded,
              size: 20,
            ),
            label: Text(
              "Add Item",
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('admins')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection('menu')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingScreen();
                }
                if (!snapshot.hasData) {
                  return Text(
                    "Please Add Items...",
                    style: TextStyle(fontSize: 20),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = snapshot.data.docs[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(item['itemName']),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMenuItem();
      },
    );
  }
}
