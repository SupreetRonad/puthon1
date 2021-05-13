import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:page_slider/page_slider.dart';
import 'package:puthon/shared/textField.dart';

class RegisterBusiness extends StatefulWidget {
  @override
  _RegisterBusinessState createState() => _RegisterBusinessState();
}

class _RegisterBusinessState extends State<RegisterBusiness> {
  GlobalKey<PageSliderState> _slider = GlobalKey();
  Widget _card(String text) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          //color: Colors.white.withOpacity(.3),
        ),
        child: Padding(
          padding: EdgeInsets.all(100),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/forkplate.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text("Register My Business"),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: PageSlider(
                            key: _slider,
                            duration: Duration(milliseconds: 400),
                            pages: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    color: Colors.white.withOpacity(.4),
                                    child: TextFormField(
                                      onChanged: (val) {
                                        // flag[0] = 0;
                                        //setState(() {});
                                      },
                                      textInputAction: TextInputAction.next,
                                      key: ValueKey('email'),
                                      onEditingComplete: () => node.nextFocus(),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: textField.copyWith(
                                        labelText: "Restaurant name",
                                        labelStyle: TextStyle(
                                          color: Colors.black.withOpacity(.35),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.restaurant,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      validator: (val) {
                                        //   if (val.isEmpty) {
                                        //     setState(() {
                                        //       flag[0] = 1;
                                        //     });
                                        //     return null;
                                        //   }
                                        //   flag[0] = 0;
                                        //   return null;
                                        // },
                                        // onSaved: (val) {
                                        //   setState(() => email = val);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FloatingActionButton(
                              child: Icon(Icons.arrow_back_ios),
                              onPressed: () => _slider.currentState.previous(),
                            ),
                            FloatingActionButton(
                              child: Icon(Icons.arrow_forward_ios),
                              onPressed: () => _slider.currentState.next(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
