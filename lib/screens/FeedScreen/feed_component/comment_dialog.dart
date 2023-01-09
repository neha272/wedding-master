import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/models/feed_model.dart';
import 'package:wedding/providers/feed_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/FeedScreen/feed_component/comment_component.dart';
import 'package:wedding/widgets/comment_button.dart';
import 'package:wedding/widgets/like_button.dart';
import 'package:wedding/widgets/loader.dart';

class CommentDialogue extends StatefulWidget {
  final FeedModel feedData;

  const CommentDialogue({Key? key, required this.feedData}) : super(key: key);

  @override
  State<CommentDialogue> createState() => _CommentDialogueState();
}

class _CommentDialogueState extends State<CommentDialogue>
    with AutomaticKeepAliveClientMixin<CommentDialogue> {
  TextEditingController textEditingController = TextEditingController();

  @override
  bool get wantKeepAlive => false;

  String? commentText;
  FocusNode focusNode = FocusNode();
  final ScrollController itemScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context
          .read<FeedProvider>()
          .getFeedComment(feedId: widget.feedData.feedId);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = context.watch<ThemeProvider>().darkTheme;
    var feed = Provider.of<FeedProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 25,
        left: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LikeButton(
                  iconSize: 18,
                  likeCount: widget.feedData.likeCount,
                  textSize: 14,
                  isLiked: widget.feedData.isLike,
                ),
                CommentButton(
                    iconSize: 20,
                    textSize: 14,
                    commentCount:
                        context.read<FeedProvider>().feedCommentList.length),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
          context.watch<FeedProvider>().isCommentLoading
              ? const Loader()
              : context.watch<FeedProvider>().feedCommentList.isNotEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                        controller: itemScrollController,
                        itemCount:
                            context.read<FeedProvider>().feedCommentList.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => CommentComponent(
                          commentData: Provider.of<FeedProvider>(context)
                              .feedCommentList
                              .elementAt(index),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 100,
                      child: Center(child: Text("No comment found"))),
          Padding(
            padding: EdgeInsets.only(
                top: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Container(
              alignment: Alignment.center,
              decoration: theme
                  ? BoxDecoration(
                      color: lightBlack,
                      borderRadius: BorderRadius.circular(50),
                    )
                  : BoxDecoration(
                      color: grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                maxWidth: MediaQuery.of(context).size.width,
                minHeight: 25.0,
                maxHeight: 50.0,
              ),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Scrollbar(
                thickness: 0,
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: TextField(
                        cursorColor: theme ? white : Colors.black87,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        focusNode: focusNode,
                        controller: textEditingController,
                        style: gilroyNormal.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              top: 2.0, left: 13.0, right: 13.0, bottom: 2.0),
                          hintText: "Type your comments here",
                          hintStyle:
                              gilroyBold.copyWith(color: grey, fontSize: 12),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              commentText = textEditingController.text;
                              textEditingController.clear();
                            });
                            log("before add ${context.read<FeedProvider>().feedCommentList.length}");
                            feed.updateCommentList(commentText);
                            log("->>> ${context.read<FeedProvider>().feedCommentList.length}");
                            if (context
                                    .read<FeedProvider>()
                                    .feedCommentList
                                    .length >
                                1) {
                              log("after add ${context.read<FeedProvider>().feedCommentList.length}");
                              itemScrollController.jumpTo(itemScrollController
                                  .position.maxScrollExtent);
                            }
                            feed.updateLikeComment({
                              "feed_id": widget.feedData.feedId,
                              "guest_id": sharedPrefs.guestId,
                              "comment": commentText
                            }).then((value) {
                              widget.feedData.commentCount = context
                                  .read<FeedProvider>()
                                  .feedCommentList
                                  .length;
                            });
                          },
                          child: GradientText(
                            "Post",
                            style: gilroyBold.copyWith(fontSize: 12),
                            colors:
                                context.watch<ThemeProvider>().gradient.colors,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
