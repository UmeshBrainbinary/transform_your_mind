// To parse this JSON data, do
//
//     final resendModel = resendModelFromJson(jsonString);

import 'dart:convert';

ResendModel resendModelFromJson(String str) => ResendModel.fromJson(json.decode(str));

String resendModelToJson(ResendModel data) => json.encode(data.toJson());

class ResendModel {
  String? token;
  String? message;

  ResendModel({
    this.token,
    this.message,
  });

  factory ResendModel.fromJson(Map<String, dynamic> json) => ResendModel(
    token: json["token"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "message": message,
  };
}
