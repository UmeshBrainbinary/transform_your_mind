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
  bool? isFreeVersion;
  bool? affirmationCreated;
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
  List<String>? bookmarkedPods;
  List<String>? recentlyPlayedPods;
  bool? isSubscribed;
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
  List<RatedPod>? ratedPods;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? myGratitude;
  bool? welcomeScreen;
  List<PersonalAudio>? personalAudios;
  int? rawPrice;
  String? currencyCode;
  DateTime? expiryDate;
  String? price;
  DateTime? subscriptionDate;
  String? subscriptionDescription;
  String? subscriptionId;
  String? subscriptionTitle;

  Data({
    this.id,
    this.isFreeVersion,
    this.affirmationCreated,
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
    this.personalAudios,
    this.rawPrice,
    this.currencyCode,
    this.expiryDate,
    this.price,
    this.subscriptionDate,
    this.subscriptionDescription,
    this.subscriptionId,
    this.subscriptionTitle,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    isFreeVersion: json["isFreeVersion"],
    affirmationCreated: json["affirmationCreated"],
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
    bookmarkedPods: json["bookmarkedPods"] == null ? [] : List<String>.from(json["bookmarkedPods"]!.map((x) => x)),
    recentlyPlayedPods: json["recentlyPlayedPods"] == null ? [] : List<String>.from(json["recentlyPlayedPods"]!.map((x) => x)),
    isSubscribed: json["isSubscribed"],
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
    ratedPods: json["ratedPods"] == null ? [] : List<RatedPod>.from(json["ratedPods"]!.map((x) => RatedPod.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    myGratitude: json["myGratitude"],
    welcomeScreen: json["welcomeScreen"],
    personalAudios: json["personalAudios"] == null ? [] : List<PersonalAudio>.from(json["personalAudios"]!.map((x) => PersonalAudio.fromJson(x))),
    rawPrice: json["rawPrice"],
    currencyCode: json["currencyCode"],
    expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"]),
    price: json["price"],
    subscriptionDate: json["subscriptionDate"] == null ? null : DateTime.parse(json["subscriptionDate"]),
    subscriptionDescription: json["subscriptionDescription"],
    subscriptionId: json["subscriptionId"],
    subscriptionTitle: json["subscriptionTitle"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isFreeVersion": isFreeVersion,
    "affirmationCreated": affirmationCreated,
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
    "ratedPods": ratedPods == null ? [] : List<dynamic>.from(ratedPods!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "myGratitude": myGratitude,
    "welcomeScreen": welcomeScreen,
    "personalAudios": personalAudios == null ? [] : List<dynamic>.from(personalAudios!.map((x) => x.toJson())),
    "rawPrice": rawPrice,
    "currencyCode": currencyCode,
    "expiryDate": expiryDate?.toIso8601String(),
    "price": price,
    "subscriptionDate": subscriptionDate?.toIso8601String(),
    "subscriptionDescription": subscriptionDescription,
    "subscriptionId": subscriptionId,
    "subscriptionTitle": subscriptionTitle,
  };
}

class PersonalAudio {
  String? audioFile;
  String? audioName;
  String? description;
  String? gAudioName;
  String? gDescription;
  String? image;
  String? lang;
  String? id;

  PersonalAudio({
    this.audioFile,
    this.audioName,
    this.description,
    this.gAudioName,
    this.gDescription,
    this.image,
    this.lang,
    this.id,
  });

  factory PersonalAudio.fromJson(Map<String, dynamic> json) => PersonalAudio(
    audioFile: json["audioFile"],
    audioName: json["audioName"],
    description: json["description"],
    gAudioName: json["g_audioName"],
    gDescription: json["g_description"],
    image: json["image"],
    lang: json["lang"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "audioFile": audioFile,
    "audioName": audioName,
    "description": description,
    "g_audioName": gAudioName,
    "g_description": gDescription,
    "image": image,
    "lang": lang,
    "_id": id,
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
