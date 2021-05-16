import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:menu_button/menu_button.dart';
import 'package:puthon/Shared/confirmBox.dart';
import 'package:puthon/Shared/successBox.dart';
import 'package:puthon/Shared/textField.dart';

class AddMenuItem extends StatefulWidget {
  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

var itemName, price, veg, moreInfo, ingredients;
var flag = [0, 0, 0];
bool flag1 = false, loading = false;

class _AddMenuItemState extends State<AddMenuItem> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var flag = [0, 0, 0];
  bool flag1 = false, loading = false;
  String category;
  final _controller = AdvancedSwitchController(true);

  List<String> keys = <String>[
    'Main Course',
    'Soups',
    'Starters',
    'Breads',
    'Rice',
    'Chinese',
    'Desserts',
  ];

  @override
  void initState() {
    category = keys[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    final Widget normalChildButton = Container(
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                category,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 12,
              height: 17,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10.0,
        sigmaY: 10.0,
      ),
      child: Container(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .6 + 80,
              width: MediaQuery.of(context).size.width * .8,
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Text(
                        "Add Item",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        //height: 300,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  color: Colors.white.withOpacity(.4),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      flag[0] = 0;
                                      if (val.isEmpty) {
                                        flag[0] = 1;
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('itemName'),
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.text,
                                    decoration: textField.copyWith(
                                      labelText: "Item name",
                                      labelStyle: TextStyle(
                                        color: Colors.black.withOpacity(.35),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.restaurant,
                                        color: flag[0] == 1
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                    validator: (val) {
                                      flag[0] = val.isEmpty ? 1 : 0;
                                      itemName = val;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  //width: 120,
                                  color: Colors.white.withOpacity(.4),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      flag[1] = 0;
                                      if (val.isEmpty) {
                                        flag[1] = 1;
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('price'),
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.number,
                                    decoration: textField.copyWith(
                                      labelText: "Price (in Rs.)",
                                      labelStyle: TextStyle(
                                        color: Colors.black.withOpacity(.35),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.attach_money_rounded,
                                        color: flag[1] == 1
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                    validator: (val) {
                                      flag[1] = val.isEmpty ? 1 : 0;
                                      price = val;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      height: 60,
                                      color: Colors.white.withOpacity(.4),
                                      child: MenuButton<String>(
                                        crossTheEdge: true,
                                        edgeMargin: 60,
                                        //itemBackgroundColor: Colors.transparent,
                                        menuButtonBackgroundColor:
                                            Colors.transparent,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: normalChildButton,
                                        items: keys,
                                        itemBuilder: (String value) =>
                                            Container(
                                          height: 50,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 16),
                                          child: Text(value),
                                        ),
                                        toggledChild: Container(
                                          child: normalChildButton,
                                        ),
                                        onItemSelected: (String value) {
                                          setState(() {
                                            category = value;
                                          });
                                        },
                                        label: Text(
                                          "Category",
                                          style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 11),
                                        ),
                                        labelDecoration: LabelDecoration(
                                          background: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                AdvancedSwitch(
                                  controller: _controller,
                                  activeColor: Colors.green,
                                  inactiveColor: Colors.red,
                                  activeChild: Text('  Veg'),
                                  inactiveChild: Text('Non\nVeg'),
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(15)),
                                  width: 80.0,
                                  height: 40.0,
                                  enabled: true,
                                  disabledOpacity: 0.5,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  color: Colors.white.withOpacity(.4),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      flag[2] = 0;
                                      if (val.isEmpty) {
                                        flag[2] = 1;
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('ingredient'),
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.streetAddress,
                                    decoration: textField.copyWith(
                                      labelText: "Ingredients",
                                      labelStyle: TextStyle(
                                        color: Colors.black.withOpacity(.35),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.streetview,
                                        color: flag[2] == 1
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                    validator: (val) {
                                      flag[2] = val.isEmpty ? 1 : 0;
                                      ingredients = val;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  color: Colors.white.withOpacity(.4),
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.done,
                                    key: ValueKey('moreInfo'),
                                    onEditingComplete: () => node.unfocus(),
                                    keyboardType: TextInputType.streetAddress,
                                    decoration: textField.copyWith(
                                      labelText: "More Info",
                                      labelStyle: TextStyle(
                                        color: Colors.black.withOpacity(.35),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.import_contacts,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    validator: (val) {
                                      moreInfo = val;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        flag1
                            ? "Please fill all the fields with valid info"
                            : "",
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            child: loading
                                ? SpinKitFadingCircle(
                                    color: Colors.black,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.arrow_forward_ios,
                                  ),
                            onPressed: () {
                              _formkey.currentState.validate();
                              setState(() {
                                loading = true;
                              });
                              FocusScope.of(context).unfocus();
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                setState(() {
                                  loading = false;
                                  if (flag.reduce((a, b) => a + b) == 0) {
                                    flag1 = false;
                                    _formkey.currentState.save();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ConfirmBox(
                                          b1: "Go Back",
                                          b2: "Add Item",
                                          color: Colors.green[300],
                                          message: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Icon(
                                                    Icons.fastfood,
                                                    color: Colors.green[400],
                                                    size: 40,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .radio_button_checked,
                                                      color: _controller.value
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      child: Text(
                                                        itemName,
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      35, 0, 0, 10),
                                                  child: Text(
                                                    ingredients,
                                                    maxLines: 2,
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                                moreInfo == null
                                                    ? null
                                                    : Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                35, 0, 0, 5),
                                                        child: Text(
                                                          "-  " + moreInfo,
                                                          maxLines: 1,
                                                          softWrap: false,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                      ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 35,
                                                    ),
                                                    Text(
                                                      category,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.amber),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              35, 0, 0, 5),
                                                      child: Text(
                                                        "Rs. " + price,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          function: () async {
                                            await FirebaseFirestore.instance
                                                .collection('admins')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .collection('menu')
                                                .doc(itemName)
                                                .set({
                                              "itemName": itemName,
                                              "price": price,
                                              "category": category,
                                              "veg": _controller.value,
                                              "ingredients": ingredients,
                                              "moreInfo": moreInfo,
                                            });
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SuccessBox(
                                                  title:
                                                      'Item Added successfully',
                                                  msg1:
                                                      'Item has been added successfully to the menu. You can now modify or delete it later.',
                                                  msg2:
                                                      'You can now modify or delete it later.',
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    flag1 = true;
                                  }
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
