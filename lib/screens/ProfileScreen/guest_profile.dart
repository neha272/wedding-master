import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/guest_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/ProfileScreen/profile_components/square_image_guest.dart';
import 'package:wedding/widgets/loader.dart';
import 'package:wedding/widgets/user_button.dart';

class GuestProfileScreen extends StatefulWidget {
  final String guestId;

  const GuestProfileScreen({required this.guestId, Key? key}) : super(key: key);

  @override
  State<GuestProfileScreen> createState() => _GuestProfileScreenState();
}

class _GuestProfileScreenState extends State<GuestProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<GuestProvider>().getGuestData(guestId: widget.guestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    var guest = context.watch<GuestProvider>();
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
                      "Guest Profile",
                      style: gilroyBold.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                if (!(guest.isLoading || guest.guest == null))
                  SliverAppBar(
                    elevation: 0,
                    toolbarHeight: 140,
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    flexibleSpace: Container(
                      padding: const EdgeInsets.only(top: 10),
                      decoration: theme
                          ? const BoxDecoration()
                          : BoxDecoration(
                              gradient: greyToWhite,
                            ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, right: 20, left: 20, bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: theme
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: mediumBlack,
                                  )
                                : BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: greyToWhite,
                                    boxShadow: [
                                        BoxShadow(
                                            color: white.withOpacity(0.3),
                                            blurRadius: 2,
                                            spreadRadius: 2,
                                            offset: const Offset(-2, -2)),
                                        BoxShadow(
                                            color: grey.withOpacity(0.15),
                                            blurRadius: 2,
                                            spreadRadius: 2,
                                            offset: const Offset(2, 2)),
                                      ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                UserButton(
                                  size: 70,
                                  url: "${guest.guest?.guestProfileImage}",
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: AutoSizeText(
                                    "${guest.guest?.guestName}",
                                    style: theme
                                        ? gilroyBold.copyWith(fontSize: 16)
                                        : gilroyBold.copyWith(
                                            fontSize: 16, color: eventGrey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ];
            },
            body: guest.isLoading || guest.guest == null
                ? const Center(
                    child: Loader(),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: guest.guest!.feeds.isEmpty
                        ? const Center(child: Text("No Posts..."))
                        : SquareImageGuest(
                            images: guest.guest!.feeds,
                          ),
                  ),
          ),
        ),
      ),
    );
  }
}
