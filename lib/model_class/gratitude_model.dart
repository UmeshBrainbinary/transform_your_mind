// To parse this JSON data, do
//
//     final gratitudeModel = gratitudeModelFromJson(jsonString);

import 'dart:convert';

GratitudeModel gratitudeModelFromJson(String str) => GratitudeModel.fromJson(json.decode(str));

String gratitudeModelToJson(GratitudeModel data) => json.encode(data.toJson());

class GratitudeModel {
  List<Datum>? data;

  GratitudeModel({
    this.data,
  });

  factory GratitudeModel.fromJson(Map<String, dynamic> json) => GratitudeModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? name;
  String? description;
  DateTime? date;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.name,
    this.description,
    this.date,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    createdBy: json["created_by"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "date": date?.toIso8601String(),
    "created_by": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
