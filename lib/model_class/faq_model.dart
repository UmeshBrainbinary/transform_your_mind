// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  List<FaqData>? data;

  FaqModel({
    this.data,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        data: json["data"] == null
            ? []
            : List<FaqData>.from(json["data"]!.map((x) => FaqData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FaqData {
  String? id;
  String? question;
  String? gQuestion;
  String? answer;
  String? gAnswer;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  FaqData({
    this.id,
    this.question,
    this.answer,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
      this.gAnswer,
      this.gQuestion});

  factory FaqData.fromJson(Map<String, dynamic> json) => FaqData(
        id: json["_id"],
        question: json["question"],
        answer: json["answer"],
        createdBy: json["created_by"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        gAnswer: json["g_answer"],
        gQuestion: json["g_question"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "question": question,
        "answer": answer,
        "created_by": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "g_answer": gAnswer,
        "g_question": gQuestion,
      };
}
