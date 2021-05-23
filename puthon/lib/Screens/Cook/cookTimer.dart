import 'dart:async';

import 'package:flutter/material.dart';

class CookTimer extends StatefulWidget {
  final time, duration;
  CookTimer({
    this.time,
    this.duration,
  });

  @override
  _CookTimerState createState() => _CookTimerState();
}

class _CookTimerState extends State<CookTimer> {
  void _timer() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var arr = widget.time.split(" ");
    var now_hour = DateTime.now().hour;
    var now_minute = DateTime.now().minute;
    var initial_hour =
        arr[3] == "pm" ? int.parse(arr[0]) + 12 : int.parse(arr[0]);
    var initial_minute = int.parse(arr[2]);
    var elapsed;
    if (now_hour == initial_hour) {
      elapsed = now_minute - initial_minute;
    } else {
      elapsed = now_minute + 60 - initial_minute;
    }
    _timer();

    var timeLeft = widget.duration - elapsed;

    return timeLeft < 2  ? Text(
      "Please Hurry up...",
      style: TextStyle(
        color: Colors.red[400],
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    ) : Text(
      timeLeft.toString() + "  minutes left...",
      style: TextStyle(
        color: Colors.green[600],
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    );
  }
}
