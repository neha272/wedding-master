// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/helper_functions.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/models/events_model.dart';
import 'package:wedding/providers/event_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/GalleryScreen/gallery_screen.dart';
import 'package:wedding/widgets/date_time_row.dart';

eventDialog(context, EventModel event) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
    ),
    context: context,
    builder: (ctx) {
      return EventBottomSheet(
        event: event,
      );
    },
  );
}

class EventBottomSheet extends StatefulWidget {
  EventModel event;

  EventBottomSheet({
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  State<EventBottomSheet> createState() => _EventBottomSheetState();
}

class _EventBottomSheetState extends State<EventBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    final _provider = Provider.of<EventProvider>(context);
    final int index = _provider.currentIndex;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          height: 60,
          width: MediaQuery.of(context).size.width * 0.85,
          margin: const EdgeInsets.only(top: 35, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
              color: yellow, borderRadius: BorderRadius.circular(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    if (index == 0) {
                      setState(() {
                        widget.event = _provider.events
                            .elementAt(_provider.events.length - 1);
                      });
                      _provider.currentIndex = _provider.events.length - 1;
                    } else {
                      setState(() {
                        widget.event = _provider.events.elementAt(index - 1);
                      });
                      _provider.currentIndex = index - 1;
                    }

                    /* var _provider =
                        Provider.of<EventProvider>(context, listen: false)
                            .events;
                    setState(() {
                      widget.event = _provider.elementAt(_provider.indexWhere(
                                      (element) =>
                                          element.eventName ==
                                          widget.event.eventName) -
                                  1 >=
                              0
                          ? _provider.indexWhere((element) =>
                                  element.eventName == widget.event.eventName) -
                              1
                          : _provider.length - 1);
                    });*/
                  },
                  icon: Icon(
                    CupertinoIcons.back,
                    color: black,
                    size: 16,
                  )),
              AutoSizeText(
                widget.event.eventName,
                style: gilroyBold.copyWith(fontSize: 18, color: black),
              ),
              IconButton(
                onPressed: () {
                  if (index == _provider.events.length - 1) {
                    setState(() {
                      widget.event = _provider.events.elementAt(0);
                    });
                    _provider.currentIndex = 0;
                  } else {
                    setState(() {
                      widget.event = _provider.events.elementAt(index + 1);
                    });
                    _provider.currentIndex = index + 1;
                  }
                  /*   var _provider =
                      Provider.of<EventProvider>(context, listen: false).events;
                  widget.event = _provider.elementAt(_provider.indexWhere(
                                  (element) =>
                                      element.eventName ==
                                      widget.event.eventName) +
                              1 <=
                          _provider.length - 1
                      ? _provider.indexWhere((element) =>
                              element.eventName == widget.event.eventName) +
                          1
                      : 0);*/
                },
                icon: Icon(
                  CupertinoIcons.forward,
                  color: black,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: DateTimeRow(
              height: 25,
              time: widget.event.eventTime + " onwards",
              date: format(widget.event.eventDate),
              dateSize: 13,
              timeSize: 13,
            ),
          ),
        ),
        widget.event.isDressCode == true
            ? Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.85,
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                decoration: theme
                    ? BoxDecoration(
                        color: const Color(0xff1f2021),
                        borderRadius: BorderRadius.circular(5),
                      )
                    : BoxDecoration(
                        color: const Color(0x80dedfe6),
                        borderRadius: BorderRadius.circular(5),
                        // gradient: greyToWhite),
                      ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: AutoSizeText(
                          "DRESS CODE",
                          style: theme
                              ? gilroyBold
                              : gilroyBold.copyWith(color: eventGrey),
                        ),
                      ),
                      AutoSizeText(
                        widget.event.eventTagline,
                        style: hastan.copyWith(
                            color: Color(int.parse(
                                '0xff' + widget.event.eventTaglineColor)),
                            fontSize: 21),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  "Men:",
                                  style: theme
                                      ? gilroyBold
                                      : gilroyBold.copyWith(color: eventGrey),
                                ),
                                const SizedBox(height: 5),
                                AutoSizeText(
                                  widget.event.dressCode!.forMen,
                                  style: gilroyLight.copyWith(
                                      color: theme
                                          ? white.withOpacity(0.45)
                                          : grey,
                                      height: 1.1),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 0,
                              child: VerticalDivider(
                                thickness: 1,
                                color: theme
                                    ? grey.withOpacity(0.5)
                                    : eventGrey.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  "Women:",
                                  style: theme
                                      ? gilroyBold
                                      : gilroyBold.copyWith(color: eventGrey),
                                ),
                                const SizedBox(height: 5),
                                AutoSizeText(
                                  widget.event.dressCode!.forWomen,
                                  style: gilroyLight.copyWith(
                                      color: theme
                                          ? white.withOpacity(0.45)
                                          : grey,
                                      height: 1.1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Venue:",
                  style: theme
                      ? gilroyBold.copyWith(fontSize: 15)
                      : gilroyBold.copyWith(color: eventGrey, fontSize: 15),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: AutoSizeText(
                    widget.event.eventVenue,
                    style: theme
                        ? gilroyLight.copyWith(
                            height: 1.5,
                            fontSize: 13,
                            color: white.withOpacity(0.45))
                        : gilroyLight.copyWith(
                            height: 1.5,
                            fontSize: 13,
                            color: eventGrey,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 17.0, bottom: 39),
          child: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryScreen(
                        index: Provider.of<EventProvider>(
                              context,
                            ).currentIndex +
                            1),
                  ));
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.85,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4,
                ),
                border: Border.all(
                  width: 1.2,
                  color: grey.withOpacity(0.3),
                ),
              ),
              child: AutoSizeText(
                "view gallery",
                style: gilroyLight.copyWith(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
