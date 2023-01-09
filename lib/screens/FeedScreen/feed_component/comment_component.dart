import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/models/comment_model.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/widgets/user_button.dart';

class CommentComponent extends StatelessWidget {
  final CommentModel commentData;

  const CommentComponent({Key? key, required this.commentData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Container(
      // height: 125,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.only(top: 4, right: 14, left: 14, bottom: 20),
      decoration: BoxDecoration(
          color: theme ? white.withOpacity(0.1) : grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          // gradient: greyToWhite,
          boxShadow: [
            if (!theme)
              BoxShadow(
                  color: white.withOpacity(0.15),
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: const Offset(0, -2)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                  ),
                  child: UserButton(
                    size: 55,
                    url: commentData.guestProfileImage,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      commentData.guestName,
                      style: gilroyBold.copyWith(
                          fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            DateFormat('d/MM/yyyy').format(commentData.time),
                            minFontSize: 8,
                            style: gilroyLight.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: grey),
                          ),
                          AutoSizeText(
                            DateFormat(', hh:mm a').format(commentData.time),
                            minFontSize: 8,
                            style: gilroyLight.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: grey),
                          ),
                        ],
                      ),
                    ),
                    /* Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: AutoSizeText(
                        "10/02/2021, 08:15 pm",
                        style: gilroyLight.copyWith(
                            fontSize: 11, color: grey.withOpacity(0.5)),
                        minFontSize: 9,
                      ),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10),
            child: AutoSizeText(
              commentData.commentText,
              style: gilroyLight.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
