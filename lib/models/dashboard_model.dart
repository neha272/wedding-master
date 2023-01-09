import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  DashboardModel({
    required this.marriageLogo,
    required this.eventManagerName,
    required this.weddingHashtag,
    required this.banner,
    required this.invitationCard,
    required this.isDark,
    required this.secondaryColor,
    required this.brideName,
    required this.groomName,
    required this.weddingVenue,
    required this.mobileNumber,
    required this.isGuestsIdProof,
    required this.isApprovePost,
    required this.liveLink,
    required this.isActive,
    required this.fcmTokenMarriage,
    required this.marriageId,
    required this.marriageName,
    required this.weddingDate,
  });

  final String marriageLogo;
  final String eventManagerName;
  final String weddingHashtag;
  final List<String> banner;
  final List<String> invitationCard;
  final bool isDark;
  final List<String> secondaryColor;
  final String brideName;
  final String groomName;
  final String weddingVenue;
  final String mobileNumber;
  final bool isGuestsIdProof;
  final bool isApprovePost;
  final String liveLink;
  final bool isActive;
  final String fcmTokenMarriage;
  final String marriageId;
  final String marriageName;
  final DateTime weddingDate;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        marriageLogo: json["marriage_logo"],
        eventManagerName: json["event_manager_name"],
        weddingHashtag: json["wedding_hashtag"],
        banner: List<String>.from(json["banner"].map((x) => x)),
        invitationCard:
            List<String>.from(json["invitation_card"].map((x) => x)),
        isDark: json["is_dark"],
        secondaryColor:
            List<String>.from(json["secondary_color"].map((x) => x)),
        brideName: json["bride_name"],
        groomName: json["groom_name"],
        weddingVenue: json["wedding_venue"],
        mobileNumber: json["mobile_number"],
        isGuestsIdProof: json["is_guests_id_proof"],
        isApprovePost: json["is_approve_post"],
        liveLink: json["live_link"],
        isActive: json["is_active"],
        fcmTokenMarriage: json["fcm_token_marriage"],
        marriageId: json["marriage_id"],
        marriageName: json["marriage_name"],
        weddingDate: DateTime.parse(json["wedding_date"],),
      );

  Map<String, dynamic> toJson() => {
        "marriage_logo": marriageLogo,
        "event_manager_name": eventManagerName,
        "wedding_hashtag": weddingHashtag,
        "banner": List<dynamic>.from(banner.map((x) => x)),
        "invitation_card": List<dynamic>.from(invitationCard.map((x) => x)),
        "is_dark": isDark,
        "secondary_color": List<dynamic>.from(secondaryColor.map((x) => x)),
        "bride_name": brideName,
        "groom_name": groomName,
        "wedding_venue": weddingVenue,
        "mobile_number": mobileNumber,
        "is_guests_id_proof": isGuestsIdProof,
        "is_approve_post": isApprovePost,
        "live_link": liveLink,
        "is_active": isActive,
        "fcm_token_marriage": fcmTokenMarriage,
        "marriage_id": marriageId,
        "marriage_name": marriageName,
        "wedding_date": weddingDate.toIso8601String(),
      };
}
