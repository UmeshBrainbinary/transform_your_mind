import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/affirmation_model.dart';
import 'package:transform_your_mind/model_class/bookmarked_model.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/model_class/recently_model.dart';
import 'package:transform_your_mind/model_class/today_affirmation.dart';
import 'package:transform_your_mind/model_class/today_gratitude.dart';

class HomeController extends GetxController {
  //_______________________________________  Variables __________________________

  RxList<AudioData> audioData = <AudioData>[].obs;
  GetPodsModel getPodsModel = GetPodsModel();
  RxBool loader = false.obs;
  List<String> bookmarkedList = [];

  DateTime todayDate = DateTime.now();
  List<bool> affirmationCheckList = [];
  List<bool> gratitudeCheckList = [];
  List<Map<String, dynamic>> quickAccessList = [
    {"title": "motivational", "icon": ImageConstant.meditationIconQuick,"color": ColorConstant.colorF7E2CD},
    {"title": "transformPods", "icon": ImageConstant.podIconQuick,"color": ColorConstant.colorEDC9ED},
    {"title": "gratitudeJournal", "icon": ImageConstant.journalIconQuick,"color": ColorConstant.colorC8CDF7},
    {"title": "positiveMoments", "icon": ImageConstant.sleepIconQuick,"color": ColorConstant.colorF9CDCE},
    {"title": "affirmation", "icon": ImageConstant.homeAffirmation,"color": ColorConstant.colorFFDDAA},
    {"title": "breathingExerciseTitle", "icon": ImageConstant.breathing,"color": ColorConstant.colorD5F8A9},
  ];

  //_______________________________________  Model Class _______________________
  GetUserModel getUserModel = GetUserModel();
  BookmarkedModel bookmarkedModel = BookmarkedModel();
  AffirmationModel affirmationModel = AffirmationModel();
  RecentlyModel recentlyModel = RecentlyModel();
  TodayAffirmation todayAffirmation = TodayAffirmation();
  List<TodayAData>? todayAList = [];
  List<TodayGData>? todayGList = [];
  TodayGratitude todayGratitude = TodayGratitude();

  //_______________________________________  init Methods  _____________________

  @override
  void onInit() {
    getMotivationalMessage();
    super.onInit();
  }

  //_______________________________________  Api Call Functions  __________________________

  getPodApi() async {
    loader.value = true;
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.Request(
          'GET',
          Uri.parse('${EndPoints.getPod}?isRecommended=true'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        loader.value = false;

        final responseBody = await response.stream.bytesToString();

        getPodsModel = getPodsModelFromJson(responseBody);
        audioData.value = getPodsModel.data ?? [];
        debugPrint("filter Data $audioData");
        update(["home"]);
      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);
        update(["home"]);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    loader.value = false;

    update();
  }

  getUSer() async {
    bookmarkedList = [];
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getUser}${PrefService.getString(PrefKey.userId)}",
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getUserModel = getUserModelFromJson(responseBody);
        for (int i = 0; i < getUserModel.data!.bookmarkedPods!.length; i++) {
          bookmarkedList.add(getUserModel.data!.bookmarkedPods![i].toString());
        }
        await PrefService.setValue(
            PrefKey.userImage, getUserModel.data?.userProfile ?? "");

        update(["home"]);
        debugPrint("Bookmark List $bookmarkedList");
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    update(["home"]);
  }

  getBookMarkedList() async {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}get-pod?isBookmarked=true&userId=${PrefService.getString(PrefKey.userId)}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      bookmarkedModel = bookmarkedModelFromJson(responseBody);

      update(["home"]);
    } else {
      debugPrint(response.reasonPhrase);
    }
    update(["home"]);
  }

  getRecentlyList() async {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.getPod}?isRecentlyPlayed=true&userId=${PrefService.getString(PrefKey.userId)}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      recentlyModel = recentlyModelFromJson(responseBody);

      update(["home"]);
    } else {
      debugPrint(response.reasonPhrase);
    }
    update(["home"]);
  }

  getTodayAffirmation() async {
    affirmationCheckList = [];
    update(["home"]);

    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.todayAffirmation}${PrefService.getString(PrefKey.userId)}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      todayAffirmation = todayAffirmationFromJson(responseBody);
      todayAList = todayAffirmation.data;
      if (todayAffirmation.data != null) {
        List.generate(
          todayAffirmation.data!.length,
          (index) => affirmationCheckList.add(false),
        );
      }

      update(["home"]);
    } else {
      debugPrint(response.reasonPhrase);
    }
    update(["home"]);
  }

  CommonModel commonModel = CommonModel();

  getMotivationalMessage() async {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.randomFeedback}${PrefService.getString(PrefKey.userId)}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      //motivationalMessage = commonModel.message??"";
      update(["home"]);
    } else {
      debugPrint(response.reasonPhrase);
    }
    update(["home"]);
  }

  getTodayGratitude() async {

    gratitudeCheckList = [];
    update(["home"]);

    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.todayGratitude}${PrefService.getString(PrefKey.userId)}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loader.value = false;

      final responseBody = await response.stream.bytesToString();
      todayGratitude = todayGratitudeFromJson(responseBody);
      todayGList = todayGratitude.data;
      if (todayGratitude.data != null) {
        List.generate(
          todayGratitude.data!.length,
          (index) => gratitudeCheckList.add(false),
        );
      }

      update(["home"]);
      loader.value = false;
    } else {
      loader.value = false;

      debugPrint(response.reasonPhrase);
    }
    loader.value = false;

    update(["home"]);
  }

  updateTodayData(id, url) async {
    loader.value=true;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request =
        http.Request('POST', Uri.parse('${EndPoints.baseUrl}$url?id=$id'));
    request.body = json.encode({"isCompleted": true,"created_by":PrefService.getString(PrefKey.userId)});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      loader.value=false;

      final responseBody = await response.stream.bytesToString();

      Get.back();
    } else {
      loader.value=false;

      final responseBody = await response.stream.bytesToString();
    }
    loader.value=false;

  }
}
