// To parse this JSON data, do
//
//     final createPositiveMomentsModel = createPositiveMomentsModelFromJson(jsonString);

import 'dart:convert';

CreatePositiveMomentsModel createPositiveMomentsModelFromJson(String str) => CreatePositiveMomentsModel.fromJson(json.decode(str));

String createPositiveMomentsModelToJson(CreatePositiveMomentsModel data) => json.encode(data.toJson());

class CreatePositiveMomentsModel {
  String? message;

  CreatePositiveMomentsModel({
    this.message,
  });

  factory CreatePositiveMomentsModel.fromJson(Map<String, dynamic> json) => CreatePositiveMomentsModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
