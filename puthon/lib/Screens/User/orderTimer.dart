import 'dart:async';
import 'package:flutter/material.dart';

class OrderTimer extends StatefulWidget {
  final time, duration, flag, cookOrder;
  OrderTimer({this.time, this.duration, this.flag, this.cookOrder});
  @override
  _OrderTimerState createState() => _OrderTimerState();
}

class _OrderTimerState extends State<OrderTimer> {
  var count = 0;

  Widget _timer() {
    Timer.periodic(Duration(seconds: 60), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flag == 1) {
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
        elapsed = (now_hour - initial_hour) * 60 + 60 - initial_minute;
      }

      return (widget.duration - elapsed) <= 2
          ? Row(
              children: [
                Icon(
                  Icons.donut_large_rounded,
                  size: 17,
                  color: Colors.green[300],
                ),
                Text(
                  widget.cookOrder
                      ? "Hurry, almost time..."
                      : "  Almost done...",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color:
                        widget.cookOrder ? Colors.red[300] : Colors.green[300],
                  ),
                ),
              ],
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
    } else if (widget.flag == 2) {
      return Row(
        children: [
          Icon(
            Icons.fiber_smart_record,
            size: 16,
            color: Colors.green[300],
          ),
          Text(
            "  On the Bot",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.green[300],
            ),
          ),
        ],
      );
    } else if (widget.flag == 3) {
      return Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 17,
            color: Colors.green[300],
          ),
          Text(
            "  Delivered",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.green[300],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(
            Icons.timer,
            size: 17,
            color: Colors.amber,
          ),
          Text(
            "  Confirmation pending",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      );
    }
  }
}
