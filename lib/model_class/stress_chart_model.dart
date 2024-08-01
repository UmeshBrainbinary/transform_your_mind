// To parse this JSON data, do
//
//     final stressChartModel = stressChartModelFromJson(jsonString);

import 'dart:convert';

StressChartModel stressChartModelFromJson(String str) =>
    StressChartModel.fromJson(json.decode(str));

String stressChartModelToJson(StressChartModel data) =>
    json.encode(data.toJson());

class StressChartModel {
  List<Datum>? data;
  int? averageStress;

  StressChartModel({
    this.data,
    this.averageStress,
  });

  factory StressChartModel.fromJson(Map<String, dynamic> json) =>
      StressChartModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        averageStress: json["averageStress"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "averageStress": averageStress,
      };
}

class Datum {
  String? day;
  int? averageStress;

  Datum({
    this.day,
    this.averageStress,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        day: json["day"],
        averageStress: json["averageStress"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "averageStress": averageStress,
      };
}
