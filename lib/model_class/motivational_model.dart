// To parse this JSON data, do
//
//     final motivationalModel = motivationalModelFromJson(jsonString);

import 'dart:convert';

MotivationalModel motivationalModelFromJson(String str) => MotivationalModel.fromJson(json.decode(str));

String motivationalModelToJson(MotivationalModel data) => json.encode(data.toJson());

class MotivationalModel {
  List<Datum>? data;

  MotivationalModel({
    this.data,
  });

  factory MotivationalModel.fromJson(Map<String, dynamic> json) => MotivationalModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? message;
  dynamic category;
  int? status;
  String? createdBy;
  String? motivationalImage;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
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
