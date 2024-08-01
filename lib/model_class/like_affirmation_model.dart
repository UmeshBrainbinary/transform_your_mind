// To parse this JSON data, do
//
//     final likeAffirmationModel = likeAffirmationModelFromJson(jsonString);

import 'dart:convert';

LikeAffirmationModel likeAffirmationModelFromJson(String str) => LikeAffirmationModel.fromJson(json.decode(str));

String likeAffirmationModelToJson(LikeAffirmationModel data) => json.encode(data.toJson());

class LikeAffirmationModel {
  List<Datum>? data;
  int? total;

  LikeAffirmationModel({
    this.data,
    this.total,
  });

  factory LikeAffirmationModel.fromJson(Map<String, dynamic> json) => LikeAffirmationModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
  };
}

class Datum {
  String? id;
  String? name;
  String? gName;
  String? description;
  String? gDescription;
  String? category;
  int? status;
  String? createdBy;
  bool? isDefault;
  bool? isLiked;
  bool? userLiked;
  String? audioFile;
  bool? isCompleted;
  int? alarmId;
  String? lang;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.name,
    this.gName,
    this.description,
    this.gDescription,
    this.category,
    this.status,
    this.createdBy,
    this.isDefault,
    this.isLiked,
    this.userLiked,
    this.audioFile,
    this.isCompleted,
    this.alarmId,
    this.lang,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    name: json["name"],
    gName: json["g_name"],
    description: json["description"],
    gDescription: json["g_description"],
    category: json["category"],
    status: json["status"],
    createdBy: json["created_by"],
    isDefault: json["isDefault"],
    isLiked: json["isLiked"],
    userLiked: json["userLiked"],
    audioFile: json["audioFile"],
    isCompleted: json["isCompleted"],
    alarmId: json["alarmId"],
    lang: json["lang"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "g_name": gName,
    "description": description,
    "g_description": gDescription,
    "category": category,
    "status": status,
    "created_by": createdBy,
    "isDefault": isDefault,
    "isLiked": isLiked,
    "userLiked": userLiked,
    "audioFile": audioFile,
    "isCompleted": isCompleted,
    "alarmId": alarmId,
    "lang": lang,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

