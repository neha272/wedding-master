class RegistrationModel {
  RegistrationModel({
    required this.marriageId,
    required this.guestId,
    required this.guestName,
    required this.guestMobileNumber,
    required this.guestProfileImage,
    required this.guestIdProof,
    required this.fcmTokenGuest,
    required this.guestStatus,
  });

  final String marriageId;
  final String guestId;
  final String guestName;
  final String guestMobileNumber;
  final String guestProfileImage;
  final List<String> guestIdProof;
  final String fcmTokenGuest;
  final String guestStatus;

  factory RegistrationModel.fromJson(Map<String, dynamic> json) =>
      RegistrationModel(
        marriageId: json["marriage_id"],
        guestId: json["guest_id"],
        guestName: json["guest_name"],
        guestMobileNumber: json["guest_mobile_number"],
        guestProfileImage: json["guest_profile_image"],
        guestIdProof: List<String>.from(json["guest_id_proof"].map((x) => x)),
        fcmTokenGuest: json["fcm_token_guest"],
        guestStatus: json["guest_status"],
      );
}
