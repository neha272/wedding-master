import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;

  Color secondaryColor = const Color(0xffbd3042);

  Gradient gradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xfff3686d),
        Color(0xffed2831),
      ]);

  //todo remove this
  toggleTheme() {
    _darkTheme = !_darkTheme;
    notifyListeners();
  }

  setDark() {
    _darkTheme = true;
    notifyListeners();
  }

  setLight() {
    _darkTheme = false;
    notifyListeners();
  }

//todo make a shared prefs

}
