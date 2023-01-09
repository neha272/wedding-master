import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/models/guest_feed_model.dart';
import 'package:wedding/providers/user_feed_provider.dart';
import 'package:wedding/screens/ProfileScreen/profile_components/square_image.dart';
import 'package:wedding/widgets/loader.dart';

class ProfileApprovedTab extends StatefulWidget {
  const ProfileApprovedTab({Key? key}) : super(key: key);

  @override
  State<ProfileApprovedTab> createState() => _ProfileApprovedTabState();
}

class _ProfileApprovedTabState extends State<ProfileApprovedTab>
    with AutomaticKeepAliveClientMixin<ProfileApprovedTab> {
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
            .getGuestFeed(type: "Approved")
            .then((value) {
          images = value.data!;
          setState(() {
            isLoading = false;
            isLoaded = true;
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
            ? const Center(child: Text("No approved post found..."))
            : SquareImage(
                images: images,
              );
  }
}
