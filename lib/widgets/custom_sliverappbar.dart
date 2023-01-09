import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/theme_provider.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;

  const CustomSliverAppBar({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return SliverAppBar(
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

              if (Navigator.canPop(context)) Navigator.pop(context);

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
          title,
          style: gilroyBold.copyWith(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
