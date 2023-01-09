import 'dart:convert';

List<FeedModel> feedModelFromJson(String str) =>
    List<FeedModel>.from(json.decode(str).map((x) => FeedModel.fromJson(x)));

String feedModelToJson(List<FeedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedModel {
  FeedModel({
    required this.id,
    required this.marriageId,
    required this.feedId,
    required this.guestId,
    required this.guestProfileImage,
    required this.guestName,
    required this.likeCount,
    required this.isBookmark,
    required this.commentCount,
    required this.feedImage,
    required this.feedStatus,
    required this.createdDateTime,
    required this.isLike,
  });

  final String id;
  final String marriageId;
  final String feedId;
  final String guestId;
  final String guestProfileImage;
  final String guestName;
  int likeCount = 0;
  int commentCount;
  bool isBookmark;
  final String feedImage;
  final String feedStatus;
  final DateTime createdDateTime;
  bool isLike;

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        id: json["_id"],
        marriageId: json["marriage_id"],
        feedId: json["feed_id"],
        guestId: json["guest_id"],
        guestProfileImage: json["guest_profile_image"],
        guestName: json["guest_name"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        isBookmark: json["is_bookmark"],
        feedImage: json["feed_image"],
        feedStatus: json["feed_status"],
        createdDateTime: DateTime.parse(json["created_date_time"]),
        isLike: json["is_like"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "marriage_id": marriageId,
        "feed_id": feedId,
        "guest_id": guestId,
        "guest_profile_image": guestProfileImage,
        "guest_name": guestName,
        "like_count": likeCount,
        "comment_count": commentCount,
        "feed_image": feedImage,
        "feed_status": feedStatus,
        "is_bookmark": isBookmark,
        "created_date_time": createdDateTime.toIso8601String(),
        "is_like": isLike,
      };
}
