import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/providers/event_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/widgets/custom_sliverappbar.dart';
import 'package:wedding/widgets/loader.dart';

import 'event_components/event_component.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    var events = context.watch<EventProvider>().events;
    return Container(
      decoration: BoxDecoration(gradient: greyToWhite),
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<EventProvider>().getEvents();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CustomSliverAppBar(
                  title: "Events",
                ),
                !context.watch<EventProvider>().isLoaded
                    ? const SliverFillRemaining(child: Loader())
                    : context.watch<EventProvider>().events.isNotEmpty
                        ? SliverFixedExtentList(
                            itemExtent: 174.0,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int eindex) {
                                return Container(
                                  decoration: !theme
                                      ? BoxDecoration(gradient: greyToWhite)
                                      : const BoxDecoration(),
                                  child: EventComponent(
                                    cIndex: eindex,
                                    event: events.elementAt(eindex),
                                  ),
                                );
                              },
                              childCount: events.length,
                            ),
                          )
                        : const SliverFillRemaining(
                            child: Center(child: Text("Data not found...")))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
