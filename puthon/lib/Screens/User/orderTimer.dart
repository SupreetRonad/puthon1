import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class OrderTimer extends StatefulWidget {
  final time, duration;
  OrderTimer({this.time, this.duration});
  @override
  _OrderTimerState createState() => _OrderTimerState();
}

class _OrderTimerState extends State<OrderTimer> {
  @override
  void initState() {
    super.initState();
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
              CircularCountDownTimer(
                duration: (widget.duration - elapsed) * 60,
                controller: CountDownController(),
                width: 40,
                height: 40,
                ringColor: Colors.transparent,
                fillColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                strokeWidth: 5.0,
                strokeCap: StrokeCap.round,
                textStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: true,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: true,
              ),
            ],
          );
  }
}
