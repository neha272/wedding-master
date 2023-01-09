import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/dashboard_provider.dart';
import 'package:wedding/providers/theme_provider.dart';

class ClayIcon extends StatefulWidget {
  final String path;
  final Widget pushTo;
  final String name;
  final String? url;

  const ClayIcon(
      {required this.name,
      required this.path,
      required this.pushTo,
      this.url,
      Key? key})
      : super(key: key);

  @override
  State<ClayIcon> createState() => _ClayIconState();
}

class _ClayIconState extends State<ClayIcon> {
  final MyInAppBrowser browser = MyInAppBrowser();

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () async {
          if (widget.url != null) {
            // launch("$url");

            await browser.openUrlRequest(
                urlRequest: URLRequest(
                    url: Uri.parse(context
                        .read<DashboardProvider>()
                        .dashboardModel!
                        .liveLink)),
                options: InAppBrowserClassOptions(
                    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  useOnLoadResource: true,
                ))));
          } else {
            nextScreen(context, widget.pushTo);
          }
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  theme ? "icons/back.svg" : "icons/white_back.svg",
                  height: 58,
                  width: 58,
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    // decoration: BoxDecoration(
                    //     color: grey.withOpacity(0.1),
                    //     borderRadius: BorderRadius.circular(8)),
                    child: SvgPicture.asset(
                      widget.path,
                      width: 22,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.name,
                style: poppinsBold.copyWith(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser(
      {int? windowId, UnmodifiableListView<UserScript>? initialUserScripts})
      : super(windowId: windowId, initialUserScripts: initialUserScripts);

  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {
    print("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    print("\n\nStopped $url\n\n");
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    print("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(response) {
    print("Started at: " +
        response.startTime.toString() +
        "ms ---> duration: " +
        response.duration.toString() +
        "ms " +
        (response.url ?? '').toString());
  }

  @override
  void onConsoleMessage(consoleMessage) {
    print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
  }
}
