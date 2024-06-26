// To parse this JSON data, do
//
//     final todayAffirmation = todayAffirmationFromJson(jsonString);

import 'dart:convert';

TodayAffirmation todayAffirmationFromJson(String str) => TodayAffirmation.fromJson(json.decode(str));

String todayAffirmationToJson(TodayAffirmation data) => json.encode(data.toJson());

class TodayAffirmation {
  List<TodayAData>? data;
  String? message;

  TodayAffirmation({
    this.data,
    this.message,
  });

  factory TodayAffirmation.fromJson(Map<String, dynamic> json) => TodayAffirmation(
    data: json["data"] == null ? [] : List<TodayAData>.from(json["data"]!.map((x) => TodayAData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class TodayAData {
  String? id;
  String? name;
  String? description;
  DateTime? date;
  String? createdBy;
  bool? isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  TodayAData({
    this.id,
    this.name,
    this.description,
    this.date,
    this.createdBy,
    this.isCompleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory TodayAData.fromJson(Map<String, dynamic> json) => TodayAData(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    createdBy: json["created_by"],
    isCompleted: json["isCompleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "date": date?.toIso8601String(),
    "created_by": createdBy,
    "isCompleted": isCompleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
