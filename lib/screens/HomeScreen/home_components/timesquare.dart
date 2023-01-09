import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/theme_provider.dart';

class TimeSquare extends StatelessWidget {
  final String time;
  final String type;

  const TimeSquare({required this.type, required this.time, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color:
                    theme ? grey.withOpacity(0.1) : timeGrey.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              time,
              style: theme
                  ? gilroyBold.copyWith(fontSize: 16)
                  : gilroyBold.copyWith(color: timeGrey, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              type,
              style: theme
                  ? gilroyLight.copyWith(
                      fontSize: 9, color: grey.withOpacity(0.8))
                  : gilroyLight.copyWith(color: timeGrey, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}
