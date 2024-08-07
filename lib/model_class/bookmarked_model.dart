// To parse this JSON data, do
//
//     final bookmarkedModel = bookmarkedModelFromJson(jsonString);

import 'dart:convert';

BookmarkedModel bookmarkedModelFromJson(String str) => BookmarkedModel.fromJson(json.decode(str));

String bookmarkedModelToJson(BookmarkedModel data) => json.encode(data.toJson());

class BookmarkedModel {
  List<Datum>? data;
  int? total;

  BookmarkedModel({
    this.data,
    this.total,
  });

  factory BookmarkedModel.fromJson(Map<String, dynamic> json) => BookmarkedModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
  };
}

class Datum {
  bool? isBookmarked;
  bool? isRated;
  String? id;
  String? name;
  String? description;
  String? category;
  bool? status;
  String? createdBy;
  bool? podsBy;
  String? audioFile;
  String? expertName;
  String? image;
  bool? isRecommended;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? rating;
  bool? isPaid;

  Datum({
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
    this.createdAt,
    this.updatedAt,
    this.v,
    this.rating,
    this.isPaid,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    isBookmarked: json["isBookmarked"],
    isRated: json["isRated"],
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    category: json["category"],
    status: json["status"],
    createdBy: json["created_by"],
    podsBy: json["pods_by"],
    audioFile: json["audioFile"],
    expertName:json["expertName"],
    image: json["image"],
    isRecommended: json["isRecommended"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    rating: json["rating"],
    isPaid: json["isPaid"],
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
    "isRecommended": isRecommended,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "rating": rating,
    "isPaid": isPaid,
  };
}

