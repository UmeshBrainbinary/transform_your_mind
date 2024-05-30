import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/utils/audio_manager/audio_player_manager.dart';
import 'package:transform_your_mind/core/utils/audio_manager/seek_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/duration_formatter.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';


class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> with TickerProviderStateMixin{


  final AudioPlayerManager _audioPlayerManager = AudioPlayerManager();

  final _player = AudioPlayer();

  List<AudioSpeed> audioSpeedList = AudioSpeed.getAudioSpeedList();
  int currentAudioSpeedIndex = 0;
  Duration position = Duration.zero;
  Duration seekbarDuration = Duration.zero;
  Duration _totalAudioDuration = const Duration();
  Timer? volTimer;
  final ValueNotifier<bool> _isVolShowing = ValueNotifier(false);
  ValueNotifier<bool> isActivityApiCalled = ValueNotifier(false);
  bool _isSeekbarSliding = false;
  final ValueNotifier<Duration> _updatedRealtimeAudioDuration = ValueNotifier(const Duration(hours: 0, minutes: 0, seconds: 0));
  final ValueNotifier<bool> _isAudioLoading = ValueNotifier(false);
  late bool _localAudioLoaded;
  var time;
  int timeStart = 0;
  Random randomNumberGenerator = Random();
  late int randomNumberForSelectingLottie;
  double _opacityOfSpeedText = 0.0;
  Timer? _opacityOfSpeedTimer;
  final ValueNotifier<double> _slideValue = ValueNotifier(40.0);
  late final AnimationController _lottieBgController, _lottieController;



  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _lottieBgController = AnimationController(vsync: this);

    _setInitValues();

  }



  @override
  void dispose() {
    _lottieController.dispose();
    _lottieBgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        child: Stack(
          children: [

          /// background image
           Align(
             alignment: Alignment.bottomCenter,
             child:  ClipPath(
               clipper: BgSemiCircleClipPath(),
               child: Container(
                 height: Get.height * 0.78,
                 decoration: BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage(ImageConstant.bgImagePlaying),
                         fit: BoxFit.cover
                     )
                 ),
               ),
             ),
           ),

            /// app bar
            Column(
              children: [
                Dimens.d30.h.spaceHeight,
                CustomAppBar(
                  title: "nowPlaying".tr,
                  leading: GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: const Icon(Icons.close)),
                  action: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {

                        },
                        child: SvgPicture.asset(
                          height: 25.h,
                          ImageConstant.share,
                        ),
                      ),
                      Dimens.d10.h.spaceWidth,
                      GestureDetector(
                        onTap: () async {

                        },
                        child: SvgPicture.asset(
                          height: 25.h,
                          ImageConstant.bookmark,
                        ),
                      ),
                      Dimens.d20.h.spaceWidth,
                    ],
                  ),
                ),
              ],
            ),

            /// center widget
            Positioned(
              top: Dimens.d90,
              left: Dimens.d110,
              child: Lottie.asset(
                ImageConstant.lottieStarOcean,
                controller: _lottieBgController,
                //height: MediaQuery.of(context).size.height / 3,
                height: 160,
                width: 160,
                onLoaded: (composition) {
                  _lottieBgController
                    ..duration = composition.duration
                    ..repeat();
                },
              ),
            ),


             ///seekbar
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamBuilder<Duration?>(
                  stream: _audioPlayerManager.audioPlayer.durationStream,
                  builder: (context, snapshot) {
                    seekbarDuration = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration>(
                      stream: _audioPlayerManager
                          .audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final positionData =
                            snapshot.data ?? Duration.zero;
                        position = positionData;
                        if ((position) > seekbarDuration) {
                          position = seekbarDuration;
                        }
                        var bufferedPosition = positionData;
                        if (bufferedPosition > seekbarDuration) {
                          bufferedPosition = seekbarDuration;
                        }
                        return SeekBar(
                          duration: _totalAudioDuration,
                          position: _updatedRealtimeAudioDuration.value,
                          bufferedPosition: bufferedPosition,
                          onChanged: (newPosition) {
                            _isSeekbarSliding = true;
                            setState(() {});
                            _updatedRealtimeAudioDuration.value =
                                newPosition ?? const Duration();
                          },
                          onChangeEnd: (newPosition) {
                            _isSeekbarSliding = false;
                            setState(() {});

                              _audioPlayerManager
                                  .seekForMeditationAudio(
                                  position: newPosition ??
                                      const Duration());


                              if (_audioPlayerManager
                                  .audioPlayer.playing) {

                              }

                          },
                        );
                      },
                    );
                  },
                ),
                Dimens.d20.h.spaceHeight,

                ///player buttons
                ValueListenableBuilder(
                    valueListenable: _isAudioLoading,
                    builder:
                        (BuildContext context, value, Widget? child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!_isAudioLoading.value) {
                                  _volumeTapHandler();
                                }
                              },
                              child: SvgPicture.asset(
                                  ImageConstant.loudSpeaker,
                                  color: _isAudioLoading.value
                                      ? ColorConstant.grey
                                      : ColorConstant.white),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!_isAudioLoading.value) {
                                  _backwardTapHandler();
                                }
                                // if (_audioPlayerManager
                                //     .audioPlayer.playing) {
                                //   _audioNotificationServiceHandler
                                //       .handleAudioPlayerControllerForNotification();
                                // }
                              },
                              child: Image.asset(
                                ImageConstant.audio15second,
                                color: _isAudioLoading.value
                                    ? ColorConstant.grey
                                    : ColorConstant.white,
                                width: Dimens.d24,
                                height: Dimens.d24,
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            builder: (context, value, child) {
                              return Flexible(
                                fit: FlexFit.loose,
                                child: GestureDetector(
                                  onTap: () {

                                    _playPauseTapHandler();
                                  },
                                  child: Container(
                                    height: Dimens.d64.h,
                                    width: Dimens.d64.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                     color: ColorConstant.themeColor
                                    ),
                                    child: Padding(
                                      padding:
                                      EdgeInsets.all(Dimens.d17.h),
                                      child: ValueListenableBuilder(
                                        valueListenable:
                                        _audioPlayerManager
                                            .isMeditationAudioPlaying,
                                        builder: (BuildContext context,
                                            value, Widget? child) {
                                          return _isAudioLoading.value
                                              ? SizedBox(
                                            height: Dimens.d30.h,
                                            width: Dimens.d30.h,
                                            child:
                                            const CircularProgressIndicator(
                                              color:
                                              ColorConstant.white,
                                              strokeWidth: 2.0,
                                            ),
                                          )
                                              : AnimatedSwitcher(
                                            duration:
                                            const Duration(
                                                milliseconds:
                                                500),
                                            transitionBuilder: (child,
                                                animation) =>
                                                RotationTransition(
                                                  turns: child.key ==
                                                      const ValueKey(
                                                          'ic_pause')
                                                      ? Tween<double>(
                                                      begin: Dimens
                                                          .d1,
                                                      end: Dimens
                                                          .d0_5)
                                                      .animate(
                                                      animation)
                                                      : Tween<double>(
                                                      begin: Dimens
                                                          .d0_75,
                                                      end: Dimens
                                                          .d1)
                                                      .animate(
                                                      animation),
                                                  child:
                                                  ScaleTransition(
                                                      scale:
                                                      animation,
                                                      child:
                                                      child),
                                                ),
                                            child: _audioPlayerManager
                                                .isMeditationAudioPlaying
                                                .value
                                                ?

                                            SvgPicture.asset(
                                                ImageConstant.pause,
                                                key: const ValueKey(
                                                    'ic_pause')
                                            )

                                                : SvgPicture
                                                .asset(
                                              ImageConstant.play,
                                              // key: const ValueKey(
                                              //     'ic_play'),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            valueListenable: isActivityApiCalled,
                          ),


                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!_isAudioLoading.value) {
                                  _forwardTapHandler();
                                }

                              },
                              child: Image.asset(
                               ImageConstant.audio15second2,
                                color: _isAudioLoading.value
                                    ? ColorConstant.grey
                                    : ColorConstant.white,
                                width: Dimens.d24,
                                height: Dimens.d24,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: SizedBox(
                                          width: Dimens.d24,
                                          height: Dimens.d24,
                                          child: SvgPicture.asset(
                                            ImageConstant.playbackSpeed,
                                            width: Dimens.d20,
                                            height: Dimens.d20,
                                            color: _isAudioLoading.value
                                                ? ColorConstant.grey
                                                : ColorConstant.white,
                                          ),
                                        ),
                                        onTap: () {

                                          if (audioSpeedList.length - 1 ==
                                              currentAudioSpeedIndex) {
                                            currentAudioSpeedIndex = 0;
                                            _audioPlayerManager
                                                .setAudioSpeed(
                                                audioSpeedList[
                                                currentAudioSpeedIndex]);
                                          } else {
                                            currentAudioSpeedIndex++;
                                            _audioPlayerManager
                                                .setAudioSpeed(
                                                audioSpeedList[
                                                currentAudioSpeedIndex]);
                                          }

                                          setState(() {
                                            _opacityOfSpeedText = 1.0;
                                          });
                                          _opacityOfSpeedTimer?.cancel();
                                          _opacityOfSpeedTimer = Timer(
                                              const Duration(seconds: 5),
                                                  () {
                                                setState(() {
                                                  _opacityOfSpeedText =
                                                  0.0;
                                                });
                                              });
                                        },
                                      ),
                                      Positioned(
                                        top: -20,
                                        left: -5,
                                        right: -5,
                                        child: AnimatedOpacity(
                                          opacity: _opacityOfSpeedText,
                                          duration: const Duration(
                                              milliseconds: 500),
                                          child: AutoSizeText(
                                            audioSpeedList[
                                            currentAudioSpeedIndex]
                                                .speedValue,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            style: Style.montserratMedium(
                                              color: _isAudioLoading.value
                                                  ? ColorConstant.grey
                                                  : ColorConstant.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                /// end image time duration
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: Dimens.d140,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            ImageConstant.curveBottomImg
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.d20),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: Dimens.d35,
                                width: Dimens.d55,
                                child: Center(
                                  child: ValueListenableBuilder(
                                    valueListenable:
                                    _updatedRealtimeAudioDuration,
                                    builder: (BuildContext context, value,
                                        Widget? child) {
                                      return Text(
                                        _updatedRealtimeAudioDuration.value.durationFormatter,
                                        style: Style.montserratMedium(
                                          fontSize: Dimens.d14,
                                          color: ColorConstant.white
                                          ),
                                      );
                                    },
                                  ),
                                ),
                              ),


                              /// music animation
                              ValueListenableBuilder(
                                valueListenable: _audioPlayerManager.isMeditationAudioPlaying,
                                builder: (context, value, child) {
                                  value
                                      ? _lottieController.repeat()
                                      : _lottieController.stop();

                                  return Lottie.asset(
                                    ImageConstant.lottieAudio,
                                    controller: _lottieController,
                                    height: Dimens.d40,
                                    width: Dimens.d40,
                                    fit: BoxFit.fill,
                                    repeat: true,
                                    onLoaded: (composition) {
                                      _lottieController.duration = composition.duration;
                                      value
                                          ? _lottieController.repeat()
                                          : _lottieController.stop();
                                    },
                                  );
                                },
                              ),
                              //SvgPicture.asset(ImageConstant.musicBars),

                              SizedBox(
                                height: Dimens.d35,
                                width: Dimens.d55,
                                child: Center(
                                  child: ValueListenableBuilder(
                                    valueListenable:
                                    _updatedRealtimeAudioDuration,
                                    builder: (BuildContext context, value,
                                        Widget? child) {

                                      return Text(
                                        '${(_totalAudioDuration - _updatedRealtimeAudioDuration.value).durationFormatter}',

                                        style: Style.montserratMedium(
                                          fontSize: Dimens.d14,
                                            color: ColorConstant.white
                                        ),
                                        // style: Style.workSansRegular(
                                        //   fontSize: Dimens.d14,
                                        //   fontWeight: FontWeight.normal,
                                        //   color: getBgColorAccordingTheme(
                                        //     shoorah: AppColors
                                        //         .textWhiteShoorah,
                                        //     land: AppColors.textWhiteLand,
                                        //     bloom:
                                        //     AppColors.textWhiteBloom,
                                        //     sun: AppColors.textWhiteSun,
                                        //     ocean:
                                        //     AppColors.textWhiteOcean,
                                        //     desert:
                                        //     AppColors.textWhiteDust,
                                        //   ),
                                        // ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            ValueListenableBuilder(
              valueListenable: _isVolShowing,
              builder: (context, value, child) {
                if (value) {
                  return Container(
                    color: ColorConstant.transparent,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 1.5,
                        sigmaY: 1.5,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: Dimens.d200,
                              horizontal: Dimens.d16),
                          padding: const EdgeInsets.all(Dimens.d10),
                          height: Dimens.d60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorConstant.color3d5157,
                            borderRadius: Dimens.d40.radiusAll,
                          ),
                          child: Row(
                            children: [
                              Dimens.d10.spaceWidth,
                              SvgPicture.asset(
                                ImageConstant.loudSpeaker,
                                color: ColorConstant.white,
                              ),
                              Dimens.d10.spaceWidth,
                              ValueListenableBuilder(
                                valueListenable: _slideValue,
                                builder: (context, value, child) {
                                  return Expanded(
                                    child: Slider(
                                      min: Dimens.d0,
                                      max: Dimens.d100,
                                      value: _slideValue.value,
                                      activeColor: ColorConstant.themeColor,
                                      onChanged: (value) {
                                        _audioPlayerManager
                                            .volumeForMeditationAudio(
                                            volume:
                                            _slideValue.value /
                                                100);
                                        _slideValue.value = value;
                                      },
                                      onChangeStart: (_) {
                                        volTimer?.cancel();
                                      },
                                      onChangeEnd: (_) {
                                        Future.delayed(
                                          const Duration(
                                              milliseconds: 500),
                                              () => _isVolShowing.value =
                                          false,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Offstage();
                }
              },
            ),


          ],
        ),
      )
    );
  }


  void _volumeTapHandler() {
    _isVolShowing.value = true;
    volTimer = Timer(const Duration(milliseconds: 1500), () {
      _isVolShowing.value = false;
    });
  }

  void _backwardTapHandler() {
    if (_updatedRealtimeAudioDuration.value <= const Duration(seconds: 15)) {
      if (_localAudioLoaded) {
        _updatedRealtimeAudioDuration.value = Duration.zero;
      } else {
        _audioPlayerManager.seekForMeditationAudio(position: Duration.zero);
      }
    } else if (_updatedRealtimeAudioDuration.value >=
        const Duration(seconds: 0)) {
      if (_localAudioLoaded) {
        _updatedRealtimeAudioDuration.value =
            _updatedRealtimeAudioDuration.value - const Duration(seconds: 15);
      } else {
        _audioPlayerManager.seekForMeditationAudio(
            position: _updatedRealtimeAudioDuration.value -
                const Duration(seconds: 15));
      }
    }
  }


  void _forwardTapHandler() {
    if ((_totalAudioDuration - _updatedRealtimeAudioDuration.value) <=
        const Duration(seconds: 15)) {
      if (_localAudioLoaded) {
        _updatedRealtimeAudioDuration.value =
            _updatedRealtimeAudioDuration.value +
                (_totalAudioDuration - _updatedRealtimeAudioDuration.value);
      } else {
        _audioPlayerManager.audioPlayer.seek(
            _updatedRealtimeAudioDuration.value +
                (_totalAudioDuration - _updatedRealtimeAudioDuration.value));
      }
    } else if (_updatedRealtimeAudioDuration.value <= _totalAudioDuration) {
      if (_localAudioLoaded) {
        _updatedRealtimeAudioDuration.value =
            _updatedRealtimeAudioDuration.value + const Duration(seconds: 15);
      } else {
        _audioPlayerManager.seekForMeditationAudio(
            position: _updatedRealtimeAudioDuration.value +
                const Duration(seconds: 15));
      }
    }
  }


  Future<void> _loadAudio() async {

    _isAudioLoading.value = true;

    /// This will stop the current selected meditation audio
    /// before setting and loading the new audio

    await _audioPlayerManager.audioPlayer.setAudioSource(
      ///asset
      AudioSource.asset(
        ImageConstant.audioPath,
      ),
      /// network
      // AudioSource.uri(
      //   Uri.parse("https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3"),
      // ),
      initialPosition: (_updatedRealtimeAudioDuration.value != Duration.zero)
          ? _updatedRealtimeAudioDuration.value
          : Duration.zero,
    );

    _audioPlayerManager.volumeForMeditationAudio(
        volume: _slideValue.value / 100);
    _totalAudioDuration =
        _audioPlayerManager.audioPlayer.duration ?? const Duration();



    _audioPlayerManager.audioPlayer.playerStateStream.listen((event) {
      /// This will handle what to do once the audio is completed
      if (event.processingState == ProcessingState.completed) {
        //_stopMeditationAudio(isCalledFromCompletedState: true);
      }

      if(_updatedRealtimeAudioDuration.value != Duration.zero){
        _isAudioLoading.value = false;
      }


      /// This will handle the button loading state
      if (event.processingState != ProcessingState.loading) {
        _isAudioLoading.value = false;
      } else{
        _isAudioLoading.value = true;
      }



      /// Assigning the playing state of the meditation audio
      _audioPlayerManager.isMeditationAudioPlaying.value = event.playing;
    });

    _audioPlayerManager.audioPlayer.durationStream.listen((event) {
      _audioPlayerManager.currentlyPlayingMeditationAudioDuration =
          event ?? const Duration();
    });

  }

  Future<void> _playPauseTapHandler() async {
    /// This will temporarily pause the theme BG audio until the current
    /// meditation audio is playing

   // _audioNotificationServiceHandler.isBgAudioPlayerInFocus = false;

    ///
   /* if (_audioPlayerManager.currentAudioPlayingId !=
        widget.restoreMediaData.contentId) {
      /// Set isMiniAudioPlayerPlaying to `true` so that initially it can
      /// show the mini audio player's play/pause to pause icon
      _audioPlayerManager.isMiniAudioPlayerInPlayingState.value = true;
    } else {
      /// Handle the play pause of the mini audio player
      _audioPlayerManager.isMiniAudioPlayerInPlayingState.value =
      !_audioPlayerManager.isMiniAudioPlayerInPlayingState.value;
    }*/
    _audioPlayerManager.isMiniAudioPlayerInPlayingState.value =
    !_audioPlayerManager.isMiniAudioPlayerInPlayingState.value;
    ///


    /// This will check whether the audio is playing or not and
    /// mini audio player is in the focus or not to do the required things

    await _loadAudio();

    await _audioPlayerManager.playPauseEventHandler(
        audioPlayPauseEvent: AudioPlayPauseEvent.playBgAudio);
    /*if (!_audioPlayerManager.isMeditationAudioPlaying.value &&
        _audioPlayerManager.currentAudioPlayingId !=
            widget.restoreMediaData.contentId) {
      /// set empty the currently played track for mini player
      SharedPrefUtils.removeValue(SharedPrefUtilsKeys.currentPlayingTrack);

      /// when audio is changed call add trending api and pass stored data in shared pref
      _addTrendingApi();
      await _loadAudio();
      _localAudioLoaded = false;
      restoreBloc.add(
        AddRecentlyPlayedEvent(
          request: AddBookmarkRequest(
            contentType: widget.appContentType.value,
            contentId: widget.restoreMediaData.contentId,
          ),
        ),
      );
    }*/

    /// Handle the play pause of the main audio player
    _audioPlayerManager.isMeditationAudioPlaying.value =
    !_audioPlayerManager.isMeditationAudioPlaying.value;

    /// Altering the [isMiniAudioPlayerHovering] for visibility of mini audio player
    _audioPlayerManager.isMiniAudioPlayerHovering = true;

    /// Setting the current ID into the singleton var for future checking
    /*_audioPlayerManager.setCurrentIdOfAudio(
        currentId: widget.restoreMediaData.contentId ?? '');*/

    /// Assigning the audio data to the notification
    // _audioPlayerManager.setMeditationAudioData(meditationAudioDataValue: restoreAudioDetails!)
    //     .then((_) {
    //   _audioNotificationServiceHandler.listenForAudioDataChanges();
    //   if (!_audioNotificationServiceHandler.isBgAudioPlayerInFocus) {
    //     _audioNotificationServiceHandler
    //         .handleAudioPlayerControllerForNotification();
    //   }
    // });

    if (_audioPlayerManager.isMeditationAudioPlaying.value) {
      timeStart = 0;

      await Future.delayed(const Duration(minutes: 1), () {
        timeStart = timeStart + 1;
      });
    } else {
      if (timeStart > 0) {
        // _homeBloc.add(GetTimeStampEvent(
        //   type: 2,
        //   duration: timeStart.toDouble(),
        // ));
        setState(() {
          timeStart = 0;
        });
      }
    }

    if (_audioPlayerManager.isMeditationAudioPlaying.value) {
      // for (var element in videoKeys) {
      //   element.currentState?.pause();
      // }
      _audioPlayerManager.playPauseEventHandler(
          audioPlayPauseEvent: AudioPlayPauseEvent.pauseBgAudio);

      await _audioPlayerManager.playPauseEventHandler(
          audioPlayPauseEvent: AudioPlayPauseEvent.playMeditationAudio);
      //Wakelock.enable();
    } else {
      await _audioPlayerManager.playPauseEventHandler(
          audioPlayPauseEvent: AudioPlayPauseEvent.pauseMeditationAudio);

      //Wakelock.disable();
    }
  }

  Future<void> _setInitValues() async {
    randomNumberForSelectingLottie = Dimens.d1.toInt() +
        randomNumberGenerator.nextInt(Dimens.d7.toInt() - Dimens.d1.toInt());
    //_isBookmarked = widget.restoreMediaData.isBookmarked ?? false;

    _totalAudioDuration = parseAudioDuration('00:00');

    /// Checked whether the audio that is playing and the selected card both are same so
    /// it won't reload the audio.

    /*if (_audioPlayerManager.currentAudioPlayingId != widget.restoreMediaData.contentId) {
      position = Duration.zero;
      seekbarDuration = Duration.zero;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _audioPlayerManager.isMeditationAudioPlaying.value = false;
      });
      _localAudioLoaded = true;
    } else {
      _localAudioLoaded = false;

      _audioPlayerManager.audioPlayer.positionStream.listen((event) {
        if (!_isSeekbarSliding) {
          _updatedRealtimeAudioDuration.value = event;
        }
      });
      _totalAudioDuration =
          _audioPlayerManager.audioPlayer.duration ?? const Duration();
      if (_audioPlayerManager.audioPlayer.playing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _audioPlayerManager.isMeditationAudioPlaying.value = true;
        });
      }
    }*/

    _localAudioLoaded = false;

    _audioPlayerManager.audioPlayer.positionStream.listen((event) {
      if (!_isSeekbarSliding) {
        _updatedRealtimeAudioDuration.value = event;
      }
    });
    _totalAudioDuration = _audioPlayerManager.audioPlayer.duration ?? const Duration();
    if (_audioPlayerManager.audioPlayer.playing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _audioPlayerManager.isMeditationAudioPlaying.value = true;
      });
    }
  }

  Duration parseAudioDuration(String audioDurationInString) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = audioDurationInString.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

}


class BgSemiCircleClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    final gap = size.height / 12;

    path.lineTo(0.0, gap);
    var firstControlPoint = Offset(size.width / 2, -gap / 2);
    var firstPoint = Offset(size.width, gap);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstPoint.dx,
      firstPoint.dy,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

