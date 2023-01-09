import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';

class ThemeModel {

  final light = ThemeData(
    fontFamily: "Gilroy",
    iconTheme: IconThemeData(color: Colors.grey[900]),
    scaffoldBackgroundColor: Colors.transparent,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(secondary: black, primary: black),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      // color: white,
      backgroundColor: white,
      elevation: 0,
      titleTextStyle: gilroyBold.copyWith(fontSize: 20, color: black),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.grey[900],
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.black, width: 3.0),
        insets: EdgeInsets.only(bottom: 5),
      ),
      unselectedLabelColor: Colors.grey[600],
      labelColor: black,
      labelStyle: gilroyBold.copyWith(
        fontSize: 12,
      ),
    ),
  );

  final dark = ThemeData(
    fontFamily: 'Gilroy',
    scaffoldBackgroundColor: const Color(0xff151516),
    colorScheme: ColorScheme.dark(secondary: white, primary: white),
    appBarTheme: AppBarTheme(backgroundColor: scaffoldBlack),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: scaffoldBlack),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.white, width: 2.0),
        insets: EdgeInsets.only(bottom: 5),
      ),
      unselectedLabelColor: Colors.grey[600],
      labelColor: white,
      labelStyle: gilroyBold.copyWith(fontSize: 12),
    ),
  );
}
