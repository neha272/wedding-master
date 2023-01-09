import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/theme_provider.dart';

class CommentButton extends StatelessWidget {
  final double iconSize;
  final double textSize;
  final int commentCount;

  const CommentButton(
      {required this.iconSize,
      required this.textSize,
      required this.commentCount,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Row(
      children: [
        theme
            ? SvgPicture.asset(
                "icons/comment.svg",
                height: iconSize,
                width: iconSize,
              )
            : SvgPicture.asset(
                "icons/comment.svg",
                height: iconSize,
                width: iconSize,
                color: iconGrey,
              ),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: AutoSizeText(
            "$commentCount",
            style: gilroyBold.copyWith(fontSize: textSize),
          ),
        )
      ],
    );
  }
}
