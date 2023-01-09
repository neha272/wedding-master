import 'package:flutter/cupertino.dart';

nextScreen(context, page) {
  return Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(context,
      CupertinoPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (context) => page));
}
