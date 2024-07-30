// To parse this JSON data, do
//
//     final affirmationModel = affirmationModelFromJson(jsonString);

import 'dart:convert';

AffirmationModel affirmationModelFromJson(String str) => AffirmationModel.fromJson(json.decode(str));

String affirmationModelToJson(AffirmationModel data) => json.encode(data.toJson());

class AffirmationModel {
  List<AffirmationData>? data;
  int? total;

  AffirmationModel({
    this.data,
    this.total,
  });

  factory AffirmationModel.fromJson(Map<String, dynamic> json) => AffirmationModel(
    data: json["data"] == null ? [] : List<AffirmationData>.from(json["data"]!.map((x) => AffirmationData.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
  };
}

class AffirmationData {
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

  AffirmationData({
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
    this.gName,
    this.gDescription
  });

  factory AffirmationData.fromJson(Map<String, dynamic> json) => AffirmationData(
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
    gName: json["g_name"],
    gDescription: json["g_description"],
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
    "g_name": gName,
    "g_description": gDescription,
  };
}

