// To parse this JSON data, do
//
//     final selfHypnoticModel = selfHypnoticModelFromJson(jsonString);

import 'dart:convert';

SelfHypnoticModel selfHypnoticModelFromJson(String str) => SelfHypnoticModel.fromJson(json.decode(str));

String selfHypnoticModelToJson(SelfHypnoticModel data) => json.encode(data.toJson());

class SelfHypnoticModel {
  List<SelfHypnoticData>? data;
  int? total;

  SelfHypnoticModel({
    this.data,
    this.total,
  });

  factory SelfHypnoticModel.fromJson(Map<String, dynamic> json) => SelfHypnoticModel(
    data: json["data"] == null ? [] : List<SelfHypnoticData>.from(json["data"]!.map((x) => SelfHypnoticData.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
  };
}

class SelfHypnoticData {
  String? id;
  String? name;
  String? description;
  String? gName;
  String? gDescription;
  String? category;
  bool? status;
  String? createdBy;
  bool? podsBy;
  String? audioFile;
  String? expertName;
  dynamic gExpertName;
  String? image;
  bool? isRecommended;
  bool? isBookmarked;
  bool? isRated;
  int? rating;
  bool? isPaid;
  bool? selfHypnotic;
  dynamic amount;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? lang;

  SelfHypnoticData({
    this.id,
    this.name,
    this.description,
    this.gName,
    this.gDescription,
    this.category,
    this.status,
    this.createdBy,
    this.podsBy,
    this.audioFile,
    this.expertName,
    this.gExpertName,
    this.image,
    this.isRecommended,
    this.isBookmarked,
    this.isRated,
    this.rating,
    this.isPaid,
    this.selfHypnotic,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lang,
  });

  factory SelfHypnoticData.fromJson(Map<String, dynamic> json) => SelfHypnoticData(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    gName: json["g_name"],
    gDescription: json["g_description"],
    category: json["category"],
    status: json["status"],
    createdBy: json["created_by"],
    podsBy: json["pods_by"],
    audioFile: json["audioFile"],
    expertName: json["expertName"],
    gExpertName: json["g_expertName"],
    image: json["image"],
    isRecommended: json["isRecommended"],
    isBookmarked: json["isBookmarked"],
    isRated: json["isRated"],
    rating: json["rating"],
    isPaid: json["isPaid"],
    selfHypnotic: json["selfHypnotic"],
    amount: json["amount"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    lang: json["lang"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "g_name": gName,
    "g_description": gDescription,
    "category": category,
    "status": status,
    "created_by": createdBy,
    "pods_by": podsBy,
    "audioFile": audioFile,
    "expertName": expertName,
    "g_expertName": gExpertName,
    "image": image,
    "isRecommended": isRecommended,
    "isBookmarked": isBookmarked,
    "isRated": isRated,
    "rating": rating,
    "isPaid": isPaid,
    "selfHypnotic": selfHypnotic,
    "amount": amount,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "lang": lang,
  };
}
