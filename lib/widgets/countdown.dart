import 'package:flutter/material.dart';
import 'package:wedding/screens/HomeScreen/home_components/timesquare.dart';

class CountDown extends StatelessWidget {
  final Duration duration;

  const CountDown({required this.duration, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return duration.isNegative
        ? Row(
            children: const [
              TimeSquare(type: "Days", time: "0"),
              TimeSquare(type: "Hours", time: "0"),
              TimeSquare(type: "Mins", time: "0"),
            ],
          )
        : TweenAnimationBuilder<Duration>(
            duration: Duration(seconds: duration.inSeconds - 19800),
            tween: Tween(
                begin: Duration(seconds: duration.inSeconds - 19800),
                end: Duration.zero),
            onEnd: () {
              // print('Timer ended');
            },
            builder: (BuildContext context, Duration value, Widget? child) {
              final hours = value.inHours % 24;
              final days = value.inDays;
              final minutes = value.inMinutes % 60;
              final seconds = value.inSeconds % 60;
              return duration.isNegative
                  ? Row(
                      children: const [
                        TimeSquare(type: "Days", time: "0"),
                        TimeSquare(type: "Hours", time: "0"),
                        TimeSquare(type: "Mins", time: "0"),
                      ],
                    )
                  : Row(
                      children: [
                        if (days > 0)
                          TimeSquare(
                              type: "Days",
                              time: days < 10 ? "0$days" : "$days"),
                        TimeSquare(
                            type: "Hours",
                            time: hours < 10 ? "0$hours" : "$hours"),
                        TimeSquare(
                            type: "Mins",
                            time: minutes < 10 ? "0$minutes" : "$minutes"),
                        if (days == 0)
                          TimeSquare(
                              type: "Seconds",
                              time: seconds < 10 ? "0$seconds" : "$seconds"),
                      ],
                    );
            });
  }
}
