import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:wedding/providers/theme_provider.dart';

class FullFeedImage extends StatelessWidget {
  final String imgUrl;

  const FullFeedImage({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context
        .watch<ThemeProvider>()
        .darkTheme;
    //  PageController controller = PageController(initialPage: );
    return Scaffold(
      appBar: AppBar(),
      body: Hero(
          tag: imgUrl,
          child: Material(
              child: PhotoView(
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 1.8,
                basePosition: Alignment.center,
                loadingBuilder: (context, event) {
                  return const Center(child: CircularProgressIndicator());
                },
                backgroundDecoration:
                BoxDecoration(color: theme ? Colors.transparent : Colors.white),
                imageProvider: NetworkImage(imgUrl),
              )
          )),
    );
  }
}
