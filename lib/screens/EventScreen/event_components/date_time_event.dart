import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/theme_provider.dart';

class DateTimeEvent extends StatelessWidget {
  final String date;
  final String time;
  final double height;
  final double dateSize;
  final double timeSize;

  const DateTimeEvent(
      {required this.height,
      required this.date,
      required this.time,
      required this.dateSize,
      required this.timeSize,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date:",
              style: gilroyLight.copyWith(
                  color: theme ? white.withOpacity(0.45) : eventGrey,
                  fontSize: dateSize),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              date,
              style: gilroyLight.copyWith(
                  color: theme ? white.withOpacity(0.45) : eventGrey,
                  fontSize: dateSize),
            )
          ],
        ),
        SizedBox(
            height: height,
            child: VerticalDivider(
              thickness: 1,
              color: theme ? grey.withOpacity(0.5) : eventGrey.withOpacity(0.6),
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time:",
              style: gilroyLight.copyWith(
                  color: theme ? white.withOpacity(0.45) : eventGrey,
                  fontSize: dateSize),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              time,
              style: gilroyLight.copyWith(
                  color: theme ? white.withOpacity(0.45) : eventGrey,
                  fontSize: dateSize),
            )
          ],
        ),
      ],
    );
  }
}
