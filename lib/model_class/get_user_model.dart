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
  int? gender;
  int? userType;
  dynamic otp;
  List<String>? focuses;
  List<String>? affirmations;
  DateTime? dob;
  List<dynamic>? bookmarkedPods;
  List<String>? recentlyPlayedPods;
  bool? isSubscribed;
  List<dynamic>? likedAffirmation;
  List<String>? likedMotivationalMessages;
  String? motivationalMessage;
  String? language;
  bool? morningMoodQuestions;
  bool? morningStressQuestions;
  bool? morningSleepQuestions;
  bool? morningMotivationQuestions;
  bool? eveningMoodQuestions;
  bool? eveningStressQuestions;
  bool? eveningMotivationQuestions;
  dynamic createdBy;
  List<dynamic>? ratedPods;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? myGratitude;
  bool? welcomeScreen;

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
    this.recentlyPlayedPods,
    this.isSubscribed,
    this.likedAffirmation,
    this.likedMotivationalMessages,
    this.motivationalMessage,
    this.language,
    this.morningMoodQuestions,
    this.morningStressQuestions,
    this.morningSleepQuestions,
    this.morningMotivationQuestions,
    this.eveningMoodQuestions,
    this.eveningStressQuestions,
    this.eveningMotivationQuestions,
    this.createdBy,
    this.ratedPods,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.myGratitude,
    this.welcomeScreen,
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
    bookmarkedPods: json["bookmarkedPods"] == null ? [] : List<dynamic>.from(json["bookmarkedPods"]!.map((x) => x)),
    recentlyPlayedPods: json["recentlyPlayedPods"] == null ? [] : List<String>.from(json["recentlyPlayedPods"]!.map((x) => x)),
    isSubscribed: json["isSubscribed"],
    likedAffirmation: json["likedAffirmation"] == null ? [] : List<dynamic>.from(json["likedAffirmation"]!.map((x) => x)),
    likedMotivationalMessages: json["likedMotivationalMessages"] == null ? [] : List<String>.from(json["likedMotivationalMessages"]!.map((x) => x)),
    motivationalMessage: json["motivationalMessage"],
    language: json["language"],
    morningMoodQuestions: json["morningMoodQuestions"],
    morningStressQuestions: json["morningStressQuestions"],
    morningSleepQuestions: json["morningSleepQuestions"],
    morningMotivationQuestions: json["morningMotivationQuestions"],
    eveningMoodQuestions: json["eveningMoodQuestions"],
    eveningStressQuestions: json["eveningStressQuestions"],
    eveningMotivationQuestions: json["eveningMotivationQuestions"],
    createdBy: json["created_by"],
    ratedPods: json["ratedPods"] == null ? [] : List<dynamic>.from(json["ratedPods"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    myGratitude: json["myGratitude"],
    welcomeScreen: json["welcomeScreen"],
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
    "focuses": focuses == null ? [] : List<dynamic>.from(focuses!.map((x) => x)),
    "affirmations": affirmations == null ? [] : List<dynamic>.from(affirmations!.map((x) => x)),
    "dob": dob?.toIso8601String(),
    "bookmarkedPods": bookmarkedPods == null ? [] : List<dynamic>.from(bookmarkedPods!.map((x) => x)),
    "recentlyPlayedPods": recentlyPlayedPods == null ? [] : List<dynamic>.from(recentlyPlayedPods!.map((x) => x)),
    "isSubscribed": isSubscribed,
    "likedAffirmation": likedAffirmation == null ? [] : List<dynamic>.from(likedAffirmation!.map((x) => x)),
    "likedMotivationalMessages": likedMotivationalMessages == null ? [] : List<dynamic>.from(likedMotivationalMessages!.map((x) => x)),
    "motivationalMessage": motivationalMessage,
    "language": language,
    "morningMoodQuestions": morningMoodQuestions,
    "morningStressQuestions": morningStressQuestions,
    "morningSleepQuestions": morningSleepQuestions,
    "morningMotivationQuestions": morningMotivationQuestions,
    "eveningMoodQuestions": eveningMoodQuestions,
    "eveningStressQuestions": eveningStressQuestions,
    "eveningMotivationQuestions": eveningMotivationQuestions,
    "created_by": createdBy,
    "ratedPods": ratedPods == null ? [] : List<dynamic>.from(ratedPods!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "myGratitude": myGratitude,
    "welcomeScreen": welcomeScreen,
  };
}
