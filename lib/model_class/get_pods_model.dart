// To parse this JSON data, do
//
//     final getPodsModel = getPodsModelFromJson(jsonString);

import 'dart:convert';

GetPodsModel getPodsModelFromJson(String str) => GetPodsModel.fromJson(json.decode(str));

String getPodsModelToJson(GetPodsModel data) => json.encode(data.toJson());

class GetPodsModel {
  List<AudioData>? data;

  GetPodsModel({
    this.data,
  });

  factory GetPodsModel.fromJson(Map<String, dynamic> json) => GetPodsModel(
    data: json["data"] == null ? [] : List<AudioData>.from(json["data"]!.map((x) => AudioData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AudioData {
  String? id;
  String? name;
  String? description;
  dynamic category;
  int? status;
  String? createdBy;
  int? podsBy;
  String? audioFile;
  String? expertName;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  AudioData({
    this.id,
    this.name,
    this.description,
    this.category,
    this.status,
    this.createdBy,
    this.podsBy,
    this.audioFile,
    this.expertName,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AudioData.fromJson(Map<String, dynamic> json) => AudioData(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    category: json["category"],
    status: json["status"],
    createdBy: json["created_by"],
    podsBy: json["pods_by"],
    audioFile: json["audioFile"],
    expertName: json["expertName"],
    image: json["image"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "category": category,
    "status": status,
    "created_by": createdBy,
    "pods_by": podsBy,
    "audioFile": audioFile,
    "expertName": expertName,
    "image": image,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
