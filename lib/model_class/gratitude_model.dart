// To parse this JSON data, do
//
//     final gratitudeModel = gratitudeModelFromJson(jsonString);

import 'dart:convert';

GratitudeModel gratitudeModelFromJson(String str) => GratitudeModel.fromJson(json.decode(str));

String gratitudeModelToJson(GratitudeModel data) => json.encode(data.toJson());

class GratitudeModel {
  List<GratitudeData>? data;

  GratitudeModel({
    this.data,
  });

  factory GratitudeModel.fromJson(Map<String, dynamic> json) => GratitudeModel(
    data: json["data"] == null ? [] : List<GratitudeData>.from(json["data"]!.map((x) => GratitudeData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GratitudeData {
  dynamic date;
  String? id;
  String? description;
  String? createdBy;
  bool? isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  GratitudeData({
    this.date,
    this.id,
    this.description,
    this.createdBy,
    this.isCompleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GratitudeData.fromJson(Map<String, dynamic> json) => GratitudeData(
    date: json["date"],
    id: json["_id"],
    description: json["description"],
    createdBy: json["created_by"],
    isCompleted: json["isCompleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "_id": id,
    "description": description,
    "created_by": createdBy,
    "isCompleted": isCompleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
