import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/models/feed_model.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/FeedScreen/feed_component/feed_post.dart';

class GuestFeedScreen extends StatefulWidget {
  final List<FeedModel> feed;
  final int index;

  const GuestFeedScreen({required this.feed, required this.index, Key? key})
      : super(key: key);

  @override
  State<GuestFeedScreen> createState() => _GuestFeedScreenState();
}

class _GuestFeedScreenState extends State<GuestFeedScreen> {
  final ScrollController _controller = ScrollController();
  final double _height = 395.0;

  @override
  void initState() {
    super.initState();
    for (var element in widget.feed) {
      if (kDebugMode) {
        log(element.toJson().toString());
      }
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.animateTo(
        widget.index * _height,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    var feed = widget.feed;
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                expandedHeight: 65,
                flexibleSpace: !theme
                    ? Container(
                        decoration: BoxDecoration(gradient: greyToWhite),
                      )
                    : const SizedBox(),
                floating: true,
                snap: true,
                centerTitle: true,
                leading: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: IconButton(
                    onPressed: () {
                      // HomeScreen.pageControl.currentState?.jumpToHome();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      // color: Colors.white,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    "Feed",
                    style: gilroyBold.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ),
                actions: const [
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 10, top: 7),
                  //   child: feed.isUploading
                  //       ? const Center(
                  //     child: SizedBox(
                  //       height: 25,
                  //       width: 25,
                  //       child: CircularProgressIndicator(),
                  //     ),
                  //   )
                  //       : InkWell(
                  //     onTap: () {
                  //       _imagePick();
                  //     },
                  //     child: SvgPicture.asset(
                  //       theme
                  //           ? "icons/add_feed.svg"
                  //           : "icons/add_feed_white.svg",
                  //       height: 45,
                  //       width: 45,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              feed.isNotEmpty
                  ? SliverPadding(
                      padding: const EdgeInsets.only(bottom: 15),
                      sliver: SliverFixedExtentList(
                        itemExtent: 395.0,
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return (index == feed.length)
                              ? const CupertinoActivityIndicator()
                              : Container(
                                  decoration: theme
                                      ? const BoxDecoration()
                                      : BoxDecoration(gradient: greyToWhite),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: FeedPost(
                                    feedModel: feed.elementAt(index),
                                  ),
                                );
                        },
                            childCount:
                                // (maxLimit == page)
                                //     ?
                                feed.length
                            // : feed.feeds.length + 1,
                            ),
                      ),
                    )
                  : const Center(child: Text("Feed not found"))
            ],
          ),
        ),
      ),
    );
  }
}
