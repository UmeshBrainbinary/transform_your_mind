// To parse this JSON data, do
//
//     final sleepChartModel = sleepChartModelFromJson(jsonString);

import 'dart:convert';

SleepChartModel sleepChartModelFromJson(String str) =>
    SleepChartModel.fromJson(json.decode(str));

String sleepChartModelToJson(SleepChartModel data) =>
    json.encode(data.toJson());

class SleepChartModel {
  List<Datum>? data;
  int? averageSleep;

  SleepChartModel({
    this.data,
    this.averageSleep,
  });

  factory SleepChartModel.fromJson(Map<String, dynamic> json) =>
      SleepChartModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        averageSleep: json["averageSleep"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "averageSleep": averageSleep,
      };
}

class Datum {
  String? day;
  int? averageSleep;

  Datum({
    this.day,
    this.averageSleep,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        day: json["day"],
        averageSleep: json["averageSleep"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "averageSleep": averageSleep,
      };
}
