import 'dart:convert';
import 'package:wedding/models/feed_model.dart';

GuestModel guestModelFromJson(String str) => GuestModel.fromJson(json.decode(str));

String guestModelToJson(GuestModel data) => json.encode(data.toJson());

class GuestModel {
  GuestModel({
    required this.guestName,
    required this.guestProfileImage,
    required this.feeds,
  });

  final String guestName;
  final String guestProfileImage;
  final List<FeedModel> feeds;

  factory GuestModel.fromJson(Map<String, dynamic> json) => GuestModel(
    guestName: json["guest_name"],
    guestProfileImage: json["guest_profile_image"],
    feeds: List<FeedModel>.from(json["feeds"].map((x) => FeedModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "guest_name": guestName,
    "guest_profile_image": guestProfileImage,
    "feeds": List<dynamic>.from(feeds.map((x) => x.toJson())),
  };
}
