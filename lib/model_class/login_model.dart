// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  Data? data;
  Meta? meta;

  LoginModel({
    this.data,
    this.meta,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "meta": meta?.toJson(),
  };
}

class Data {
  String? id;
  String? name;
  String? email;
  int? gender;
  dynamic userProfile;

  Data({
    this.id,
    this.name,
    this.email,
    this.gender,
    this.userProfile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    gender: json["gender"],
    userProfile: json["user_profile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "gender": gender,
    "user_profile": userProfile,
  };
}

class Meta {
  String? message;
  String? token;

  Meta({
    this.message,
    this.token,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    message: json["message"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
  };
}
