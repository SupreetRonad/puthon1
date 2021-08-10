import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:puthon/Utils/infoProvider.dart';
import 'package:puthon/shared/itemCard.dart';
import 'package:puthon/shared/loadingScreen.dart';

import 'homeScreen.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Info.scanned != 2
          ? LoadingScreen()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('admins')
                  .doc(HomeScreen.resId)
                  .collection('menu')
                  .orderBy('category')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitFadingCircle(
                    color: Colors.green,
                    size: 20,
                  );
                }
                if (!snapshot.hasData) {
                  return const Text(
                    "No Items...",
                    style: TextStyle(fontSize: 20),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 20, 0, 5),
                          height: 4,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            border: Border.all(
                              color: Colors.black.withOpacity(.1),
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Menu",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(
                                bottom: kFloatingActionButtonMargin + 60),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              var item = snapshot.data.docs[index];
                              return !item['inMenu']
                                  ? const SizedBox()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: ItemCard(
                                        item: item,
                                        order: true,
                                      ),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }
}
