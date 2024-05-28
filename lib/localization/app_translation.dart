import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppTranslations extends Translations {
  static Map<String, Map<String, String>> translations = {};

  static Future<void> loadTranslations() async {
    translations = {
      'en_US': await _loadTranslationFile('assets/lang/en_Us.json'),
      'de_DE': await _loadTranslationFile('assets/lang/de_DE.json'),
    };
  }

  static Future<Map<String, String>> _loadTranslationFile(String path) async {
    String jsonString = await rootBundle.loadString(path);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  @override
  Map<String, Map<String, String>> get keys => translations;
}
