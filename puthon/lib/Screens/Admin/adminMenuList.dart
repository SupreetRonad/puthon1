import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Screens/Admin/addMenuItem.dart';
import 'package:puthon/Shared/itemCard.dart';

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
          padding: const EdgeInsets.all(3.0),
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
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('menu')
                  .orderBy('itemName')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitFadingCircle(
                    color: Colors.black54,
                    size: 20,
                  );
                }
                if (!snapshot.hasData) {
                  return Text(
                    "Please Add Items...",
                    style: TextStyle(fontSize: 20),
                  );
                } else {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      bottom: kFloatingActionButtonMargin + 60,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: ItemCard(
                          item: item,
                          order: false,
                        ),
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
        return AddMenuItem(
          modify: false,
        );
      },
    );
  }
}
