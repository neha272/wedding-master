import 'dart:developer';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/theme_provider.dart';

class GalleryImage extends StatefulWidget {
  final List imageData;
  final int currentIndex;

  const GalleryImage(
      {Key? key, required this.imageData, required this.currentIndex})
      : super(key: key);

  @override
  State<GalleryImage> createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {
  late PageController imageController;
  late int currentImageIndex = 0;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    currentImageIndex = widget.currentIndex;
    imageController = PageController(initialPage: currentImageIndex);
  }

  Future<bool> _checkPermission() async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      return true;
    } else {
      await Permission.storage.request();
      return false;
    }
  }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  _asyncMethod() async {
    await _checkPermission().then((value) {
      if (value == false) {
        Fluttertoast.showToast(msg: "permisson is denied");
        return;
      }
    });
    try {
      setState(() {
        isDownloading = true;
      });
      var url = StringConstants.apiUrl +
          widget.imageData.elementAt(currentImageIndex); // <-- 1
      if (Platform.isAndroid) {
        var response = await get(Uri.parse(url)); // <--2

        // var documentDirectory = await getApplicationDocumentsDirectory();
        // var firstPath = documentDirectory.path + "/images";
        // var filePathAndName = documentDirectory.path + '/images/pic.jpg';
        //comment out the next three lines to prevent the image from being saved
        //to the device to show that it's coming from the internet

        final dir = await _findLocalPath(); //From path_provider package
        var _localPath = dir!;
        await Directory(_localPath).create(recursive: true); // <-- 1
        File file2 = File(_localPath +
            '/' +
            widget.imageData.elementAt(currentImageIndex).split("/").last);

        file2.writeAsBytesSync(response.bodyBytes);
        setState(() {
          // imageData = filePathAndName;
          isDownloading = false;
          Fluttertoast.showToast(
              msg: "Download success, check download folder");
        });
      } else if (Platform.isIOS) {
        GallerySaver.saveImage(url).then((value) {
          if (value == null || value == false) {
            setState(() {
              isDownloading = false;
              Fluttertoast.showToast(
                  msg: "Download failed, Please try after sometime");
            });
          } else {
            setState(() {
              isDownloading = false;
              Fluttertoast.showToast(msg: "Download success, check photos");
            });
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: "This feature does not implemented on this platform.");
      }
    } catch (e) {
      setState(() {
        // imageData = filePathAndName;
        isDownloading = false;
        Fluttertoast.showToast(msg: "Download failed, plz try after sometime");
      });
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            "${currentImageIndex + 1}/${widget.imageData.length}",
            style: gilroyBold.copyWith(
              fontSize: 15,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: isDownloading
                ? const Center(
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _asyncMethod();
                    },
                    child: theme
                        ? SvgPicture.asset(
                            "icons/download.svg",
                            height: 19,
                            width: 19,
                          )
                        : SvgPicture.asset(
                            "icons/download.svg",
                            height: 19,
                            width: 19,
                            color: iconGrey,
                          ),
                  ),
          )
        ],
      ),
      backgroundColor: theme ? Colors.transparent : Colors.white,
      body: PageView(
        controller: imageController,
        onPageChanged: (index) {
          setState(() {
            currentImageIndex = index;
          });
        },
        children: widget.imageData.map((image) {
          var url = StringConstants.apiUrl + image;
          return PhotoView(
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 1.8,
            basePosition: Alignment.center,
            backgroundDecoration:
                BoxDecoration(color: theme ? Colors.transparent : Colors.white),
            imageProvider: NetworkImage(url),
          );
        }).toList(),
      ),
    );
  }
}
