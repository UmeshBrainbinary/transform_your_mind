// To parse this JSON data, do
//
//     final affirmationCategoryModel = affirmationCategoryModelFromJson(jsonString);

import 'dart:convert';

AffirmationCategoryModel affirmationCategoryModelFromJson(String str) => AffirmationCategoryModel.fromJson(json.decode(str));

String affirmationCategoryModelToJson(AffirmationCategoryModel data) => json.encode(data.toJson());

class AffirmationCategoryModel {
  List<Datum>? data;

  AffirmationCategoryModel({
    this.data,
  });

  factory AffirmationCategoryModel.fromJson(Map<String, dynamic> json) => AffirmationCategoryModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]?.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? name;
  int? status;
  int? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? gName;
  String? gDescription;
  Datum({
    this.id,
    this.name,
    this.status,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.v,this.gDescription,
    this.gName
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    name: json["name"],
    status: json["status"],
    type: json["type"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    gName: json["g_name"],
    gDescription: json["g_description"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "status": status,
    "type": type,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "g_name": gName,
    "g_description": gDescription,
  };
}
