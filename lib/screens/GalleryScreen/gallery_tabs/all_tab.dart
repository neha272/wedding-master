import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/providers/event_provider.dart';
import 'package:wedding/providers/galleryProvider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/widgets/loader.dart';

import '../gallery_image.dart';

class AllTab extends StatefulWidget {
  final int index;

  const AllTab({required this.index, Key? key}) : super(key: key);

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab>
    with AutomaticKeepAliveClientMixin<AllTab> {
  @override
  bool get wantKeepAlive => true;
  bool isLoaded = false;
  bool isLoading = false;
  bool isLoadingMore = false;
  List images = [];
  int page = 1;
  int maxLimit = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    await Future.delayed(const Duration(milliseconds: 0)).then((value) async {
      if (!isLoaded) {
        if (widget.index != 0) {
          setState(() {
            isLoading = true;
          });
          await Provider.of<GalleryProvider>(context, listen: false)
              .getGallery(
                  eventId: context
                      .read<EventProvider>()
                      .events[widget.index - 1]
                      .eventId,
                  page: 1)
              .then((value) {
            images = value.data!;
            setState(() {
              if (value.pagination != null) {
                maxLimit = value.pagination!.last!.page;
              }
              isLoading = false;
              isLoaded = true;
            });
          });
        } else {
          setState(() {
            isLoading = true;
          });
          await Provider.of<GalleryProvider>(context, listen: false)
              .getGallery(eventId: "", page: 1)
              .then((value) {
            images = value.data!;
            setState(() {
              if (value.pagination != null) {
                maxLimit = value.pagination!.last!.page;
              }
              isLoading = false;
            });
          });
        }
      }
    });
  }

  _loadMore() async {
    if (page < maxLimit) {
      setState(() {
        page++;
      });
      if (widget.index != 0) {
        setState(() {
          isLoadingMore = true;
        });
        await Provider.of<GalleryProvider>(context, listen: false)
            .getGallery(
                eventId: context
                    .read<EventProvider>()
                    .events[widget.index - 1]
                    .eventId,
                page: page)
            .then((value) {
          if (value.data != null) {
            images.addAll(value.data!);
          }
          setState(() {
            isLoadingMore = false;
          });
        });
      } else {
        setState(() {
          isLoadingMore = true;
        });
        await Provider.of<GalleryProvider>(context, listen: false)
            .getGallery(eventId: "", page: page)
            .then((value) {
          if (value.data != null) {
            images.addAll(value.data!);
          }
          setState(() {
            isLoadingMore = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Container(
      decoration:
          theme ? const BoxDecoration() : BoxDecoration(gradient: greyToWhite),
      child: isLoading
          ? const Loader()
          : RefreshIndicator(
              onRefresh: () async {
                await _loadData();
              },
              child: Provider.of<GalleryProvider>(context, listen: false)
                      .galleryData
                      .isNotEmpty
                  ? NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.metrics.maxScrollExtent ==
                            scrollNotification.metrics.pixels) {
                          _loadMore();
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 20, left: 20, bottom: 0),
                            child: MasonryGrid(
                              column: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              // staggered: true,
                              children: List.generate(
                               isLoadingMore? images.length+1:images.length,
                                (i) => (i==images.length)?const CupertinoActivityIndicator():GestureDetector(
                                  onTap: () {
                                    nextScreen(
                                        context,
                                        GalleryImage(
                                          imageData: images,
                                          currentIndex: i,
                                        ));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: CachedNetworkImage(
                                      imageUrl: StringConstants.apiUrl +
                                          images.elementAt(i),
                                      placeholder: (context, url) => Container(
                                        height: 100,
                                        width: 100,
                                        color: grey,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.broken_image),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    )
                  : const Center(child: Text("No image found...")),
            ),
    );
  }
}
