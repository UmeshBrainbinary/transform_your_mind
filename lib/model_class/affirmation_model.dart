// To parse this JSON data, do
//
//     final affirmationModel = affirmationModelFromJson(jsonString);

import 'dart:convert';

AffirmationModel affirmationModelFromJson(String str) => AffirmationModel.fromJson(json.decode(str));

String affirmationModelToJson(AffirmationModel data) => json.encode(data.toJson());

class AffirmationModel {
  List<Datum>? data;

  AffirmationModel({
    this.data,
  });

  factory AffirmationModel.fromJson(Map<String, dynamic> json) => AffirmationModel(
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
  dynamic category;
  int? status;
  int? type;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.name,
    this.description,
    this.category,
    this.status,
    this.type,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    category: json["category"],
    status: json["status"],
    type: json["type"],
    createdBy: json["created_by"],
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
    "type": type,
    "created_by": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
