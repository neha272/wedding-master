import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/feed_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/FeedScreen/feed_component/feed_post.dart';
import 'package:wedding/screens/HomeScreen/home_screen.dart';
import 'package:wedding/widgets/loader.dart';
import 'package:wedding/widgets/popup.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  File? pickedImage;
  bool isLoading = true;
  int page = 1;
  int maxLimit = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      // if (!context.read<FeedProvider>().isFeedLoaded) {
      context.read<FeedProvider>().getFeed(1).then((value) {
        if (value.pagination != null) {
          setState(() {
            maxLimit = value.pagination!.last!.page;
          });
        }
      });
    });
  }

  Future<void> _cropImage(bool isFirst) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedImage!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio7x5,
              ]
            : [
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio7x5,
              ],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.white,
          backgroundColor: Colors.white,
          toolbarWidgetColor: Colors.black87,
          hideBottomControls: false,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
        ),
        iosUiSettings: const IOSUiSettings(
          title: '',
        ));
    if (croppedFile != null) {
      pickedImage = croppedFile;
      _addFeed();
    }
  }

  _addFeed() async {
    Provider.of<FeedProvider>(context, listen: false)
        .addFeed(
            formData: FormData.fromMap({
      "feed_image": await MultipartFile.fromFile(pickedImage!.path)
    }))
        .then((value) {
      if (value.success) {
        Provider.of<FeedProvider>(context, listen: false).getFeed(page);
        showDialog(
            context: context,
            builder: (context) => FeedPopup(message: value.message));
      } else {
        Fluttertoast.showToast(msg: "Fail to Update Details");
      }
    });
  }

  Future<File?> getFromCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> getFromGallery() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  void _imagePick() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      pickedImage = await getFromCamera();
                      _cropImage(true);

                      if (pickedImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      }
                      setState(() {});

                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 15),
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                      title: Text(
                        "Take Photo",
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      pickedImage = await getFromGallery();
                      _cropImage(true);

                      if (pickedImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      }
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 15),
                        child: Icon(Icons.image),
                      ),
                      title: Text(
                        "Choose from Gallery",
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0, bottom: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Cancel",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  loadMoreData() {
    if (page < maxLimit) {
      setState(() {
        page++;
      });
      context.read<FeedProvider>().getFeed(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    var feed = context.watch<FeedProvider>();
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await feed.getFeed(1);
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification.metrics.maxScrollExtent ==
                    scrollNotification.metrics.pixels) {
                  loadMoreData();
                }
                return false;
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    expandedHeight: 65,
                    flexibleSpace: !theme
                        ? Container(
                            decoration: BoxDecoration(gradient: greyToWhite),
                          )
                        : const SizedBox(),
                    floating: true,
                    snap: true,
                    centerTitle: true,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IconButton(
                        onPressed: () {
                          HomeScreen.pageControl.currentState?.jumpToHome();
                        },
                        icon: const Icon(
                          CupertinoIcons.back,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        "Feed",
                        style: gilroyBold.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10, top: 7),
                        child: feed.isUploading
                            ? const Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  _imagePick();
                                },
                                child: SvgPicture.asset(
                                  theme
                                      ? "icons/add_feed.svg"
                                      : "icons/add_feed_white.svg",
                                  height: 45,
                                  width: 45,
                                ),
                              ),
                      ),
                    ],
                  ),
                  !feed.isFeedLoaded
                      ? const SliverFillRemaining(child: Loader())
                      : feed.feeds.isNotEmpty
                          ? SliverPadding(
                              padding: const EdgeInsets.only(bottom: 15),
                              sliver: SliverFixedExtentList(
                                itemExtent: 395.0,
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return (index == feed.feeds.length)
                                        ? const CupertinoActivityIndicator()
                                        : Container(
                                            decoration: theme
                                                ? const BoxDecoration()
                                                : BoxDecoration(
                                                    gradient: greyToWhite),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            child: FeedPost(
                                              feedModel:
                                                  feed.feeds.elementAt(index),
                                              setData: () {
                                                setState(() {});
                                              },
                                            ),
                                          );
                                  },
                                  childCount: (maxLimit == page)
                                      ? feed.feeds.length
                                      : feed.feeds.length + 1,
                                ),
                              ),
                            )
                          : const SliverFillRemaining(
                              child: Center(child: Text("Feed not found")))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
