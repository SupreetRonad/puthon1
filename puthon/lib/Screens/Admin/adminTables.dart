import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/Shared/loadingScreen.dart';

class AdminTables extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('admins')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection("tables")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (!snapshot.hasData) {
            return Text(
              "Please Add cooks...",
              style: TextStyle(fontSize: 20),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                    bottom: kFloatingActionButtonMargin + 60),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var table = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () async {

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(table['table']),
                            //Icon(Icons.table)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
