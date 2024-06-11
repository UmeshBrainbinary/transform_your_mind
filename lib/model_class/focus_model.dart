// To parse this JSON data, do
//
//     final focusesModel = focusesModelFromJson(jsonString);

import 'dart:convert';

FocusesModel focusesModelFromJson(String str) =>
    FocusesModel.fromJson(json.decode(str));

String focusesModelToJson(FocusesModel data) => json.encode(data.toJson());

class FocusesModel {
  List<Datum>? data;

  FocusesModel({
    this.data,
  });

  factory FocusesModel.fromJson(Map<String, dynamic> json) => FocusesModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  String? name;
  String? description;
  dynamic category;
  int? status;
  int? type;
  CreatedBy? createdBy;
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
        createdBy: createdByValues.map[json["created_by"]]!,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "category": category,
        "status": status,
        "type": type,
        "created_by": createdByValues.reverse[createdBy],
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

enum CreatedBy { THE_6667_E00_B474_A3621861060_C0 }

final createdByValues = EnumValues(
    {"6667e00b474a3621861060c0": CreatedBy.THE_6667_E00_B474_A3621861060_C0});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
