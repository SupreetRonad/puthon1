import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final request;
  RequestCard(this.request);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      height: 200,
      child: Card(
        elevation: 18,
        shadowColor: Colors.white38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(request['name'] + " | " + request['email']),
            Text(request['resName']),
            Text(request['street']),
            Text(request['pincode']),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection("requests").doc(request['uid']).delete();
                  },
                  child: Icon(Icons.close),
                ),
                TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("admins")
                        .doc(request["uid"])
                        .set({
                      'resName': request["resName"],
                      'resId': request["uid"],
                      'state': request["state"],
                      'pincode': request["pincode"],
                      'country': request["country"],
                      'city': request["city"],
                      'building': request["building"],
                      'street': request["street"],
                    });

                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(request["uid"])
                        .update({
                      'admin': true,
                    });

                    await FirebaseFirestore.instance.collection("requests").doc(request['uid']).delete();
                  },
                  child: Icon(Icons.done),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
