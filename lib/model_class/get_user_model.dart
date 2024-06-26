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
  dynamic userProfile;
  int? gender;
  int? userType;
  dynamic otp;
  List<String>? focuses;
  List<String>? affirmations;
  DateTime? dob;
  List<String?>? bookmarkedPods;
  bool? isSubscribed;
  List<RatedPod>? ratedPods;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? motivationalMessage;

  Data({
    this.id,
    this.name,
    this.email,
    this.password,
    this.userProfile,
    this.gender,
    this.userType,
    this.otp,
    this.focuses,
    this.affirmations,
    this.dob,
    this.bookmarkedPods,
    this.isSubscribed,
    this.ratedPods,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.motivationalMessage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    userProfile: json["user_profile"],
    gender: json["gender"],
    userType: json["user_type"],
    otp: json["otp"],
    focuses: json["focuses"] == null ? [] : List<String>.from(json["focuses"]!.map((x) => x)),
    affirmations: json["affirmations"] == null ? [] : List<String>.from(json["affirmations"]!.map((x) => x)),
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    bookmarkedPods: json["bookmarkedPods"] == null ? [] : List<String?>.from(json["bookmarkedPods"]!.map((x) => x)),
    isSubscribed: json["isSubscribed"],
    ratedPods: json["ratedPods"] == null ? [] : List<RatedPod>.from(json["ratedPods"]!.map((x) => RatedPod.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    motivationalMessage: json["motivationalMessage"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "password": password,
    "user_profile": userProfile,
    "gender": gender,
    "user_type": userType,
    "otp": otp,
    "affirmations": affirmations,
    "focuses": focuses == null ? [] : List<dynamic>.from(focuses!.map((x) => x)),
    "dob": dob?.toIso8601String(),
    "bookmarkedPods": bookmarkedPods == null ? [] : List<dynamic>.from(bookmarkedPods!.map((x) => x)),
    "isSubscribed": isSubscribed,
    "ratedPods": ratedPods == null ? [] : List<dynamic>.from(ratedPods!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "motivationalMessage": motivationalMessage,
    "__v": v,
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
