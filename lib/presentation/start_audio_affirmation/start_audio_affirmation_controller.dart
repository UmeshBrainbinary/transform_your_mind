import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';

class StartAudioAffirmationController extends GetxController{
  int selectedSpeedIndex = 0; // Initialize with -1 or any default value
  final AudioPlayer player = AudioPlayer();

  List<bool> storyCompleted = [];
  RxBool setSpeed = false.obs;

  List<String> speedList = ["Auto", "20 sec", "15 sec", "10 sec", "5 sec"];
  List soundList = [
    {"title": "None","audio":""},
    {"title": "Rk","audio":ImageConstant.bgAudio1},
    {"title": "Mk","audio":ImageConstant.bgAudio2},
    // {"title": "Rk","audio":ImageConstant.audioPath1},
    // {"title": "Mk","audio": ImageConstant.audioPath2},
    // {"title": "Fk","audio":ImageConstant.audioPath3},
    // {"title": "Gk","audio": ImageConstant.audioPath4},
    // {"title": "Yk","audio":ImageConstant.audioPath5},
  ];
  // List soundList = [
  //   {"title": "None","audio":""},
  //   {"title": "Rk","audio":"https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"},
  //   {"title": "Mk","audio":"https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"},
  //   {"title": "Fk","audio":"https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"},
  //   {"title": "Gk","audio":"https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"},
  //   {"title": "Yk","audio":"https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"},
  //
  // ];
  List audios =[
   ImageConstant.audioPath1,
   ImageConstant.audioPath2,
   ImageConstant.audioPath3,
   ImageConstant.audioPath4,
   ImageConstant.audioPath5,
  ];
  int currentDayIndex = DateTime.now().weekday % 7;

  List<String> themeList = [
    "https://i.pinimg.com/736x/45/ce/29/45ce2986d79fc7cd05014bd522a88834.jpg",
    "https://images.unsplash.com/photo-1547483238-2cbf881a559f?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXw1MDI3OTF8fGVufDB8fHx8fA%3D%3D",
    "https://w0.peakpx.com/wallpaper/233/89/HD-wallpaper-blue-sky-beautiful-clouds-life-love-nature-stars-sunset.jpg",
    "https://1.bp.blogspot.com/-4iulinQP-Bo/YOBwMdwSlII/AAAAAAAAQmk/wfv9P_KGa7MKzC-7MEc7TGHhqD6jg0mtgCLcBGAsYHQ/s0/V1-SIMPLE-LANDSCAPE-HD.png"
  ];
  bool soundMute = false;
  bool play = false;

  ValueNotifier<double> slideValue = ValueNotifier(40.0);

  AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  void setSelectedSpeedIndex(int index) {
    selectedSpeedIndex = index;
    update();
  }
  RxBool loader = false.obs;

  @override
  void onInit() {

    selectedSpeedIndex = 0;
    super.onInit();
  }

  void seekForMeditationAudio({required Duration position, int? index}) {
    _audioPlayer.seek(position, index: index);
  }
}