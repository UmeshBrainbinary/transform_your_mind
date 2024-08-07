// To parse this JSON data, do
//
//     final getPersonalDataModel = getPersonalDataModelFromJson(jsonString);

import 'dart:convert';

GetPersonalDataModel getPersonalDataModelFromJson(String str) => GetPersonalDataModel.fromJson(json.decode(str));

String getPersonalDataModelToJson(GetPersonalDataModel data) => json.encode(data.toJson());

class GetPersonalDataModel {
  List<PersonalDataList>? data;

  GetPersonalDataModel({
    this.data,
  });

  factory GetPersonalDataModel.fromJson(Map<String, dynamic> json) => GetPersonalDataModel(
    data: json["data"] == null ? [] : List<PersonalDataList>.from(json["data"]!.map((x) => PersonalDataList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PersonalDataList {
  String? audioFile;
  String? audioName;
  String? description;
  dynamic gAudioName;
  dynamic gDescription;
  String? image;
  String? lang;
  String? id;

  PersonalDataList({
    this.audioFile,
    this.audioName,
    this.description,
    this.gAudioName,
    this.gDescription,
    this.image,
    this.lang,
    this.id,
  });

  factory PersonalDataList.fromJson(Map<String, dynamic> json) => PersonalDataList(
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
