// To parse this JSON data, do
//
//     final todayGratitude = todayGratitudeFromJson(jsonString);

import 'dart:convert';

TodayGratitude todayGratitudeFromJson(String str) => TodayGratitude.fromJson(json.decode(str));

String todayGratitudeToJson(TodayGratitude data) => json.encode(data.toJson());

class TodayGratitude {
  List<TodayGData>? data;
  String? message;

  TodayGratitude({
    this.data,
    this.message,
  });

  factory TodayGratitude.fromJson(Map<String, dynamic> json) => TodayGratitude(
    data: json["data"] == null ? [] : List<TodayGData>.from(json["data"]!.map((x) => TodayGData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class TodayGData {
  String? id;
  String? name;
  String? description;
  DateTime? date;
  String? createdBy;
  bool? isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  TodayGData({
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

  factory TodayGData.fromJson(Map<String, dynamic> json) => TodayGData(
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
