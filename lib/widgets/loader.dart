import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        // 'https://assets5.lottiefiles.com/packages/lf20_hbnazxec.json'
        'assets/loader/loader.json',
        repeat: true,
      ),
    );
  }
}
