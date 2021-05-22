import 'dart:async';
import 'package:flutter/material.dart';

class OrderTimer extends StatefulWidget {
  final time, duration;
  final Function refresh;
  OrderTimer({this.time, this.duration, this.refresh});
  @override
  _OrderTimerState createState() => _OrderTimerState();
}

class _OrderTimerState extends State<OrderTimer> {
  var count = 0;
  @override
  void initState() {
    super.initState();
    
  }

  Widget _timer(){
    Timer.periodic(Duration(seconds: 60), (timer) {
      refresh();
    });
    return SizedBox();
  }
  
  void refresh() {
    setState(() {});
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

    return (widget.duration - elapsed) <= 0
        ? Text(
            widget.duration == 0 ? "Confirmation pending..." : "Completed!",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: widget.duration == 0 ? Colors.amber : Colors.green[300],
            ),
          )
        : Row(
            children: [
              Text(
                "Delivery in ",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              Text(
                (widget.duration - elapsed).toString(),
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _timer(),
              Text(
                " mins",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          );
  }
}
