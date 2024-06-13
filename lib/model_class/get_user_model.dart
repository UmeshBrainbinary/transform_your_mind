// To parse this JSON data, do
//
//     final getUserModel = getUserModelFromJson(jsonString);

import 'dart:convert';

GetUserModel getUserModelFromJson(String str) => GetUserModel.fromJson(json.decode(str));

String getUserModelToJson(GetUserModel data) => json.encode(data.toJson());

class GetUserModel {
  Data? data;

  GetUserModel({
    this.data,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) => GetUserModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
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

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
