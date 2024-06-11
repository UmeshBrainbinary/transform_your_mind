// To parse this JSON data, do
//
//     final verifyModel = verifyModelFromJson(jsonString);

import 'dart:convert';

VerifyModel verifyModelFromJson(String str) => VerifyModel.fromJson(json.decode(str));

String verifyModelToJson(VerifyModel data) => json.encode(data.toJson());

class VerifyModel {
  String? message;
  String? token;
  User? user;

  VerifyModel({
    this.message,
    this.token,
    this.user,
  });

  factory VerifyModel.fromJson(Map<String, dynamic> json) => VerifyModel(
    message: json["message"],
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "user": user?.toJson(),
  };
}

class User {
  dynamic otp;
  String? id;
  String? name;
  String? email;
  String? password;
  dynamic userProfile;
  dynamic mobile;
  dynamic countryCode;
  int? gender;
  int? userType;
  List<dynamic>? focuses;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  User({
    this.otp,
    this.id,
    this.name,
    this.email,
    this.password,
    this.userProfile,
    this.mobile,
    this.countryCode,
    this.gender,
    this.userType,
    this.focuses,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    otp: json["otp"],
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    userProfile: json["user_profile"],
    mobile: json["mobile"],
    countryCode: json["country_code"],
    gender: json["gender"],
    userType: json["user_type"],
    focuses: json["focuses"] == null ? [] : List<dynamic>.from(json["focuses"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "otp": otp,
    "_id": id,
    "name": name,
    "email": email,
    "password": password,
    "user_profile": userProfile,
    "mobile": mobile,
    "country_code": countryCode,
    "gender": gender,
    "user_type": userType,
    "focuses": focuses == null ? [] : List<dynamic>.from(focuses!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
