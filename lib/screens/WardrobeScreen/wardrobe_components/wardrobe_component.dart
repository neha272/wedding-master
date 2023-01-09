import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/models/wardrobe_model.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/widgets/loader.dart';

class WardrobeComponent extends StatelessWidget {
  final WardrobeModel wardrobe;
  final int index;

  const WardrobeComponent({
    required this.index,
    required this.wardrobe,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Container(
      decoration:
          theme ? const BoxDecoration() : BoxDecoration(gradient: greyToWhite),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Stack(
        alignment:
            index % 2 == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        children: [
          Container(
            height: 210,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            padding:
                const EdgeInsets.only(left: 25, bottom: 15, right: 25, top: 15),
            decoration: BoxDecoration(
                color: theme ? grey.withOpacity(0.3) : const Color(0xfff9f9f9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  if (!theme)
                    BoxShadow(
                        color: const Color(0xdc262626).withOpacity(0.08),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(2, 4)),
                ]),
            child: Column(
              crossAxisAlignment: index % 2 == 0
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment:
                      index % 2 == 0 ? Alignment.topLeft : Alignment.topRight,
                  children: [
                    AutoSizeText(
                      wardrobe.eventName,
                      style: theme
                          ? gilroyBold.copyWith(fontSize: 18)
                          : gilroyBold.copyWith(fontSize: 18, color: eventGrey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: AutoSizeText(
                        wardrobe.eventTagline,
                        style: hastan.copyWith(
                            color: Color(
                                int.parse('0xff' + wardrobe.eventTaglineColor)),
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Column(
                    crossAxisAlignment: index % 2 == 0
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: AutoSizeText(
                          "Men:",
                          style: theme
                              ? gilroyBold.copyWith(fontSize: 10)
                              : gilroyBold.copyWith(
                                  fontSize: 10, color: eventGrey),
                        ),
                      ),
                      AutoSizeText(
                        wardrobe.dressCode.forMen,
                        maxLines: 2,
                        style: theme
                            ? gilroyLight.copyWith(
                                fontSize: 10, color: white.withOpacity(0.5))
                            : gilroyLight.copyWith(
                                fontSize: 10,
                                color: eventGrey.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: index % 2 == 0
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: AutoSizeText(
                        "Women:",
                        style: theme
                            ? gilroyBold.copyWith(fontSize: 10)
                            : gilroyBold.copyWith(
                                fontSize: 10, color: eventGrey),
                      ),
                    ),
                    AutoSizeText(
                      wardrobe.dressCode.forWomen,
                      maxLines: 2,
                      style: theme
                          ? gilroyLight.copyWith(
                              fontSize: 10, color: white.withOpacity(0.5))
                          : gilroyLight.copyWith(
                              fontSize: 10, color: eventGrey.withOpacity(0.8)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 30,
              right: 20,
              left: 20,
            ),
            child: CachedNetworkImage(
              imageUrl: StringConstants.apiUrl + wardrobe.dressCode.outFit,
              height: 220,
              width: 141.5,
              placeholder: (_, __) => const Loader(),
              errorWidget: (_, __, ___) => SvgPicture.asset(
                "icons/wardrobe.svg",
                height: 220,
                width: 141.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
