import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/guest_feed_model.dart';
import 'package:wedding/providers/theme_provider.dart';

class SquareImage extends StatelessWidget {
  const SquareImage({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<GuestFeedModel> images;

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
        itemCount: images.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme ? mediumBlack : white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl:
                  StringConstants.apiUrl + images.elementAt(index).feedImage,
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
              errorWidget: (context, url, error) => const Icon(Icons.dashboard),
            ),
          ),
        ),
      ),
    );
  }
}
