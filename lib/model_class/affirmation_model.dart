// To parse this JSON data, do
//
//     final affirmationModel = affirmationModelFromJson(jsonString);

import 'dart:convert';

AffirmationModel affirmationModelFromJson(String str) => AffirmationModel.fromJson(json.decode(str));

String affirmationModelToJson(AffirmationModel data) => json.encode(data.toJson());

class AffirmationModel {
  List<AffirmationData>? data;

  AffirmationModel({
    this.data,
  });

  factory AffirmationModel.fromJson(Map<String, dynamic> json) => AffirmationModel(
        data: json["data"] == null
            ? []
            : List<AffirmationData>.from(
                json["data"]!.map((x) => AffirmationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AffirmationData {
  String? id;
  String? name;
  String? description;
  dynamic category;
  int? status;
  String? createdBy;
  bool? isDefault;
  bool? isLiked;
  dynamic audioFile;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  AffirmationData({
    this.id,
    this.name,
    this.description,
    this.category,
    this.status,
    this.createdBy,
    this.isDefault,
    this.isLiked,
    this.audioFile,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AffirmationData.fromJson(Map<String, dynamic> json) =>
      AffirmationData(
        id: json["_id"],
    name: json["name"],
    description: json["description"],
    category: json["category"],
    status: json["status"],
    createdBy: json["created_by"],
    isDefault: json["isDefault"],
    isLiked: json["isLiked"],
    audioFile: json["audioFile"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "category": category,
    "status": status,
    "created_by": createdBy,
    "isDefault": isDefault,
    "isLiked": isLiked,
    "audioFile": audioFile,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
