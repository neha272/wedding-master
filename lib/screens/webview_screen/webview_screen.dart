import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/dashboard_provider.dart';
import 'package:wedding/widgets/custom_sliverappbar.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          WebView(
            initialUrl:
                context.watch<DashboardProvider>().dashboardModel!.liveLink,
            allowsInlineMediaPlayback: true,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            zoomEnabled: true,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            javascriptChannels: {
              _toasterJavascriptChannel(context),
            },
          ),
        ],
      ),
    );
  }
}

class WebViewBlank extends StatelessWidget {
  const WebViewBlank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const CustomSliverAppBar(title: ""),
            SliverFillRemaining(
              child: Center(
                child: Text(
                  "No live preview available at this time",
                  style: gilroyLight.copyWith(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
