import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transform_your_mind/presentation/home_screen/AlarmNotification.dart';

class AffirmationController extends GetxController{
  late List<AlarmSettings> alarms;

  static StreamSubscription<AlarmSettings>? subscription;
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
  void seekForMeditationAudio({required Duration position, int? index}) {
    _audioPlayer.seek(position, index: index);
  }
  Future<void> play() async {
    _isVisible.value = true;
    await _audioPlayer.play();
    update();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  void onInit() {
    checkAndroidNotificationPermission();
    checkAndroidScheduleExactAlarmPermission();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
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
        _onAudioFinished();
      }
    });
    super.onInit();
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    Get.to( AlarmNotificationScreen(alarmSettings: alarmSettings));
    loadAlarms();
  }
  void loadAlarms() {
    alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    update();
  }
  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }
  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (kDebugMode) {
      print('Schedule exact alarm permission: $status.');
    }
    if (status.isDenied) {
      if (kDebugMode) {
        print('Requesting schedule exact alarm permission...');
      }
      final res = await Permission.scheduleExactAlarm.request();
      if (kDebugMode) {
        print(
            'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
      }
    }
  }
  void _onAudioFinished() async {
    await _audioPlayer.seek(Duration.zero);
    await pause();
    isPlaying.value = false;
    update();
  }
  String? currentUrl;


  Future<void> setUrl(String url,
      {String? name,
        String? expertName,
        String? description,
        String? img}) async {


    if (_isPlaying.value) {
      // Option 1: Do nothing if the same URL is playing
      if (currentUrl == url) return;
      await _audioPlayer.stop();
    }
    if (currentUrl == url) return;
    currentUrl = url;
    await _audioPlayer.setAsset(url);
    update();

  }
}