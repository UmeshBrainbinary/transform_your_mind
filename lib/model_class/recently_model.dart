// To parse this JSON data, do
//
//     final recentlyModel = recentlyModelFromJson(jsonString);

import 'dart:convert';

RecentlyModel recentlyModelFromJson(String str) => RecentlyModel.fromJson(json.decode(str));

String recentlyModelToJson(RecentlyModel data) => json.encode(data.toJson());

class RecentlyModel {
  List<RecentlyData>? data;

  RecentlyModel({
    this.data,
  });

  factory RecentlyModel.fromJson(Map<String, dynamic> json) => RecentlyModel(
    data: json["data"] == null ? [] : List<RecentlyData>.from(json["data"]!.map((x) => RecentlyData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class RecentlyData {
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
  bool? isRecommended;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? rating;

  RecentlyData({
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
    this.createdAt,
    this.updatedAt,
    this.v,
    this.rating,
  });

  factory RecentlyData.fromJson(Map<String, dynamic> json) => RecentlyData(
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
    isRecommended: json["isRecommended"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    rating: json["rating"],
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
    "isRecommended": isRecommended,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "rating": rating,
  };
}
