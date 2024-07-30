// To parse this JSON data, do
//
//     final AffirmationAllModel = AffirmationAllModelFromJson(jsonString);

import 'dart:convert';

AffirmationAllModel affirmationAllModelFromJson(String str) => AffirmationAllModel.fromJson(json.decode(str));

String affirmationAllModelToJson(AffirmationAllModel data) => json.encode(data.toJson());

class AffirmationAllModel {
  List<AffirmationDataAll>? data;
  int? total;

  AffirmationAllModel({
    this.data,
    this.total,
  });

  factory AffirmationAllModel.fromJson(Map<String, dynamic> json) => AffirmationAllModel(
    data: json["data"] == null ? [] : List<AffirmationDataAll>.from(json["data"]!.map((x) => AffirmationDataAll.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
  };
}

class AffirmationDataAll {
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
  String? gName;
  String? gDescription;
  AffirmationDataAll({
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
    this.gDescription,
    this.gName
  });

  factory AffirmationDataAll.fromJson(Map<String, dynamic> json) => AffirmationDataAll(
    userLiked: json["userLiked"],
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
    gDescription: json["g_description"],
    gName: json["g_name"],
  );

  Map<String, dynamic> toJson() => {
    "userLiked": userLiked,
    "_id": id,
    "name": name,
    "description": description,
    "category": category,
    "status": status,
    "created_by":createdBy,
    "isDefault": isDefault,
    "isLiked": isLiked,
    "audioFile": audioFile,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "g_name": gName,
    "g_description": gDescription,
  };
}

