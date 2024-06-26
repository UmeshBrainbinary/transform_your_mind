// To parse this JSON data, do
//
//     final affirmationDataModel = affirmationDataModelFromJson(jsonString);

import 'dart:convert';

AffirmationDataModel affirmationDataModelFromJson(String str) => AffirmationDataModel.fromJson(json.decode(str));

String affirmationDataModelToJson(AffirmationDataModel data) => json.encode(data.toJson());

class AffirmationDataModel {
  List<Datum>? data;
  int? total;

  AffirmationDataModel({
    this.data,
    this.total,
  });

  factory AffirmationDataModel.fromJson(Map<String, dynamic> json) => AffirmationDataModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
  };
}

class Datum {
  bool? userLiked;
  String? id;
  String? name;
  String? description;
  String? category;
  int? status;
  String? createdBy;
  bool? isDefault;
  bool? isLiked;
  String? audioFile;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.userLiked,
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userLiked: json["userLiked"],
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    category: json["category"],
    status: json["status"],
    createdBy:json["created_by"],
    isDefault: json["isDefault"],
    isLiked: json["isLiked"],
    audioFile: json["audioFile"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "userLiked": userLiked,
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

