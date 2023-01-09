class UserModel {
  UserModel({
    required this.marriageId,
    required this.guestId,
    required this.guestName,
    required this.guestMobileNumber,
    required this.guestProfileImage,
    required this.guestIdProof,
    required this.guestStatus,
    required this.fcmTokenGuest,
  });

  final String marriageId;
  final String guestId;
  final String guestName;
  final String guestMobileNumber;
  final String guestProfileImage;
  final List<String> guestIdProof;
  final String guestStatus;
  final String fcmTokenGuest;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        marriageId: json["marriage_id"],
        guestId: json["guest_id"],
        guestName: json["guest_name"],
        guestMobileNumber: json["guest_mobile_number"],
        guestProfileImage: json["guest_profile_image"],
        guestIdProof: List<String>.from(json["guest_id_proof"].map((x) => x)),
        guestStatus: json["guest_status"],
        fcmTokenGuest: json["fcm_token_guest"],
      );

  Map<String, dynamic> toJson() => {
        "marriage_id": marriageId,
        "guest_id": guestId,
        "guest_name": guestName,
        "guest_mobile_number": guestMobileNumber,
        "guest_profile_image": guestProfileImage,
        "guest_id_proof": List<dynamic>.from(guestIdProof.map((x) => x)),
        "guest_status": guestStatus,
        "fcm_token_guest": fcmTokenGuest,
      };
}
