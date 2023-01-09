import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wedding/widgets/splash.dart';

class Splash2 extends StatefulWidget {
  const Splash2({Key? key}) : super(key: key);

  @override
  _Splash2State createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Splash(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeee5d3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "assets/splash_image.jpeg",
                height: 180,
              ),
            ),
          ),
          const Text(
            "From",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Image.asset(
            "assets/weWedIcon.png",
            height: 120,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
