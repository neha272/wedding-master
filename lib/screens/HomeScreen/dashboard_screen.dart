import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/general/show_notification.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/dashboard_provider.dart';
import 'package:wedding/providers/event_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/AddNewWedding/add_new_wedding.dart';
import 'package:wedding/screens/EventScreen/event_screen.dart';
import 'package:wedding/screens/GalleryScreen/gallery_screen.dart';
import 'package:wedding/screens/NotificationScreen/notification_screen.dart';
import 'package:wedding/screens/ProfileScreen/profile_screen.dart';
import 'package:wedding/screens/VideoScreen/video_screen.dart';
import 'package:wedding/screens/WardrobeScreen/wardrobe_screen.dart';
import 'package:wedding/screens/webview_screen/in_app_webview.dart';
import 'package:wedding/screens/webview_screen/webview_screen.dart';
import 'package:wedding/widgets/countdown.dart';
import 'package:wedding/widgets/loader.dart';
import 'package:wedding/widgets/user_button.dart';

import 'home_components/clay_icon.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin<DashboardScreen> {
  List banners = [];

  List bottomBanner = [];

  final CarouselController _controller = CarouselController();

  int _current = 0;

  Duration? duration;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    ShowNotification.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    _loadEvents();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage("assets/thumbnail.jpeg"),context);

  }

  _loadData() async {
    await Provider.of<DashboardProvider>(context, listen: false)
        .getDashboard()
        .then((value) {
      if (value.success == true) {
        if (value.data != null) {
          setState(() {
            duration = value.data!.weddingDate.difference(DateTime.now());
            banners = value.data!.banner;
            bottomBanner = value.data!.invitationCard;
          });
        }
      }
    });
  }

  _loadEvents() {
    Provider.of<EventProvider>(context, listen: false).getEvents();
  }

  bool isVideo(String filename) {
    if (filename.contains("mkv")) {
      return true;
    }
    if (filename.contains("mp4")) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = context.watch<ThemeProvider>().darkTheme;
    var dashboard = context.watch<DashboardProvider>();
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: SafeArea(
          child: !dashboard.isLoaded
              ? const Loader()
              : dashboard.dashboardModel == null
                  ? const Center(
                      child: Text("Data load failed"),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await _loadData();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 30, right: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  UserButton(
                                    url: sharedPrefs.guestProfileImage,
                                    size: 45,
                                    pushScreen: () {
                                      nextScreen(
                                          context, const AddNewWedding());
                                    },
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          nextScreen(context,
                                              const NotificationScreen());
                                        },
                                        child: SvgPicture.asset(
                                          theme
                                              ? "icons/bell.svg"
                                              : "icons/white_bell.svg",
                                          height: 45,
                                          width: 45,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            HomeScreen.pageControl.currentState!
                                                .jumpToFeed();
                                          },
                                          child: SvgPicture.asset(
                                            theme
                                                ? "icons/feed.svg"
                                                : "icons/white_feed.svg",
                                            height: 45,
                                            width: 45,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (duration != null)
                              if (!duration!.isNegative)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width *
                                        0.84,
                                    padding: const EdgeInsets.only(
                                        top: 25,
                                        left: 30,
                                        bottom: 25,
                                        right: 30),
                                    decoration: BoxDecoration(
                                        color: theme ? white : black,
                                        gradient:
                                            theme ? blackToBlack : greyToWhite,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          if (!theme)
                                            const BoxShadow(
                                                color: Color(0x66a9aaaf),
                                                spreadRadius: 8,
                                                blurRadius: 8,
                                                offset: Offset(3, 3),
                                                blurStyle: BlurStyle.normal),
                                          if (!theme)
                                            const BoxShadow(
                                                color: Color(0xd3ffffff),
                                                spreadRadius: 15,
                                                blurRadius: 15,
                                                offset: Offset(-3, -3),
                                                blurStyle: BlurStyle.normal),
                                        ]),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(
                                                "Time",
                                                style: theme
                                                    ? gilroyBold
                                                    : gilroyBold.copyWith(
                                                        color: timeGrey),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(
                                                "remaining",
                                                style: theme
                                                    ? gilroyLight
                                                    : gilroyLight.copyWith(
                                                        color: timeGrey),
                                              ),
                                            ),
                                            const Spacer(),
                                            CountDown(duration: duration!),
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 70,
                                          width: 70,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: theme
                                                ? white
                                                : timeGrey.withOpacity(0.07),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: dashboard.dashboardModel!
                                                    .marriageLogo.isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        StringConstants.apiUrl +
                                                            dashboard
                                                                .dashboardModel!
                                                                .marriageLogo,
                                                    placeholder:
                                                        (context, url) => Text(
                                                      'LOGO',
                                                      style: greyBold.copyWith(
                                                          color: black),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Text(
                                                      'LOGO',
                                                      style: greyBold.copyWith(
                                                          color: black),
                                                    ),
                                                  )
                                                : Text(
                                                    'LOGO',
                                                    style: greyBold.copyWith(
                                                        color: black),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            banners.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      "#" +
                                          dashboard
                                              .dashboardModel!.weddingHashtag,
                                      style: gilroyBold.copyWith(
                                        fontSize: 20,
                                        color: theme
                                            ? white.withOpacity(0.12)
                                            : eventGrey.withOpacity(0.3),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Stack(
                                      alignment: Alignment.topLeft,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 35.0, bottom: 10),
                                          child: Text(
                                            "#" +
                                                dashboard.dashboardModel!
                                                    .weddingHashtag,
                                            style: gilroyBold.copyWith(
                                              fontSize: 20,
                                              color: theme
                                                  ? white.withOpacity(0.12)
                                                  : eventGrey.withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: CarouselSlider.builder(
                                            options: CarouselOptions(
                                              enlargeStrategy:
                                                  CenterPageEnlargeStrategy
                                                      .height,
                                              //height: 220,
                                              aspectRatio: 1.78,
                                              viewportFraction: 0.87,
                                              autoPlay: true,
                                              enlargeCenterPage: true,
                                            ),
                                            itemCount: banners.length,
                                            itemBuilder: (context, itemIndex,
                                                realIndex) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // clipBehavior: Clip.antiAlias,
                                                margin: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 14.0,
                                                    top: 14),
                                                decoration: theme
                                                    ? BoxDecoration(
                                                        color: scaffoldBlack,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Color(
                                                                  0xff332e34),
                                                              blurRadius: 6,
                                                              spreadRadius: 1,
                                                              offset: Offset(
                                                                  -2, -2)),
                                                          BoxShadow(
                                                              color: Color(
                                                                  0xff050509),
                                                              blurRadius: 6,
                                                              spreadRadius: 2,
                                                              offset:
                                                                  Offset(3, 3)),
                                                        ],
                                                      )
                                                    : BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        gradient: greyToWhite,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    -2, -2),
                                                            blurRadius: 6,
                                                            spreadRadius: 2,
                                                            color: white,
                                                          ),
                                                          BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    3, 3),
                                                            blurRadius: 6,
                                                            spreadRadius: 1,
                                                            color: grey
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ],
                                                      ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 11),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    child: isVideo(
                                                            banners.elementAt(
                                                                itemIndex))
                                                        ? GestureDetector(
                                                            behavior:
                                                                HitTestBehavior
                                                                    .opaque,
                                                            onTap: () {
                                                              nextScreen(
                                                                context,
                                                                VideoScreen(
                                                                    url:
                                                                        "${StringConstants.apiUrl}${banners.elementAt(itemIndex)}"),
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration: theme
                                                                  ? BoxDecoration(
                                                                      color:
                                                                          black)
                                                                  : BoxDecoration(
                                                                      color:
                                                                          white),
                                                              child: Center(
                                                                child: Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    Image.asset(
                                                                        "assets/thumbnail.jpeg",fit: BoxFit.fill,height: 1080,width: 1920,),
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .play,
                                                                      size: 30,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : CachedNetworkImage(
                                                            imageUrl:
                                                                "${StringConstants.apiUrl}${banners.elementAt(itemIndex)}",
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(),
                                                          ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClayIcon(
                                    name: "Events",
                                    path: theme
                                        ? "icons/events.svg"
                                        : "icons/events_grey.svg",
                                    pushTo: const EventScreen(),
                                  ),
                                  ClayIcon(
                                    name: "Wardrobe\nPlanner",
                                    path: theme
                                        ? "icons/angle.svg"
                                        : "icons/angle_grey.svg",
                                    pushTo: const WardrobeScreen(),
                                  ),
                                  ClayIcon(
                                    name: "Gallery",
                                    path: theme
                                        ? "icons/gallery.svg"
                                        : "icons/gallery_grey.svg",
                                    pushTo: const GalleryScreen(
                                      index: 0,
                                    ),
                                  ),
                                  ClayIcon(
                                    name: "View\nLive",
                                    path: theme
                                        ? "icons/eye.svg"
                                        : "icons/eye_grey.svg",
                                    url:
                                        dashboard.dashboardModel!.liveLink != ""
                                            ? dashboard.dashboardModel!.liveLink
                                            : null,
                                    pushTo: (dashboard.dashboardModel != null &&
                                            dashboard
                                                    .dashboardModel!.liveLink !=
                                                "")
                                        ? const InAppWebViewScreen()
                                        : const WebViewBlank(),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                AutoSizeText(
                                  "#" +
                                      dashboard.dashboardModel!.weddingHashtag,
                                  maxLines: 1,
                                  style: theme
                                      ? gilroyBold.copyWith(
                                          fontSize: 32,
                                          color: black.withOpacity(0.27))
                                      : gilroyBold.copyWith(
                                          fontSize: 32,
                                          color: black.withOpacity(0.11)),
                                ),
                                AutoSizeText(
                                  "Itinerary",
                                  style: theme
                                      ? hastan.copyWith(
                                          color: context
                                              .watch<ThemeProvider>()
                                              .secondaryColor,
                                          fontSize: 32)
                                      : hastan.copyWith(
                                          color: context
                                              .watch<ThemeProvider>()
                                              .secondaryColor
                                              .withOpacity(0.58),
                                          fontSize: 32),
                                )
                              ],
                            ),
                            bottomBanner.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, left: 8, right: 8, top: 8),
                                    child: CarouselSlider(
                                      carouselController: _controller,
                                      options: CarouselOptions(
                                        height: 460.0,
                                        aspectRatio: 16 / 9,
                                        enlargeCenterPage: true,
                                        viewportFraction: 0.9,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        autoPlay: true,
                                        enlargeStrategy:
                                            CenterPageEnlargeStrategy.height,
                                      ),
                                      items: bottomBanner.map((
                                        bannerData,
                                      ) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  margin: const EdgeInsets.only(
                                                      left: 4,
                                                      right: 4,
                                                      top: 3,
                                                      bottom: 3),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        grey.withOpacity(0.01),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14.0),
                                                    boxShadow: [
                                                      if (theme)
                                                        const BoxShadow(
                                                            color: Color(
                                                                0xff332e34),
                                                            blurRadius: 6,
                                                            spreadRadius: 1,
                                                            offset:
                                                                Offset(-2, -2)),
                                                      if (theme)
                                                        const BoxShadow(
                                                            color: Color(
                                                                0xff050509),
                                                            blurRadius: 6,
                                                            spreadRadius: 2,
                                                            offset:
                                                                Offset(3, 3)),
                                                      if (!theme)
                                                        BoxShadow(
                                                          offset: const Offset(
                                                              -2, -2),
                                                          blurRadius: 6,
                                                          spreadRadius: 2,
                                                          color: white,
                                                        ),
                                                      if (!theme)
                                                        BoxShadow(
                                                          offset: const Offset(
                                                              3, 3),
                                                          blurRadius: 6,
                                                          spreadRadius: 1,
                                                          color: grey
                                                              .withOpacity(0.3),
                                                        ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    decoration: theme
                                                        ? BoxDecoration(
                                                            color:
                                                                scaffoldBlack,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14.0),
                                                          )
                                                        : BoxDecoration(
                                                            color: white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14.0),
                                                            gradient:
                                                                greyToWhiteDiagonal,
                                                          ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              "${StringConstants.apiUrl}$bannerData",
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 190.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: black,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: lightBlack,
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: grey
                                                                  .withOpacity(
                                                                      0.4),
                                                            ),
                                                            child: const Icon(Icons
                                                                .broken_image),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  bottomBanner.asMap().entries.map((entry) {
                                return GestureDetector(
                                  onTap: () =>
                                      _controller.animateToPage(entry.key),
                                  child: Container(
                                    width: 7.0,
                                    height: 7.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black)
                                            .withOpacity(_current == entry.key
                                                ? 0.9
                                                : 0.4)),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 42)
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
