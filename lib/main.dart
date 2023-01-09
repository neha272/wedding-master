import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wedding/models/theme_model.dart';
import 'package:wedding/providers/dashboard_provider.dart';
import 'package:wedding/providers/event_provider.dart';
import 'package:wedding/providers/feed_provider.dart';
import 'package:wedding/providers/galleryProvider.dart';
import 'package:wedding/providers/notification_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/providers/user_feed_provider.dart';
import 'package:wedding/providers/user_provider.dart';
import 'package:wedding/providers/wardrobe_provider.dart';
import 'package:wedding/screens/AddNewWedding/add_new_wedding.dart';
import 'package:wedding/widgets/splash.dart';
import 'general/shared_preferences.dart';
import 'providers/guest_provider.dart';
import 'providers/network_provider.dart';

/*Marriage Id*/
late String marriageId;

void myApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runApp(
    const MyApp(),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (_, mode, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => DashboardProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => EventProvider(),
              ),
              StreamProvider(
                  create: (context) =>
                      NetworkStatusService().networkStatusController.stream,
                  initialData: NetworkStatus.online),
              ChangeNotifierProvider(
                create: (context) => UserProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => WardrobeProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => GalleryProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => FeedProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => NotificationProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => UserFeedProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => GuestProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => WeddingProvider(),
              ),
            ],
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeModel().light,
                darkTheme: ThemeModel().dark,
                themeMode:
                    mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
                home: const Splash()),
          );
        },
      ),
    );
  }
}

Future<void> _messageHandler(RemoteMessage message) async {
  log("--> ${message.data}");
}
