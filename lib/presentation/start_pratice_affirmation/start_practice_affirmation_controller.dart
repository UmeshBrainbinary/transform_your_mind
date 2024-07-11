import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class StartPracticeAffirmationController extends GetxController {
  int selectedSpeedIndex = 0; // Initialize with -1 or any default value
  final AudioPlayer player = AudioPlayer();

  List<bool> storyCompleted = [];
  RxBool setSpeed = false.obs;
  List<String> quotes = [
    '“Calm mind brings inner strength and self-confidence, so that’s very important for good health”',
    '“The only way to achieve the impossible is to believe it is possible.”',
    '“ieve the impossible is to believe it is possible.”',
    '“impossible is to believe it is possible.”',
    '“Success is not how high you have climbed, but how you make a positive difference to the world.”',
  ];

  List<String> speedList = ["Auto", "20 sec", "15 sec", "10 sec", "5 sec"];
  List soundList = [
    {"title": "Rk","audio":"https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/menu.ogg"},
    {"title": "Mk","audio":"https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/win.ogg"},
    {"title": "Fk","audio":"https://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/thrust.ogg"},
    {"title": "Gk","audio":"https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"},
    {"title": "Yk","audio":"https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/win.ogg"},

  ];  List<String> weekList = ["M", "T", "W", "T", "F", "S", "S"];
  int currentDayIndex = DateTime.now().weekday % 7;

  List<String> themeList = [
    "https://transformyourmind.s3.eu-north-1.amazonaws.com/1718789963955-3d connections polygonal background with connecting lines and dots.png",
    "https://transformyourmind.s3.eu-north-1.amazonaws.com/1718865288873-3d connections polygonal background with connecting lines and dots.png",
    "https://transformyourmind.s3.eu-north-1.amazonaws.com/1719980269394-support-7965543_1280.webp",
    "https://transformyourmind.s3.eu-north-1.amazonaws.com/1719464225736-Rectangle 5781.png"
  ];
  bool soundMute = false;
  late Timer timer;
  ValueNotifier<double> slideValue = ValueNotifier(40.0);

  AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  void setSelectedSpeedIndex(int index) {
    selectedSpeedIndex = index;
    update();
  }

  @override
  void onInit() {
    selectedSpeedIndex = 0;
    super.onInit();
  }

  void seekForMeditationAudio({required Duration position, int? index}) {
    _audioPlayer.seek(position, index: index);
  }
}
