import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/providers/dashboard_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/AuthenticationScreens/login_screen.dart';
import 'package:wedding/screens/HomeScreen/home_screen.dart';
import 'package:wedding/widgets/loader.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    context.read<DashboardProvider>().getDashboard().then((value) {
      if (value.success == true) {
        if (value.data != null) {
          context.read<DashboardProvider>().dashboardModel = value.data!;
          value.data!.isDark
              ? context.read<ThemeProvider>().setDark()
              : context.read<ThemeProvider>().setLight();
          context.read<ThemeProvider>().gradient = LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(int.parse("0xff" + value.data!.secondaryColor.first)),
                Color(int.parse("0xff" + value.data!.secondaryColor.last)),
              ]);
        }
        checkLoginStatus();
      }
      //checkLoginStatus();
    });
  }

  checkLoginStatus() async {
    print("splash");
    sharedPrefs.isLogin().then((value) {
      if (value) {
        nextScreenReplace(context, HomeScreen());
      } else {
        nextScreenReplace(context, const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Loader();
  }
}
