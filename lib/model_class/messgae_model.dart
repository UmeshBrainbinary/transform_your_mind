// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  List<Datum>? data;
  int? total;
  MessageModel({
    this.data,
    this.total,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
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
  String? message;
  String? category;
  int? status;
  String? createdBy;
  String? motivationalImage;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
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
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
  };
}
