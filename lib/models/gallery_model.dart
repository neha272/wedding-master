import 'dart:convert';

GalleryModel galleryModelFromJson(String str) =>
    GalleryModel.fromJson(json.decode(str));

String galleryModelToJson(GalleryModel data) => json.encode(data.toJson());

class GalleryModel {
  GalleryModel({
    required this.data,
  });

  final List<String> data;

  factory GalleryModel.fromJson(Map<String, dynamic> json) => GalleryModel(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
