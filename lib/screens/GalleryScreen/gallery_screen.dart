import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/event_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/GalleryScreen/gallery_tabs/all_tab.dart';
import 'package:wedding/widgets/GradientTabIndicator.dart';

class GalleryScreen extends StatefulWidget {
  final int index;

  const GalleryScreen({required this.index, Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      if (!context.read<EventProvider>().isLoaded) {
        context.read<EventProvider>().getEvents();
      }
    });
    tabController = TabController(
        vsync: this,
        length: context.read<EventProvider>().events.length + 1,
        initialIndex: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;

    return Container(
      decoration: BoxDecoration(gradient: greyToWhite),
      child: Scaffold(
        body: SafeArea(
          child: DefaultTabController(
            length: Provider.of<EventProvider>(context).events.length + 1,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  expandedHeight: 100,
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
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.back,
                      ),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "Gallery",
                      style: gilroyBold.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight - 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TabBar(
                          controller: tabController,
                          isScrollable: true,
                          physics: const BouncingScrollPhysics(),
                          indicatorWeight: 2,
                          indicator: MyCustomIndicator(
                            color: theme ? Colors.white : Colors.black,
                            height: 1,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          unselectedLabelColor: Colors.grey[600],
                          labelStyle: gilroyBold.copyWith(fontSize: 13),
                          tabs: List.generate(
                              Provider.of<EventProvider>(context)
                                      .events
                                      .length +
                                  1,
                              (index) => index == 0
                                  ? SizedBox(
                                      height: kTextTabBarHeight - 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                          Text("All"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: kTextTabBarHeight - 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(Provider.of<EventProvider>(
                                                  context)
                                              .events
                                              .elementAt(index - 1)
                                              .eventName),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                        ],
                                      ),
                                    )),
                        ),
                      ),
                    ),
                  ),
                )
              ],
              floatHeaderSlivers: true,
              body: TabBarView(
                  controller: tabController,
                  children: List.generate(
                    Provider.of<EventProvider>(context).events.length + 1,
                    (index) => AllTab(
                      index: index,
                    ),
                  ).toList()),
            ),
          ),
        ),
      ),
    );
  }
}
