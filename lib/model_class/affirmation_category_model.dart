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
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  dynamic audioFile;
  String? id;
  String? name;
  String? description;
  dynamic category;
  int? status;
  CreatedBy? createdBy;
  bool? isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? isLiked;

  Datum({
    this.audioFile,
    this.id,
    this.name,
    this.description,
    this.category,
    this.status,
    this.createdBy,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isLiked,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    audioFile: json["audioFile"],
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    category: json["category"],
    status: json["status"],
    createdBy: createdByValues.map[json["created_by"]]!,
    isDefault: json["isDefault"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isLiked: json["isLiked"],
  );

  Map<String, dynamic> toJson() => {
    "audioFile": audioFile,
    "_id": id,
    "name": name,
    "description": description,
    "category": category,
    "status": status,
    "created_by": createdByValues.reverse[createdBy],
    "isDefault": isDefault,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "isLiked": isLiked,
  };
}

enum CreatedBy {
  THE_6667_E00_B474_A3621861060_C0
}

final createdByValues = EnumValues({
  "6667e00b474a3621861060c0": CreatedBy.THE_6667_E00_B474_A3621861060_C0
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
