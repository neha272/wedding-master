import 'dart:convert';

List<EventModel> eventModelFromJson(String str) =>
    List<EventModel>.from(json.decode(str).map((x) => EventModel.fromJson(x)));

String eventModelToJson(List<EventModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventModel {
  EventModel({
    required this.marriageId,
    required this.eventId,
    required this.eventName,
    required this.eventTaglineColor,
    required this.eventTagline,
    required this.eventDate,
    required this.eventTime,
    required this.isDressCode,
    required this.eventVenue,
    required this.dressCode,
  });

  final String marriageId;
  final String eventId;
  final String eventName;
  final String eventTaglineColor;
  final String eventTagline;
  final DateTime eventDate;
  final String eventTime;
  final bool isDressCode;
  final String eventVenue;
  final DressCode? dressCode;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        marriageId: json["marriage_id"],
        eventId: json["event_id"],
        eventName: json["event_name"],
        eventTaglineColor: json["event_tagline_color"],
        eventTagline: json["event_tagline"],
        eventDate: DateTime.parse(json["event_date"]),
        eventTime: json["event_time"],
        isDressCode: json["is_dress_code"],
        eventVenue: json["event_venue"],
        dressCode: json["dress_code"] == null
            ? DressCode(forMen: "", forWomen: "", outFit: "")
            : DressCode.fromJson(json["dress_code"]),
      );

  Map<String, dynamic> toJson() => {
        "marriage_id": marriageId,
        "event_id": eventId,
        "event_name": eventName,
        "event_tagline_color": eventTaglineColor,
        "event_tagline": eventTagline,
        "event_date": eventDate.toIso8601String(),
        "event_time": eventTime,
        "is_dress_code": isDressCode,
        "event_venue": eventVenue,
        "dress_code": dressCode == null ? {} : dressCode!.toJson(),
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
