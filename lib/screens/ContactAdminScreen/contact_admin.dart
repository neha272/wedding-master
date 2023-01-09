import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/theme_provider.dart';

class ContactAdmin extends StatelessWidget {
  const ContactAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Container(
      decoration:
          theme ? const BoxDecoration() : BoxDecoration(gradient: greyToWhite),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset(
              'assets/loader/contact.json',
              repeat: true,
            ),
            AutoSizeText(
              "Contact admin",
              style: gilroyLight.copyWith(
                fontSize: 22,
              ),
            )
          ],
        ),
      ),
    );
  }
}
