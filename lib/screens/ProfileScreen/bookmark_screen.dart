import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/providers/user_feed_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/widgets/custom_sliverappbar.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<UserFeedProvider>().getBookMarkedFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  const CustomSliverAppBar(
                    title: "BookMarked",
                  ),
                ];
              },
              body: Container(
                decoration: theme
                    ? const BoxDecoration()
                    : BoxDecoration(gradient: greyToWhite),
                padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<UserFeedProvider>().getBookMarkedFeed();
                  },
                  child: context.watch<UserFeedProvider>().bookMarkedFeed.isNotEmpty? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: context
                        .watch<UserFeedProvider>()
                        .bookMarkedFeed
                        .length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: theme ? mediumBlack : white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: StringConstants.apiUrl +
                              context
                                  .watch<UserFeedProvider>()
                                  .bookMarkedFeed
                                  .elementAt(index),
                          // fit: BoxFit.fill,
                          height: 100,
                          width: 100,
                          placeholder: (context, url) => Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: theme ? mediumBlack : white,
                            ),
                            child: const CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.dashboard),
                        ),
                      ),
                    ),
                  ):const Center(child: Text("Bookmarked images not found...")),
                ),
              )),
        ),
      ),
    );
  }
}
