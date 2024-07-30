// To parse this JSON data, do
//
//     final getScreenModel = getScreenModelFromJson(jsonString);

import 'dart:convert';

GetScreenModel getScreenModelFromJson(String str) => GetScreenModel.fromJson(json.decode(str));

String getScreenModelToJson(GetScreenModel data) => json.encode(data.toJson());

class GetScreenModel {
  List<Datum>? data;

  GetScreenModel({
    this.data,
  });

  factory GetScreenModel.fromJson(Map<String, dynamic> json) => GetScreenModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? authorName;
  String? image;
  String? quote;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? gAuthorName;
  String? gQuote;

  Datum({
    this.id,
    this.authorName,
    this.image,
    this.quote,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.gAuthorName,
    this.gQuote,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    authorName: json["authorName"],
    image: json["image"],
    quote: json["quote"],
    createdBy: json["created_by"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    gAuthorName: json["g_authorName"],
    gQuote: json["g_quote"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "authorName": authorName,
    "image": image,
    "quote": quote,
    "created_by": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "g_authorName": gAuthorName,
    "g_quote": gQuote,
  };
}
