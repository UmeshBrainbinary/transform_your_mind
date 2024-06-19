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
  String? id;
  String? name;
  String? email;
  String? password;
  String? userProfile;
  dynamic mobile;
  dynamic countryCode;
  int? gender;
  int? userType;
  dynamic otp;
  List<String>? focuses;
  DateTime? dob;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<String>? bookmarkedPods;
  List<RatedPod>? ratedPods;

  Data({
    this.id,
    this.name,
    this.email,
    this.password,
    this.userProfile,
    this.mobile,
    this.countryCode,
    this.gender,
    this.userType,
    this.otp,
    this.focuses,
    this.dob,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.bookmarkedPods,
    this.ratedPods,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    userProfile: json["user_profile"],
    mobile: json["mobile"],
    countryCode: json["country_code"],
    gender: json["gender"],
    userType: json["user_type"],
        otp: json["otp"],
        focuses: json["focuses"] == null ? [] : List<String>.from(json["focuses"]!.map((x) => x)),
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
        bookmarkedPods: json["bookmarkedPods"] == null
            ? []
            : List<String>.from(json["bookmarkedPods"]!.map((x) => x)),
        ratedPods: json["ratedPods"] == null
            ? []
            : List<RatedPod>.from(
                json["ratedPods"]!.map((x) => RatedPod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "password": password,
    "user_profile": userProfile,
    "mobile": mobile,
    "country_code": countryCode,
    "gender": gender,
    "user_type": userType,
        "otp": otp,
        "focuses": focuses == null ? [] : List<dynamic>.from(focuses!.map((x) => x)),
    "dob": dob?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
        "bookmarkedPods": bookmarkedPods == null
            ? []
            : List<dynamic>.from(bookmarkedPods!.map((x) => x)),
        "ratedPods": ratedPods == null
            ? []
            : List<dynamic>.from(ratedPods!.map((x) => x.toJson())),
      };
}

class RatedPod {
  String? podId;
  String? note;
  int? star;
  String? id;

  RatedPod({
    this.podId,
    this.note,
    this.star,
    this.id,
  });

  factory RatedPod.fromJson(Map<String, dynamic> json) => RatedPod(
        podId: json["podId"],
        note: json["note"],
        star: json["star"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "podId": podId,
        "note": note,
        "star": star,
        "_id": id,
      };
}
