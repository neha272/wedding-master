import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/widgets/custom_sliverappbar.dart';

class ViewIdImages extends StatelessWidget {
  final String? urlFirst;
  final String? urlSecond;

  const ViewIdImages({this.urlFirst, this.urlSecond, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: greyToWhite),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const CustomSliverAppBar(title: "Id Proof"),
            SliverFillRemaining(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (urlFirst != null)
                    CachedNetworkImage(
                      imageUrl: urlFirst!,
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
                  if (urlSecond != null)
                    CachedNetworkImage(
                      imageUrl: urlSecond!,
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
                  if (urlFirst == null && urlSecond == null)
                    Text(
                      "No Id is Available",
                      style: gilroyLight,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
