// To parse this JSON data, do
//
//     final resetPassword = resetPasswordFromJson(jsonString);

import 'dart:convert';

ResetPassword resetPasswordFromJson(String str) => ResetPassword.fromJson(json.decode(str));

String resetPasswordToJson(ResetPassword data) => json.encode(data.toJson());

class ResetPassword {
  String? message;

  ResetPassword({
    this.message,
  });

  factory ResetPassword.fromJson(Map<String, dynamic> json) => ResetPassword(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
