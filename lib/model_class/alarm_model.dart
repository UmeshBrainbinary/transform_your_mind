// To parse this JSON data, do
//
//     final alarmModel = alarmModelFromJson(jsonString);

import 'dart:convert';

AlarmModel alarmModelFromJson(String str) => AlarmModel.fromJson(json.decode(str));

String alarmModelToJson(AlarmModel data) => json.encode(data.toJson());

class AlarmModel {
  List<AlarmData>? data;

  AlarmModel({
    this.data,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
    data: json["data"] == null ? [] : List<AlarmData>.from(json["data"]!.map((x) => AlarmData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AlarmData {
  String? id;
  int? hours;
  int? minutes;
  int? seconds;
  String? time;
  String? sound;
  String? audioFile;
  String? name;
  String? description;
  String? affirmationId;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  AlarmData({
    this.id,
    this.hours,
    this.minutes,
    this.seconds,
    this.time,
    this.sound,
    this.audioFile,
    this.name,
    this.description,
    this.affirmationId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AlarmData.fromJson(Map<String, dynamic> json) => AlarmData(
    id: json["_id"],
    hours: json["hours"],
    minutes: json["minutes"],
    seconds: json["seconds"],
    time: json["time"],
    sound: json["sound"],
    audioFile: json["audioFile"],
    name: json["name"],
    description: json["description"],
    affirmationId: json["affirmationId"],
    createdBy: json["created_by"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "hours": hours,
    "minutes": minutes,
    "seconds": seconds,
    "time": time,
    "sound": sound,
    "audioFile": audioFile,
    "name": name,
    "description": description,
    "affirmationId": affirmationId,
    "created_by": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
