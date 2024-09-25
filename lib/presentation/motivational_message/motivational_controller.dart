import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/motivational_model.dart';

class MotivationalController extends GetxController {
  List<MotivationalData> motivationalList = [];

  RxBool loader = false.obs;
  RxBool allFavList = false.obs;
  bool soundMute = false;
  Timer? timer;
  int selectedSpeedIndex = 0;
  List<bool> like = [];
  ValueNotifier<double> slideValue = ValueNotifier(40.0);
  int likeIndex = 0;

  void setSelectedSpeedIndex(int index) {
    selectedSpeedIndex = index;
    update();
  }

  @override
  void onInit() {
  List.generate(1,(index) => like.add(false),);
    checkInternet();

    super.onInit();
  }


  checkInternet() async {
    if (await isConnected()) {
      getMotivational();
    } else {
      showSnackBarError(Get.context!, "noInternet".tr);
    }
  }

  MotivationalModel motivationalModel = MotivationalModel();

  getMotivational() async {
    loader.value = true;
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}get-message?userId=${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loader.value = false;
      likeIndex = 0;
      like = [];
      motivationalList = [];
      motivationalModel = MotivationalModel();
      final responseBody = await response.stream.bytesToString();
      motivationalModel = motivationalModelFromJson(responseBody);
      motivationalList = motivationalModel.data!;
      for (int i = 0; i < motivationalList.length; i++) {
        if (motivationalList[i].userLiked!) {
          like.add(true);
        } else {
          like.add(false);
        }
      }
      update(["motivational"]);
    } else {
      loader.value = false;

      debugPrint(response.reasonPhrase);
    }
    loader.value = false;
  }

  getLikeList(BuildContext context) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              '${EndPoints.baseUrl}get-message?userId=${PrefService.getString(PrefKey.userId)}&isLiked=true'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        likeIndex = 0;
        like = [];
        motivationalList = [];
        motivationalModel = MotivationalModel();
        final responseBody = await response.stream.bytesToString();
        motivationalModel = motivationalModelFromJson(responseBody);
        motivationalList = motivationalModel.data!;
        if(motivationalList.isNotEmpty){
          for (int i = 0; i < motivationalList.length; i++) {
            if (motivationalList[i].userLiked!) {
              like.add(true);
            } else {
              like.add(false);
            }
          }
        }else{
          showSnackBarSuccess(context, "Please add your favourite motivational message");
          await getMotivational();
          allFavList = false.obs;
        }

        update(["motivational"]);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List soundList = [
    {"title": "None", "audio": ""},
    {"title": "Rk","audio":ImageConstant.bgAudio1},
    {"title": "Mk","audio":ImageConstant.bgAudio2},

  ];

  List<String> themeList = [
    ImageConstant.image1,
    ImageConstant.image2,
    ImageConstant.image3,
    ImageConstant.image4,
    ImageConstant.image5,
    ImageConstant.image6,
    ImageConstant.image7,
  ];

  ///___________________ audio service Common File ________-
   AudioPlayer _audioPlayer = AudioPlayer();
   Rx<Duration?> _position = Duration.zero.obs;
   Rx<Duration?> _duration = Duration.zero.obs;
   RxBool _isPlaying = false.obs;
   RxBool _isVisible = false.obs;

  AudioPlayer get audioPlayer => _audioPlayer;

  Rx<Duration?> get positionStream => _position;

  Rx<Duration?> get durationStream => _duration;

  RxBool get isPlaying => _isPlaying;

  RxBool get isVisible => _isVisible;



  Future<void> play() async {
    _isVisible.value = true;
    await _audioPlayer.play();
    update();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    update();

  }
}
