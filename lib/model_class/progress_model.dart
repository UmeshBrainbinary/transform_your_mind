// To parse this JSON data, do
//
//     final progressModel = progressModelFromJson(jsonString);

import 'dart:convert';

ProgressModel progressModelFromJson(String str) => ProgressModel.fromJson(json.decode(str));

String progressModelToJson(ProgressModel data) => json.encode(data.toJson());

class ProgressModel {
  Data? data;

  ProgressModel({
    this.data,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  int? gratitudeCount;
  int? affirmationCount;
  int? positiveMomentCount;

  Data({
    this.gratitudeCount,
    this.affirmationCount,
    this.positiveMomentCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    gratitudeCount: json["gratitudeCount"],
    affirmationCount: json["affirmationCount"],
    positiveMomentCount: json["positiveMomentCount"],
  );

  Map<String, dynamic> toJson() => {
    "gratitudeCount": gratitudeCount,
    "affirmationCount": affirmationCount,
    "positiveMomentCount": positiveMomentCount,
  };
}
