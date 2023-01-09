import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/models/guest_feed_model.dart';
import 'package:wedding/providers/user_feed_provider.dart';
import 'package:wedding/screens/ProfileScreen/profile_components/square_image.dart';
import 'package:wedding/widgets/loader.dart';

class ProfileAllTab extends StatefulWidget {
  const ProfileAllTab({Key? key}) : super(key: key);

  @override
  State<ProfileAllTab> createState() => _ProfileAllTabState();
}

class _ProfileAllTabState extends State<ProfileAllTab>
    with AutomaticKeepAliveClientMixin<ProfileAllTab> {
  @override
  bool get wantKeepAlive => true;

  bool isLoaded = false, isLoading = false;
  List<GuestFeedModel> images = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      if (!isLoaded) {
        setState(() {
          isLoading = true;
        });
        Provider.of<UserFeedProvider>(context, listen: false)
            .getGuestFeed(type: "All")
            .then((value) {
          images = value.data!;
          setState(() {
            isLoaded = true;
            isLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? const Loader()
        : images.isEmpty && isLoaded
            ? const Center(child: Text("No post found..."))
            : SquareImage(
                images: images,
              );
  }
}
