// To parse this JSON data, do
//
//     final privacyModel = privacyModelFromJson(jsonString);

import 'dart:convert';

PrivacyModel privacyModelFromJson(String str) =>
    PrivacyModel.fromJson(json.decode(str));

String privacyModelToJson(PrivacyModel data) => json.encode(data.toJson());

class PrivacyModel {
  Data? data;

  PrivacyModel({
    this.data,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) => PrivacyModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  String? id;
  String? description;
  String? gDescription;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.id,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
      this.gDescription});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        description: json["description"],
        createdBy: json["created_by"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        gDescription: json["g_description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "description": description,
        "created_by": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "g_description": gDescription,
      };
}
