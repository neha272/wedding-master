import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/helper_functions.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/models/events_model.dart';
import 'package:wedding/providers/event_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/EventScreen/event_components/event_dialog.dart';

import 'date_time_event.dart';

class EventComponent extends StatelessWidget {
  final EventModel event;
  final int cIndex;

  const EventComponent({required this.event, Key? key, required this.cIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return InkWell(
      onTap: () {
        Provider.of<EventProvider>(context, listen: false).currentIndex =
            cIndex;
        if (kDebugMode) {
          print(cIndex);
        }
        eventDialog(context, event);
      },
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        padding:
            const EdgeInsets.only(left: 32, bottom: 32, right: 32, top: 30),
        decoration: theme
            ? BoxDecoration(
                color: mediumBlack,
                borderRadius: BorderRadius.circular(24),
              )
            : BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(-2, -2),
                    blurRadius: 6,
                    spreadRadius: 2,
                    color: white,
                  ),
                  BoxShadow(
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                    spreadRadius: 1,
                    color: grey.withOpacity(0.3),
                  ),
                ],
                gradient: greyToWhite,
              ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  event.eventName,
                  style: theme
                      ? gilroyBold.copyWith(fontSize: 18)
                      : gilroyBold.copyWith(fontSize: 18, color: eventGrey),
                ),
                Icon(
                  Icons.east,
                  color: theme ? grey.withOpacity(0.5) : eventGrey,
                  size: 18,
                )
              ],
            ),
            DateTimeEvent(
              height: 30,
              time: event.eventTime + " onwards",
              date: format(event.eventDate),
              dateSize: 12,
              timeSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
