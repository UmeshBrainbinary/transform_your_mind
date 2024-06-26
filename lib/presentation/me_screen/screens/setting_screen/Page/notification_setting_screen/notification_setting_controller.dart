import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/alarm_model.dart';

class NotificationSettingController extends GetxController {
  AlarmModel alarmModel = AlarmModel();
  RxBool loader = false.obs;

  getAffirmationAlarm() async {
    alarmModel = AlarmModel();
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}get-alarm?created_by=${PrefService.getString(PrefKey.userId)}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      alarmModel = alarmModelFromJson(responseBody);
      update(["update"]);
    } else {
      debugPrint(response.reasonPhrase);
    }
    update(["update"]);
  }

  deleteAffirmation(id) async {
    loader.value = true;
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'DELETE', Uri.parse('${EndPoints.baseUrl}delete-alarm?id=$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loader.value = false;

      update(["update"]);
    } else {
      loader.value = false;

      debugPrint(response.reasonPhrase);
    }
    loader.value = false;

    update(["update"]);
  }

  editAffirmation(
      {BuildContext? context,
      String? id,
      int? hours,
      int? minutes,
      int? seconds,
      String? time}) async {
    loader.value = true;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'POST', Uri.parse('${EndPoints.baseUrl}update-alarm?id=$id'));
    request.body = json.encode(
        {"hours": hours, "minutes": minutes, "seconds": seconds, "time": time});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loader.value = false;

      showSnackBarSuccess(context!, "AlarmSuccessfully".tr);
      Get.back();
      update(["update"]);
    } else {
      loader.value = false;

      debugPrint(response.reasonPhrase);
    }
    loader.value = false;

    update(["update"]);
  }
}

