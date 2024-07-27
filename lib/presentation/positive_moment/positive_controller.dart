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
import 'package:transform_your_mind/model_class/positive_model.dart';

class PositiveController extends GetxController {
  RxList positiveMomentList = [].obs;
  List? filteredBookmarks;

  @override
  void onInit() {
    selectedSpeedIndex = 0;
    _audioPlayer.positionStream.listen((event) {
      _position.value = event;
    });
    _audioPlayer.durationStream.listen((event) {
      _duration.value = event;
    });
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying.value = state.playing;
    });
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
      }
    });
    super.onInit();
  }

  checkInternet() async {
    if (await isConnected()) {
      getPositiveMoments();
    } else {
      showSnackBarError(Get.context!, "noInternet".tr);
    }
  }

  var isMenuVisible = false.obs;
  var menuPosition = const RelativeRect.fromLTRB(0, 0, 0, 0).obs;

  void showMenu(RelativeRect position) {
    menuPosition.value = position;
    isMenuVisible.value = true;
  }

  void hideMenu() {
    isMenuVisible.value = false;
  }

  var conTap = "".obs;

  void onTapCon(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon1(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon2(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon3(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon4(String value) {
    conTap.value = value;
    update();
  }

  Rx<bool> loader = false.obs;
  PositiveModel positiveModel = PositiveModel();

  deletePositiveMoment(id, BuildContext context) async {
    loader.value = true;

    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
          'DELETE', Uri.parse('${EndPoints.deletePositiveMoment}$id'));
      debugPrint('id ============= $id');
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        loader.value = false;
       showSnackBarSuccess(context, "positiveDeleted".tr);
        update(['moment']);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    update(['moment']);
  }

  filterMoment(weeks) async {
    positiveMomentList = [].obs;
    positiveModel = PositiveModel();
    loader.value = true;

    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getMoment}created_by=${PrefService.getString(PrefKey.userId)}?$weeks=true",
        ),
      );
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        loader.value = false;
        positiveModel = positiveModelFromJson(responseBody);
        if (positiveModel.data != null) {
          for (int i = 0; i < positiveModel.data!.length; i++) {
            positiveMomentList.add({
              "title": positiveModel.data?[i].title ?? '',
              "img": positiveModel.data?[i].image ?? '',
              "des": positiveModel.data?[i].description ?? '',
              'id': positiveModel.data?[i].id ?? "",
            });
          }
          filteredBookmarks = positiveMomentList;
        }
         update(["update"]);
      } else {
        loader.value = false;
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    loader.value = false;
    update(["update"]);

  }

  getPositiveMoments() async {
    positiveMomentList = [].obs;
    positiveModel = PositiveModel();
    loader.value = true;

    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getMoment}?created_by=${PrefService.getString(PrefKey.userId)}",
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        loader.value = false;

        positiveModel = positiveModelFromJson(responseBody);
        if (positiveModel.data != null) {
          for (int i = 0; i < positiveModel.data!.length; i++) {
            positiveMomentList.add({
              "title": positiveModel.data?[i].title ?? '',
              "img": positiveModel.data?[i].image ?? '',
              "des": positiveModel.data?[i].description ?? '',
              'id': positiveModel.data?[i].id ?? "",
            });
          }
          filteredBookmarks = positiveMomentList;
        }

        update(['moment']);
        update(["update"]);

      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    update(['moment']);
    update(["update"]);

  }
  int selectedSpeedIndex = 0; // Initialize with -1 or any default value

  List<bool> storyCompleted = [];
  RxBool setSpeed = false.obs;


  List<String> speedList = ["Auto", "20 sec", "15 sec", "10 sec", "5 sec"];
  List soundList = [
    {"title": "None","audio":""},
    {"title": "Rk","audio":"https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"},
    {"title": "Mk","audio":"https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"},
    {"title": "Fk","audio":"https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"},
    {"title": "Gk","audio":"https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"},
    {"title": "Yk","audio":"https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"},

  ];
  int currentDayIndex = DateTime.now().weekday % 7;

  List<String> themeList = [
    "https://i.pinimg.com/736x/45/ce/29/45ce2986d79fc7cd05014bd522a88834.jpg",
    "https://images.unsplash.com/photo-1547483238-2cbf881a559f?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXw1MDI3OTF8fGVufDB8fHx8fA%3D%3D",
    "https://w0.peakpx.com/wallpaper/233/89/HD-wallpaper-blue-sky-beautiful-clouds-life-love-nature-stars-sunset.jpg",
    "https://1.bp.blogspot.com/-4iulinQP-Bo/YOBwMdwSlII/AAAAAAAAQmk/wfv9P_KGa7MKzC-7MEc7TGHhqD6jg0mtgCLcBGAsYHQ/s0/V1-SIMPLE-LANDSCAPE-HD.png"
  ];
  bool soundMute = false;
  Timer? timer;
  ValueNotifier<double> slideValue = ValueNotifier(40.0);



  void setSelectedSpeedIndex(int index) {
    selectedSpeedIndex = index;
    update();
  }


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
