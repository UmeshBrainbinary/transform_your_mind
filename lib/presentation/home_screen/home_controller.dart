import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/affirmation_model.dart';
import 'package:transform_your_mind/model_class/bookmarked_model.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/get_personal_model.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/model_class/recently_model.dart';
import 'package:transform_your_mind/model_class/self_hypnotic_model.dart';
import 'package:transform_your_mind/model_class/today_gratitude.dart';

class HomeController extends GetxController {
  //_______________________________________  Variables __________________________

  RxList<AudioData> audioData = <AudioData>[].obs;
  RxList<SelfHypnoticData> audioDataSelfHypnotic = <SelfHypnoticData>[].obs;
  GetPodsModel getPodsModel = GetPodsModel();
  SelfHypnoticModel selfHypnoticModel = SelfHypnoticModel();
  RxBool loader = false.obs;

  DateTime todayDate = DateTime.now();
  List<bool> affirmationCheckList = [];
  List<bool> gratitudeCheckList = [];
  List<Map<String, dynamic>> quickAccessList = [
    {"title": "motivationalQ", "icon": ImageConstant.meditationIconQuick,"color": ColorConstant.colorF7E2CD},
    {"title": "transformAudiosQ", "icon": ImageConstant.podIconQuick,"color": ColorConstant.colorEDC9ED},
    {"title": "gratitudeJournalQ", "icon": ImageConstant.journalIconQuick,"color": ColorConstant.colorC8CDF7},
    {"title": "positiveMomentsQ", "icon": ImageConstant.sleepIconQuick,"color": ColorConstant.colorF9CDCE},
    {"title": "affirmationeQ", "icon": ImageConstant.homeAffirmation,"color": ColorConstant.colorFFDDAA},
    {"title": "breathingExerciseTitleQ", "icon": ImageConstant.breathing,"color": ColorConstant.colorD5F8A9},
  ];

  //_______________________________________  Model Class _______________________
  GetUserModel getUserModel = GetUserModel();
  BookmarkedModel bookmarkedModel = BookmarkedModel();
  GetPersonalDataModel getPersonalDataModel = GetPersonalDataModel();
  AffirmationModel affirmationModel = AffirmationModel();
  RecentlyModel recentlyModel = RecentlyModel();
  AffirmationModel todayAffirmation = AffirmationModel();
  List<AffirmationData>? todayAList = [];
  List<TodayGData>? todayGList = [];

  final AudioPlayer _audioPlayer = AudioPlayer();

  List audioListDuration = [];
  List audioListDurationSelf = [];
  List audioListRecommendations = [];

  getPodApi() async {
    loader.value = true;
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.Request(
          'GET',
          Uri.parse(
              '${EndPoints.getPod}?userId=${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        loader.value = false;

        final responseBody = await response.stream.bytesToString();

        getPodsModel = getPodsModelFromJson(responseBody);
        audioData.value = getPodsModel.data ?? [];
        for(int i = 0;i<audioData.length;i++){
          await _audioPlayer.setUrl(audioData[i].audioFile!);
          final duration = await _audioPlayer.load();
          audioListDuration.add(duration);
        }

        debugPrint("filter Data $audioData");



      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);


      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    loader.value = false;

    update();
    update(["home"]);

  }
  getSelfHypnoticApi() async {
    loader.value = true;
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      //userId=${PrefService.getString(PrefKey.userId)}&
      var request = http.Request(
          'GET',
          Uri.parse(
              '${EndPoints.getPod}?selfHypnotic=true&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        loader.value = false;

        final responseBody = await response.stream.bytesToString();


        selfHypnoticModel = selfHypnoticModelFromJson(responseBody);
        audioDataSelfHypnotic.value = selfHypnoticModel.data ?? [];
        for(int i = 0;i<audioDataSelfHypnotic.length;i++){
          await _audioPlayer.setUrl(audioDataSelfHypnotic[i].audioFile!);
          final duration = await _audioPlayer.load();
          audioListDurationSelf.add(duration);
        }

        debugPrint("filter Data $audioData");



      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);


      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    loader.value = false;

    update();
    update(["home"]);

  }

  getUSer() async {
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

        await PrefService.setValue(
            PrefKey.userImage, getUserModel.data?.userProfile ?? "");
        await PrefService.setValue(
            PrefKey.isFreeUser, getUserModel.data?.isFreeVersion ?? false);
        await PrefService.setValue(
            PrefKey.isSubscribed, getUserModel.data?.isSubscribed ?? false);
        await PrefService.setValue(
            PrefKey.subId, getUserModel.data?.subscriptionId ?? '');
        update(["home"]);
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
    loader.value = true;

    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}get-pod?isBookmarked=true&userId=${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loader.value = false;

      final responseBody = await response.stream.bytesToString();
      bookmarkedModel = bookmarkedModelFromJson(responseBody);
      if((bookmarkedModel.data??[]).isNotEmpty){
        for(int i = 0;i<bookmarkedModel.data!.length;i++){
          try {
            await _audioPlayer.setUrl(bookmarkedModel.data![i].audioFile!);
            final duration = await _audioPlayer.load();
            audioListDuration.add(duration);
          }catch (e) {
    print("Failed to load audio: $e");
    // Handle the error, e.g., show a message to the user.
    }

        }
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

  getRecentlyList() async {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.getPod}?isRecentlyPlayed=true&userId=${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

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
  getPersonalData() async {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.getPersonalAudio}${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      getPersonalDataModel = getPersonalDataModelFromJson(responseBody);

      for(int i = 0;i<getPersonalDataModel.data!.length;i++){
        try {
          await _audioPlayer.setUrl(getPersonalDataModel.data![i].audioFile!);
        final duration = await _audioPlayer.load();
        audioListRecommendations.add(duration);
        }catch (e){
          print(e);
        }
      }
      update(["home"]);
    } else {
      debugPrint(response.reasonPhrase);
    }
    debugPrint("getPersonalDataModel get personal data $getPersonalDataModel");
    update(["home"]);
  }
bool isAudio = false;
  getTodayAffirmation() async {
    affirmationCheckList = [];
    update(["home"]);

    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.todayAffirmation}${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      todayAffirmation = affirmationModelFromJson(responseBody);
      todayAList = todayAffirmation.data;
      if (todayAffirmation.data != null) {
        List.generate(
          todayAffirmation.data!.length,
          (index) => affirmationCheckList.add(false),
        );
      }

      todayAList!.forEach((e){
        if(e.audioFile != null)
          {
            isAudio =true;

          }
      });



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
            '${EndPoints.randomFeedback}${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

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


}
