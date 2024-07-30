// To parse this JSON data, do
//
//     final GratitudeAllDataModel = GratitudeAllDataModelFromJson(jsonString);

import 'dart:convert';

GratitudeAllDataModel GratitudeAllDataModelFromJson(String str) => GratitudeAllDataModel.fromJson(json.decode(str));

String GratitudeAllDataModelToJson(GratitudeAllDataModel data) => json.encode(data.toJson());

class GratitudeAllDataModel {
  List<GratitudeAllData>? data;

  GratitudeAllDataModel({
    this.data,
  });

  factory GratitudeAllDataModel.fromJson(Map<String, dynamic> json) => GratitudeAllDataModel(
    data: json["data"] == null ? [] : List<GratitudeAllData>.from(json["data"]!.map((x) => GratitudeAllData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GratitudeAllData {
  dynamic date;
  String? id;
  String? description;
  String? createdBy;
  bool? isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  GratitudeAllData({
    this.date,
    this.id,
    this.description,
    this.createdBy,
    this.isCompleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GratitudeAllData.fromJson(Map<String, dynamic> json) => GratitudeAllData(
    date: json["date"],
    id: json["_id"],
    description: json["description"],
    createdBy: json["created_by"],
    isCompleted: json["isCompleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "_id": id,
    "description": description,
    "created_by": createdBy,
    "isCompleted": isCompleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
