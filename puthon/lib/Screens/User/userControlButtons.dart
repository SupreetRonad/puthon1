import 'package:flutter/material.dart';
import 'package:puthon/Screens/User/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserControlButtons extends StatefulWidget {
  final item;
  UserControlButtons({this.item});
  @override
  _UserControlButtonsState createState() => _UserControlButtonsState();
}

SharedPreferences prefs;

class _UserControlButtonsState extends State<UserControlButtons> {
  var count = 0, price = 0, veg = true;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    count = prefs.getInt('${widget.item["itemName"]}') ?? 0;
    setState(() {});
  }

  void removeItem(var name, var count1) {
    if (HomeScreen.list.contains(name)) {
      if (prefs.getInt(name) == 1) {
        HomeScreen.list.remove(name);
        prefs.remove(name);
        prefs.remove(name + "1");
        prefs.remove(name + "2");
      } else {
        prefs.setInt(name, count1);
      }
      prefs.setStringList('orderList', HomeScreen.list);
    }
  }

  void addItem(var name, var count1) {
    if (HomeScreen.list.contains(name)) {
      prefs.setInt(name, count1);
    } else {
      HomeScreen.list.add(name);
      prefs.setInt(name, count1);
      prefs.setString("${name}1", widget.item["price"]);
      prefs.setBool("${name}2", widget.item["veg"]);
    }
    prefs.setStringList('orderList', HomeScreen.list);
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
                setState(() {
                  count = count > 0 ? count - 1 : count;
                  removeItem(widget.item["itemName"], count);

                  print(prefs.getInt("${widget.item["itemName"]}"));
                  print(prefs.getString("${widget.item["itemName"]}1"));
                });
              },
              icon: Icon(Icons.remove),
            ),
          count > 0 
              ? SizedBox(
                  width: 20,
                  child: Center(
                    child: Text(
                      count.toString(),
                    ),
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
                      count = count + 1;
                      addItem(widget.item["itemName"], count);
                    });
                    print(prefs.getInt("${widget.item["itemName"]}"));
                    print(prefs.getString("${widget.item["itemName"]}1"));
                  },
                ),
          if (count > 0)
            IconButton(
              onPressed: () {
                setState(() {
                  count = count < 20 ? count + 1 : count;
                  addItem(widget.item["itemName"], count);
                });
                print(prefs.getInt("${widget.item["itemName"]}"));
                print(prefs.getString("${widget.item["itemName"]}1"));
              },
              icon: Icon(Icons.add),
            ),
        ],
      ),
    );
  }
}
