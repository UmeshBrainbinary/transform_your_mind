// To parse this JSON data, do
//
//     final moodChartModel = moodChartModelFromJson(jsonString);

import 'dart:convert';

MoodChartModel moodChartModelFromJson(String str) =>
    MoodChartModel.fromJson(json.decode(str));

String moodChartModelToJson(MoodChartModel data) => json.encode(data.toJson());

class MoodChartModel {
  List<Datum>? data;
  dynamic averageFeeling;

  MoodChartModel({
    this.data,
    this.averageFeeling,
  });

  factory MoodChartModel.fromJson(Map<String, dynamic> json) => MoodChartModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        averageFeeling: json["averageFeeling"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "averageFeeling": averageFeeling,
      };
}

class Datum {
  String? day;
  dynamic averageFeeling;

  Datum({
    this.day,
    this.averageFeeling,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        day: json["day"],
        averageFeeling: json["averageFeeling"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "averageFeeling": averageFeeling,
      };
}
