import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

class CartButton extends StatelessWidget {

  final bool cart = false;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Shared Preferences Storage, Retrieval & Clear",
                style: TextStyle(fontSize: 15,color: Colors.brown,fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
              ElevatedButton(child: Text("Save Data"), onPressed: save),
              ElevatedButton(child: Text("Fetch Data"),onPressed: fetch),
              ElevatedButton(child: Text("Clear Data"),onPressed: remove)
            ],
          ),
        ),
      ),
    );
  }
}

save() async {
  await CartButton().init();

  prefs.setInt('chicken', 10);

  prefs.setString('chicken1', "chicken");

  prefs.setDouble('double', 3.14);

  prefs.setBool('boolean', true);

  prefs.setStringList('stringlist', ['horse', 'cow', 'sheep']);
}

fetch() async {
  final myInt = prefs.getInt('chicken') ?? 0;

  final myDouble = prefs.getDouble('double') ?? 0.0;

  final myBool = prefs.getBool('boolean') ?? false;

  final myString = prefs.getString('chicken1') ?? '';

  final myStringList = prefs.getStringList('stringlist') ?? [];

  print("\n Int  - $myInt \n double - $myDouble \n boolean - $myBool \n string - $myString \n stringlist - $myStringList");
}

remove() async {
  prefs.remove('chicken');
}
