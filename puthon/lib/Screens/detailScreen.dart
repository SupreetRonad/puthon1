import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puthon/shared/textField.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

var name, phone, dob, gender;

class _DetailScreenState extends State<DetailScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
      ),
      body: Form(
        key: _formkey,
        child: Column(children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(.7),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 60, 10),
                  child: Text(
                    "Add Details",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 15),
                Card(
                  elevation: 10,
                  //color: Colors.tealAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: textField.copyWith(
                      labelText: "Name",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black87,
                      ),
                    ),
                    validator: (val) =>
                        val.length == 0 ? 'Required Field' : null,
                    onSaved: (String val) {
                      name = val;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 10,
                  //color: Colors.tealAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: textField.copyWith(
                      labelText: "Phone number",
                      prefixText: "+91 ",
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.black87,
                      ),
                    ),
                    validator: (val) =>
                        val.length == 0 ? 'Required Field' : null,
                    onSaved: (String val) {
                      name = val;
                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
