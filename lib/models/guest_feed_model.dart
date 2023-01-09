import 'dart:convert';

List<GuestFeedModel> guestFeedFromJson(String str) => List<GuestFeedModel>.from(json.decode(str).map((x) => GuestFeedModel.fromJson(x)));

String guestFeedToJson(List<GuestFeedModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GuestFeedModel {
  GuestFeedModel({
    required this.marriageId,
    required this.feedId,
    required this.guestId,
    required this.feedImage,
    required this.id,
    required this.feedStatus,
  });

  final String marriageId;
  final String feedId;
  final String guestId;
  final String feedImage;
  final String id;
  final String feedStatus;

  factory GuestFeedModel.fromJson(Map<String, dynamic> json) => GuestFeedModel(
    marriageId: json["marriage_id"],
    feedId: json["feed_id"],
    guestId: json["guest_id"],
    feedImage: json["feed_image"],
    id: json["_id"],
    feedStatus: json["feed_status"],
  );

  Map<String, dynamic> toJson() => {
    "marriage_id": marriageId,
    "feed_id": feedId,
    "guest_id": guestId,
    "feed_image": feedImage,
    "_id": id,
    "feed_status": feedStatus,
  };
}
