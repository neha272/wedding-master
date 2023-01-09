import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/providers/theme_provider.dart';

class UserButton extends StatelessWidget {
  final double size;
  final String? url;
  final Function? pushScreen;

  const UserButton({required this.size, this.pushScreen, Key? key, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return GestureDetector(
      onTap: () {
        if (pushScreen != null) {
          pushScreen!();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            theme ? "icons/user.svg" : "icons/white_user.svg",
            height: size,
            width: size,
          ),
          Container(
            height: size * 0.58,
            width: size * 0.58,
            decoration: BoxDecoration(
              gradient: context.watch<ThemeProvider>().gradient,
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: '${StringConstants.apiUrl}$url',
                height: size * 0.59,
                width: size * 0.59,
                fit: BoxFit.cover,
                errorWidget: (_, __, error) => Padding(
                  padding: const EdgeInsets.all(3),
                  child: SvgPicture.asset(
                    "icons/user_icon.svg",
                    height: size * 0.44,
                    width: size * 0.44,
                  ),
                ),
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),
          if (url == null)
            SvgPicture.asset(
              "icons/user_icon.svg",
              height: size * 0.44,
              width: size * 0.44,
            ),
        ],
      ),
    );
  }
}
