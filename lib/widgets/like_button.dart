import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/theme_provider.dart';

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final double iconSize;
  final double textSize;
  final int likeCount;

  const LikeButton(
      {required this.isLiked,
      required this.iconSize,
      required this.textSize,
      required this.likeCount,
      Key? key})
      : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Row(
      children: [
        widget.isLiked
            ? SvgPicture.asset(
                "icons/filled_heart.svg",
                height: widget.iconSize,
                width: widget.iconSize,
              )
            : theme
                ? SvgPicture.asset(
                    "icons/heart.svg",
                    height: widget.iconSize,
                    width: widget.iconSize,
                  )
                : SvgPicture.asset(
                    "icons/heart.svg",
                    height: widget.iconSize,
                    width: widget.iconSize,
                    color: iconGrey,
                  ),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: AutoSizeText(
            "${widget.likeCount}",
            style: gilroyBold.copyWith(fontSize: widget.textSize),
          ),
        )
      ],
    );
  }
}
