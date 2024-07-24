// To parse this JSON data, do
//
//     final weekDataModel = weekDataModelFromJson(jsonString);

import 'dart:convert';

WeekDataModel weekDataModelFromJson(String str) => WeekDataModel.fromJson(json.decode(str));

String weekDataModelToJson(WeekDataModel data) => json.encode(data.toJson());

class WeekDataModel {
  List<WeekDataList>? data;
  int? todayTotalGratitude;
  int? todayTotalCompleted;

  WeekDataModel({
    this.data,
    this.todayTotalGratitude,
    this.todayTotalCompleted,
  });

  factory WeekDataModel.fromJson(Map<String, dynamic> json) => WeekDataModel(
    data: json["data"] == null ? [] : List<WeekDataList>.from(json["data"]!.map((x) => WeekDataList.fromJson(x))),
    todayTotalGratitude: json["todayTotalGratitudes"],
    todayTotalCompleted: json["todayTotalCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "todayTotalGratitudes": todayTotalGratitude,
    "todayTotalCompleted": todayTotalCompleted,
  };
}

class WeekDataList {
  String? day;
  bool? isCompleted;

  WeekDataList({
    this.day,
    this.isCompleted,
  });

  factory WeekDataList.fromJson(Map<String, dynamic> json) => WeekDataList(
    day: json["day"],
    isCompleted: json["isCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "isCompleted": isCompleted,
  };
}
