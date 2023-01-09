import 'dart:convert';

List<WardrobeModel> wardrobeModelFromJson(String str) =>
    List<WardrobeModel>.from(
        json.decode(str).map((x) => WardrobeModel.fromJson(x)));

String wardrobeModelToJson(List<WardrobeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WardrobeModel {
  WardrobeModel({
    required this.dressCode,
    required this.eventId,
    required this.eventName,
    required this.eventTaglineColor,
    required this.eventTagline,
  });

  final DressCode dressCode;
  final String eventId;
  final String eventName;
  final String eventTaglineColor;
  final String eventTagline;

  factory WardrobeModel.fromJson(Map<String, dynamic> json) => WardrobeModel(
        dressCode: DressCode.fromJson(json["dress_code"]),
        eventId: json["event_id"],
        eventName: json["event_name"],
        eventTaglineColor: json["event_tagline_color"],
        eventTagline: json["event_tagline"],
      );

  Map<String, dynamic> toJson() => {
        "dress_code": dressCode.toJson(),
        "event_id": eventId,
        "event_name": eventName,
        "event_tagline_color": eventTaglineColor,
        "event_tagline": eventTagline,
      };
}

class DressCode {
  DressCode({
    required this.forMen,
    required this.forWomen,
    required this.outFit,
  });

  final String forMen;
  final String forWomen;
  final String outFit;

  factory DressCode.fromJson(Map<String, dynamic> json) => DressCode(
        forMen: json["for_men"],
        forWomen: json["for_women"],
        outFit: json["outFit"],
      );

  Map<String, dynamic> toJson() => {
        "for_men": forMen,
        "for_women": forWomen,
        "outFit": outFit,
      };
}
