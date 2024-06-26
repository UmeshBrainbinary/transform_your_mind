// To parse this JSON data, do
//
//     final getPodsModel = getPodsModelFromJson(jsonString);

import 'dart:convert';

GetPodsModel getPodsModelFromJson(String str) => GetPodsModel.fromJson(json.decode(str));

String getPodsModelToJson(GetPodsModel data) => json.encode(data.toJson());

class GetPodsModel {
  List<AudioData>? data;
  int? total;

  GetPodsModel({
    this.data,
    this.total,
  });

  factory GetPodsModel.fromJson(Map<String, dynamic> json) => GetPodsModel(
    data: json["data"] == null ? [] : List<AudioData>.from(json["data"]!.map((x) => AudioData.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
  };
}

class AudioData {
  bool? isBookmarked;
  bool? isRated;
  String? id;
  String? name;
  String? description;
  String? category;
  int? status;
  String? createdBy;
  int? podsBy;
  String? audioFile;
  String? expertName;
  String? image;
  String? downloadedPath;
  bool? isRecommended;
  bool? download ;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? rating;

  AudioData({
    this.isBookmarked,
    this.isRated,
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
    this.isRecommended,
    this.download,
    this.createdAt,
    this.downloadedPath,
    this.updatedAt,
    this.v,
    this.rating,
  });

  factory AudioData.fromJson(Map<String, dynamic> json) => AudioData(
    isBookmarked: json["isBookmarked"],
    isRated: json["isRated"],
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    category: json["category"],
    status: json["status"],
    createdBy:json["created_by"],
    podsBy: json["pods_by"],
    audioFile: json["audioFile"],
    expertName: json["expertName"],
    download: json["download"] ,
    image: json["image"],
    downloadedPath: json["downloadedPath"],
    isRecommended: json["isRecommended"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "isBookmarked": isBookmarked,
    "isRated": isRated,
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
    "download": download,
    "downloadedPath": downloadedPath,
    "isRecommended": isRecommended,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "rating": rating,
  };
}

