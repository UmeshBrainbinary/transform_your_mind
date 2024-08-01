import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
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
  setBackSounds() async {
    soundMute = false;
    try {
      await setUrl(soundList[1]["audio"]);
      await play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
    update();
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
    {
      "title": "Rk",
      "audio":
          "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"
    },
    {
      "title": "Mk",
      "audio":
          "https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"
    },
    {
      "title": "Fk",
      "audio":
          "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"
    },
    {
      "title": "Gk",
      "audio":
          "https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"
    },
    {
      "title": "Yk",
      "audio":
          "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"
    },
  ];

  List<String> themeList = [
    "https://i.pinimg.com/736x/45/ce/29/45ce2986d79fc7cd05014bd522a88834.jpg",
    "https://images.unsplash.com/photo-1547483238-2cbf881a559f?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXw1MDI3OTF8fGVufDB8fHx8fA%3D%3D",
    "https://w0.peakpx.com/wallpaper/233/89/HD-wallpaper-blue-sky-beautiful-clouds-life-love-nature-stars-sunset.jpg",
    "https://1.bp.blogspot.com/-4iulinQP-Bo/YOBwMdwSlII/AAAAAAAAQmk/wfv9P_KGa7MKzC-7MEc7TGHhqD6jg0mtgCLcBGAsYHQ/s0/V1-SIMPLE-LANDSCAPE-HD.png"
  ];

  ///___________________ audio service Common File ________-
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Rx<Duration?> _position = Duration.zero.obs;
  final Rx<Duration?> _duration = Duration.zero.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isVisible = false.obs;

  AudioPlayer get audioPlayer => _audioPlayer;

  Rx<Duration?> get positionStream => _position;

  Rx<Duration?> get durationStream => _duration;

  RxBool get isPlaying => _isPlaying;

  RxBool get isVisible => _isVisible;

  Future<void> setUrl(String url,
      {String? name,
      String? expertName,
      String? description,
      String? img}) async {
    update();

    await _audioPlayer.setUrl(url);
  }

  Future<void> play() async {
    _isVisible.value = true;
    await _audioPlayer.play();
    update();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }
}
