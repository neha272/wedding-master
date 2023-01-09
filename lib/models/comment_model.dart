class CommentModel {
  CommentModel({
    required this.guestProfileImage,
    required this.guestName,
    required this.guestId,
    required this.commentText,
    required this.time,
  });

  final String guestProfileImage;
  final String guestName;
  final String guestId;
  final String commentText;
  final DateTime time;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        guestProfileImage: json["guest_profile_image"],
        guestName: json["guest_name"],
        guestId: json["guest_id"],
        commentText: json["comment_text"],
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "guest_profile_image": guestProfileImage,
        "guest_name": guestName,
        "guest_id": guestId,
        "comment_text": commentText,
        "time": time.toIso8601String(),
      };
}
