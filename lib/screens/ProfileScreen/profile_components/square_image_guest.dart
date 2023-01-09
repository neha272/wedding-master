import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/feed_model.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/FeedScreen/GuestFeedScreen.dart';
import 'package:wedding/widgets/animated_dialog.dart';

class SquareImageGuest extends StatefulWidget {
  const SquareImageGuest({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<FeedModel> images;

  @override
  State<SquareImageGuest> createState() => _SquareImageGuestState();
}

class _SquareImageGuestState extends State<SquareImageGuest> {
  late OverlayEntry _popupDialog;

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPopupContent(String url) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  height: 100,
                  width: 100,
                  color: grey,
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return RefreshIndicator(
      onRefresh: () async {},
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        // shrinkWrap: true,
        itemCount: widget.images.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            nextScreen(context, GuestFeedScreen(feed: widget.images,index: index,));
          },
          onLongPress: () {
            _popupDialog = _createPopupDialog(StringConstants.apiUrl +
                widget.images.elementAt(index).feedImage);
            Overlay.of(context)?.insert(_popupDialog);
          },
          onLongPressEnd: (details) => _popupDialog.remove(),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme ? mediumBlack : white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: StringConstants.apiUrl +
                    widget.images.elementAt(index).feedImage,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
                placeholder: (context, url) => Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme ? mediumBlack : white,
                  ),
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.dashboard),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
