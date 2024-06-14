// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  String? message;
  String? token;
  User? user;

  RegisterModel({
    this.message,
    this.token,
    this.user,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
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
  String? name;
  String? email;
  String? password;
  String? gender;
  dynamic userProfile;
  String? otp;
  DateTime? dob;

  User({
    this.name,
    this.email,
    this.password,
    this.gender,
    this.userProfile,
    this.otp,
    this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    gender: json["gender"],
    userProfile: json["user_profile"],
    otp: json["otp"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "gender": gender,
    "user_profile": userProfile,
    "otp": otp,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
  };
}
