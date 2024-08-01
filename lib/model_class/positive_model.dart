// To parse this JSON data, do
//
//     final positiveModel = positiveModelFromJson(jsonString);

import 'dart:convert';

PositiveModel positiveModelFromJson(String str) => PositiveModel.fromJson(json.decode(str));

String positiveModelToJson(PositiveModel data) => json.encode(data.toJson());

class PositiveModel {
  List<PositiveDataList>? data;

  PositiveModel({
    this.data,
  });

  factory PositiveModel.fromJson(Map<String, dynamic> json) => PositiveModel(
    data: json["data"] == null ? [] : List<PositiveDataList>.from(json["data"]!.map((x) => PositiveDataList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PositiveDataList {
  String? id;
  String? title;
  String? description;
  dynamic image;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PositiveDataList({
    this.id,
    this.title,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PositiveDataList.fromJson(Map<String, dynamic> json) => PositiveDataList(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "image": image,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
