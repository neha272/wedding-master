import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/providers/notification_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/NotificationScreen/notification_components/notification_component.dart';
import 'package:wedding/widgets/custom_sliverappbar.dart';
import 'package:wedding/widgets/loader.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int page = 1;
  int maxLimit = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      // if (!context.read<NotificationProvider>().isLoaded) {
      context.read<NotificationProvider>().getNotifications(1).then((value) {
        if (value.pagination != null) {
          setState(() {
            maxLimit = value.pagination!.last!.page;
          });
        }
      });
      // }
    });
  }

  loadMoreData() {
    if (page < maxLimit) {
      setState(() {
        page++;
      });
      context.read<NotificationProvider>().getNotifications(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    var listNotification = context.watch<NotificationProvider>().notifications;
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: SafeArea(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.maxScrollExtent ==
                  scrollNotification.metrics.pixels) {
                loadMoreData();
              }
              return false;
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CustomSliverAppBar(
                  title: "Notification",
                ),
                !context.watch<NotificationProvider>().isLoaded
                    ? const SliverFillRemaining(
                        child: Loader(),
                      )
                    : listNotification.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return (index == listNotification.length)
                                    ? const CupertinoActivityIndicator()
                                    : Container(
                                        decoration: theme
                                            ? const BoxDecoration()
                                            : BoxDecoration(
                                                gradient: greyToWhite),
                                        child: NotificationComponent(
                                          notification:
                                              listNotification[index],
                                        ),
                                      );
                              },
                              childCount: (maxLimit == page)
                                  ? listNotification.length
                                  : listNotification.length + 1,
                            ),
                          )
                        : const SliverFillRemaining(
                            child: Center(
                              child: Text("Notification data not found"),
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
