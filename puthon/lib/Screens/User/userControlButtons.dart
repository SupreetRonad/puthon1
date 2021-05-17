import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserControlButtons extends StatefulWidget {
  final item;
  UserControlButtons({this.item});
  @override
  _UserControlButtonsState createState() => _UserControlButtonsState();
}

SharedPreferences prefs;

class _UserControlButtonsState extends State<UserControlButtons> {
  var count = 0;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: count > 0 ? 120 : 100,
      decoration: BoxDecoration(
        color: Colors.amber[300],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (count > 0)
            IconButton(
              onPressed: () {
                count = count > 0 ? count - 1 : count;
                setState(() {
                  if (count == 0) {
                    
                    prefs.remove("${widget.item["itemName"]}");
                    prefs.remove("${widget.item["itemName"]}1");
                  }
                  prefs.setInt("${widget.item["itemName"]}", count);
                  // print(prefs.getInt("${widget.item["itemName"]}"));
                  // print(prefs.getString("${widget.item["itemName"]}1"));
                });
              },
              icon: Icon(Icons.remove),
            ),
          count > 0
              ? SizedBox(
                  width: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        count.toString(),
                      ),
                    ],
                  ),
                )
              : TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  icon: Icon(Icons.add),
                  label: Text("Add"),
                  onPressed: () {
                    setState(() {
                      count += 1;
                      prefs.setInt("${widget.item["itemName"]}", count);
                      prefs.setString("${widget.item["itemName"]}1",
                          widget.item["itemName"]);
                      // print(prefs.getInt("${widget.item["itemName"]}"));
                      // print(prefs.getString("${widget.item["itemName"]}1"));
                    });
                  },
                ),
          if (count > 0)
            IconButton(
              onPressed: () {
                count = count < 20 ? count + 1 : count;
                prefs.setInt("${widget.item["itemName"]}", count);
                setState(() {});
                // print(prefs.getInt("${widget.item["itemName"]}"));
                // print(prefs.getString("${widget.item["itemName"]}1"));
              },
              icon: Icon(Icons.add),
            ),
        ],
      ),
    );
  }
}
