import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {

  final request;
  RequestCard(this.request);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 200,
      child: Card(
        elevation: 18,
        shadowColor: Colors.white38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
          ],
        ),
      ),
    );
  }
}
