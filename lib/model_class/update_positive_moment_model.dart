// To parse this JSON data, do
//
//     final updatePositiveMomentsModel = updatePositiveMomentsModelFromJson(jsonString);

import 'dart:convert';

UpdatePositiveMomentsModel updatePositiveMomentsModelFromJson(String str) => UpdatePositiveMomentsModel.fromJson(json.decode(str));

String updatePositiveMomentsModelToJson(UpdatePositiveMomentsModel data) => json.encode(data.toJson());

class UpdatePositiveMomentsModel {
  String? message;
  Moment? moment;

  UpdatePositiveMomentsModel({
    this.message,
    this.moment,
  });

  factory UpdatePositiveMomentsModel.fromJson(Map<String, dynamic> json) => UpdatePositiveMomentsModel(
    message: json["message"],
    moment: json["moment"] == null ? null : Moment.fromJson(json["moment"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "moment": moment?.toJson(),
  };
}

class Moment {
  String? id;
  String? title;
  String? description;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Moment({
    this.id,
    this.title,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Moment.fromJson(Map<String, dynamic> json) => Moment(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "image": image,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
