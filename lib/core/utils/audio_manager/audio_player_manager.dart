import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:transform_your_mind/widgets/app_enums.dart';


enum AudioPlayPauseEvent {
  playBgAudio,
  pauseBgAudio,
  playMeditationAudio,
  pauseMeditationAudio
}

enum AudioSpeed {
  normal(1.0, "1x"),
  normalPlus(1.5, "1.5x"),
  doubleSpeed(2.0, "2x"),
  normalHalf(0.5, "0.5x");

  final double speed;
  final String speedValue;

  const AudioSpeed(this.speed, this.speedValue);

  static List<AudioSpeed> getAudioSpeedList() {
    return [
      AudioSpeed.normal,
      AudioSpeed.normalPlus,
      AudioSpeed.doubleSpeed,
      AudioSpeed.normalHalf,
    ];
  }
}

class AudioPlayerManager {
  /// [audioPlayer] is a audio player for the meditation or other internal audio
  AudioPlayer audioPlayer = AudioPlayer();

  /// [bgAudioPlayer] is a audio player for the background theme audio
  AudioPlayer bgAudioPlayer = AudioPlayer();

  /// [isMeditationAudioPlaying] is used to handle the play/pause of the mini audio player,
  /// main meditation audio player screen at the same time
  final ValueNotifier<bool> isMeditationAudioPlaying = ValueNotifier(false);

  /// [isMiniAudioPlayerHovering] will help to know when to show the mini player over the bottom tab bar
  bool isMiniAudioPlayerHovering = false;

  /// [isBackgroundAudioPlaying] will help to know whenever you pause or play background audio from choose_theme page
  bool isBackgroundAudioPlaying = true;

  /// [isMiniAudioPlayerInPlayingState] will be used to handle the play pause event of the mini audio player
  ValueNotifier<bool> isMiniAudioPlayerInPlayingState = ValueNotifier(false);

  /// [isBgAudioLoadedInitially] is used to check whether the BG audio is already loaded when the app is launched
  /// so that it does not re-initialize and won't consume memory
  bool isBgAudioLoadedInitially = false;

  /// [currentAudioPlayingId] is the Id of the current audio being played
  String? currentAudioPlayingId;

  /// Audio data
 // RestoreMediaData? meditationAudioData;

  /// This will bed used to notify the notification about the currently playing
  /// meditation audio duration to show in it
  Duration currentlyPlayingMeditationAudioDuration = const Duration();

  /// to check whether played initially
  bool isInitiallyLoadedFromMiniPlayer = false;

  /// setting up the current audio Id for checking purpose
  void setCurrentIdOfAudio({required String currentId}) {
    currentAudioPlayingId = currentId;
  }

  /// This will provide the of the audio that is currently being played
  // Future<void> setMeditationAudioData(
  //     {required RestoreMediaData meditationAudioDataValue}) async {
  //   meditationAudioData = meditationAudioDataValue;
  // }

  /// This will used to set the timer for playing the BG audio outside the application
  final ValueNotifier<SelectMinutes> selectedMinutesToPlayOutsideApp =
      ValueNotifier<SelectMinutes>(SelectMinutes.min_0);

  /// This will handle the playing and pausing of both the audio player
  Future<void> playPauseEventHandler(
      {required AudioPlayPauseEvent audioPlayPauseEvent}) async {
    switch (audioPlayPauseEvent) {
      case AudioPlayPauseEvent.playBgAudio:
        if (kReleaseMode) bgAudioPlayer.stop();
       // if (kReleaseMode) bgAudioPlayer.play();
        break;
      case AudioPlayPauseEvent.pauseBgAudio:
        bgAudioPlayer.pause();
        break;
      case AudioPlayPauseEvent.playMeditationAudio:
        if (kReleaseMode) audioPlayer.play();
        break;
      case AudioPlayPauseEvent.pauseMeditationAudio:
        audioPlayer.pause();
        break;
      default:
        break;
    }
  }

  /// Stop event of both the players
  void stopBgAudio() {
    bgAudioPlayer.stop();
  }

  void stopMeditationAudio() {
    audioPlayer.stop();
  }

  /// Volume setter for both the audio player
  void volumeForBgAudio({required double volume}) {
    bgAudioPlayer.setVolume(volume);
  }

  void volumeForMeditationAudio({required double volume}) {
    audioPlayer.setVolume(volume);
  }

  /// Seek handler for the meditation audio
  void seekForMeditationAudio({required Duration position, int? index}) {
    audioPlayer.seek(position, index: index);
  }

  /// Change audio speed [AudioSpeed.speed]
  void setAudioSpeed(AudioSpeed speed) {
    audioPlayer.setSpeed(speed.speed);
  }
}
