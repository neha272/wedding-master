import 'dart:developer';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/gen'
    'eral/string_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/models/feed_model.dart';
import 'package:wedding/providers/feed_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/FeedScreen/feed_component/comment_dialog.dart';
import 'package:wedding/screens/ProfileScreen/guest_profile.dart';
import 'package:wedding/screens/ProfileScreen/profile_screen.dart';
import 'package:wedding/widgets/comment_button.dart';
import 'package:wedding/widgets/like_button.dart';
import 'package:wedding/widgets/user_button.dart';

import '../feed_image.dart';

class FeedPost extends StatefulWidget {
  FeedModel feedModel;
  Function? setData;

  FeedPost({required this.feedModel, this.setData, Key? key}) : super(key: key);

  @override
  _FeedPostState createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  bool isDownloading = false;
  final FlareControls flareControls = FlareControls();

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
    log("log $externalStorageDirPath");
    return externalStorageDirPath;
  }

  _asyncMethod() async {
    await _checkPermission().then((value) {
      if (value == false) {
        Fluttertoast.showToast(msg: "permission is denied");
        return;
      }
    });
    try {
      setState(() {
        isDownloading = true;
      });
      var url = StringConstants.apiUrl + widget.feedModel.feedImage; // <-- 1

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
        File file2 =
            File(_localPath + '/' + widget.feedModel.feedImage.split("/").last);

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
        Fluttertoast.showToast(
            msg: "Download failed, Please try after sometime");
      });
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    var feed = Provider.of<FeedProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 10.0),
      child: Container(
        decoration: theme
            ? BoxDecoration(
                color: scaffoldBlack,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                    BoxShadow(
                      color: Color(0xff332e34),
                      offset: Offset(-2, -2),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Color(0xff050509),
                      offset: Offset(3, 3),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ])
            : BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                gradient: greyToWhite,
                boxShadow: [
                    // BoxShadow(
                    //   offset: const Offset(-1, -1),
                    //   color: white.withOpacity(0.6),
                    // ),
                    BoxShadow(
                      offset: const Offset(-2, -2),
                      blurRadius: 6,
                      spreadRadius: 2,
                      color: white,
                    ),
                    BoxShadow(
                      offset: const Offset(3, 3),
                      blurRadius: 6,
                      spreadRadius: 1,
                      color: grey.withOpacity(0.3),
                    ),
                  ]),
        padding:
            const EdgeInsets.only(top: 10, left: 18, right: 18, bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12, right: 6, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (sharedPrefs.guestId == widget.feedModel.guestId) {
                          nextScreen(context, const ProfileScreen());
                        } else {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GuestProfileScreen(
                                guestId: widget.feedModel.guestId,
                              ),
                            ),
                          ).then((value) {
                            context
                                .read<FeedProvider>()
                                .getFeed(1)
                                .then((value) {
                              if (widget.setData != null) {
                                widget.setData!();
                              }
                            });
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IgnorePointer(
                              child: UserButton(
                                url: widget.feedModel.guestProfileImage,
                                size: 45,
                              ),
                            ),
                          ),
                          AutoSizeText(
                            widget.feedModel.guestName,
                            style: gilroyBold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  isDownloading
                      ? const SizedBox(
                          height: 17,
                          width: 17,
                          child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: GestureDetector(
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
                        ),
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  nextScreen(
                    context,
                    FullFeedImage(
                      imgUrl:
                          StringConstants.apiUrl + widget.feedModel.feedImage,
                    ),
                  );
                },
                onDoubleTap: () {
                  if (widget.feedModel.isLike != true) {
                    setState(() {
                      widget.feedModel.isLike = true;
                      widget.feedModel.likeCount += 1;
                    });
                    feed.updateLikeComment({
                      "feed_id": widget.feedModel.feedId,
                      "guest_id": sharedPrefs.guestId,
                      "is_like": widget.feedModel.isLike
                    });
                  }
                  flareControls.play("like");
                },
                // onLongPress: () {
                //   _popupDialog = _createPopupDialog(
                //       StringConstants.apiUrl + widget.feedModel.feedImage);
                //   Overlay.of(context)?.insert(_popupDialog);
                // },
                // onLongPressEnd: (details) => _popupDialog.remove(),
                child: Hero(
                  tag: widget.feedModel.feedImage,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            StringConstants.apiUrl + widget.feedModel.feedImage,
                        imageBuilder: (context, imageProvider) => Padding(
                          padding: const EdgeInsets.only(right: 4.0, left: 4),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 190.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: black,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          height: 190,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightBlack,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 190,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: grey.withOpacity(0.4),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: 120,
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: FlareActor(
                            "icons/instagram_like.flr",
                            color: Colors.red,
                            controller: flareControls,
                            animation: 'idle',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          widget.feedModel.isLike = !widget.feedModel.isLike;
                          if (widget.feedModel.isLike == true) {
                            widget.feedModel.likeCount += 1;
                            flareControls.play("like");
                          } else {
                            widget.feedModel.likeCount -= 1;
                          }
                        });
                        feed.updateLikeComment({
                          "feed_id": widget.feedModel.feedId,
                          "guest_id": sharedPrefs.guestId,
                          "is_like": widget.feedModel.isLike
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 4),
                        child: LikeButton(
                          iconSize: 18,
                          likeCount: widget.feedModel.likeCount,
                          textSize: 14,
                          isLiked: widget.feedModel.isLike,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        commentDialog();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: CommentButton(
                          iconSize: 20,
                          textSize: 14,
                          commentCount: widget.feedModel.commentCount,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          widget.feedModel.isBookmark =
                              !widget.feedModel.isBookmark;
                        });
                        feed.updateLikeComment({
                          "feed_id": widget.feedModel.feedId,
                          "guest_id": sharedPrefs.guestId,
                          "is_bookmark": widget.feedModel.isBookmark
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 10),
                        child: theme
                            ? widget.feedModel.isBookmark
                                ? SvgPicture.asset(
                                    "icons/filled_bookmark.svg",
                                    height: 20,
                                    width: 20,
                                  )
                                : SvgPicture.asset(
                                    "icons/bookmark.svg",
                                    height: 20,
                                    width: 20,
                                  )
                            : widget.feedModel.isBookmark
                                ? SvgPicture.asset(
                                    "icons/filledr_bookmarked.svg",
                                    height: 20,
                                    width: 20,
                                    color: iconGrey,
                                  )
                                : SvgPicture.asset(
                                    "icons/bookmark.svg",
                                    height: 20,
                                    width: 20,
                                    color: iconGrey,
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  commentDialog();
                },
                child: AutoSizeText(
                  widget.feedModel.commentCount == 0
                      ? "Add comment"
                      : widget.feedModel.commentCount.toString() + " comments",
                  style: gilroyBold.copyWith(
                    color: theme ? grey.withOpacity(0.4) : eventGrey,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  commentDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      context: context,
      builder: (ctx) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: CommentDialogue(
              feedData: widget.feedModel,
            ));
      },
    );
  }
}
