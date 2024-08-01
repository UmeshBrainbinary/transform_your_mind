// To parse this JSON data, do
//
//     final motivationalModel = motivationalModelFromJson(jsonString);

import 'dart:convert';

MotivationalModel motivationalModelFromJson(String str) => MotivationalModel.fromJson(json.decode(str));

String motivationalModelToJson(MotivationalModel data) => json.encode(data.toJson());

class MotivationalModel {
  List<MotivationalData>? data;
  int? total;

  MotivationalModel({
    this.data,
    this.total,
  });

  factory MotivationalModel.fromJson(Map<String, dynamic> json) => MotivationalModel(
    data: json["data"] == null ? [] : List<MotivationalData>.from(json["data"]!.map((x) => MotivationalData.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
  };
}

class MotivationalData {
  bool? userLiked;
  String? id;
  String? message;
  String? category;
  int? status;
  String? createdBy;
  String? motivationalImage;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? gMessage;

  MotivationalData({
    this.userLiked,
    this.id,
    this.message,
    this.category,
    this.status,
    this.createdBy,
    this.motivationalImage,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.gMessage,
  });

  factory MotivationalData.fromJson(Map<String, dynamic> json) => MotivationalData(
    userLiked: json["userLiked"],
    id: json["_id"],
    message: json["message"],
    category: json["category"],
    status: json["status"],
    createdBy: json["created_by"],
    motivationalImage: json["motivational_image"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
        gMessage: json["g_message"],
      );

  Map<String, dynamic> toJson() => {
    "userLiked": userLiked,
    "_id": id,
    "message": message,
    "category": category,
    "status": status,
    "created_by": createdBy,
    "motivational_image": motivationalImage,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
        "g_message": gMessage,
      };
}
