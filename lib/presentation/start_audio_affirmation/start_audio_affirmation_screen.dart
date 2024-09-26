import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/affirmation_model.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/affirmation_controller.dart';
import 'package:transform_your_mind/presentation/home_screen/AlarmNotification.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/audio_list.dart';
import 'package:transform_your_mind/presentation/start_audio_affirmation/start_audio_affirmation_controller.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_practice_great_work.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/end_points.dart';

class StartAudioAffirmationScreen extends StatefulWidget {
  List<AffirmationData>? data;
  String? id;
  String? alarmId;
  Duration? totalDuration;

  StartAudioAffirmationScreen(
      {super.key, this.id, this.data, this.alarmId, this.totalDuration});

  @override
  State<StartAudioAffirmationScreen> createState() =>
      _StartAudioAffirmationScreenState();
}

class _StartAudioAffirmationScreenState
    extends State<StartAudioAffirmationScreen> with TickerProviderStateMixin {
  StartAudioAffirmationController startC =
      Get.put(StartAudioAffirmationController());

  double _setVolumeValue = 0;
  int currentIndex = 1;
  CommonModel commonModel = CommonModel();

  int chooseImage = 0;
  int _currentIndex = 0;
  int likeIndex = 0;

  int selectedTime = 3;
  bool am = true;
  bool pm = false;
  Duration selectedDuration = const Duration(hours: 0, minutes: 0, seconds: 0);
  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSeconds = 0;
  int index = 0;
  List<bool> like = [];

  AffirmationController affirmationController =
      Get.put(AffirmationController());
  bool likeAnimation = false;

  AudioPlayer audioPlayerVoices = AudioPlayer(
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );

  @override
  void initState() {
    super.initState();

    init();
    audioPlayerVoices.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        setState(() {
          value = 0;
          startC.play = false;
        });
        await audioPlayerVoices.pause();

        await audioPlayerVoices.setAudioSource(myPlayList, initialIndex: 0);

        setState(() {
          startC.play = true;
        });
        await audioPlayerVoices.play();

        setState(() {});
        print("#### Done #####");
      }
    });
    audioPlayerVoices.positionStream.listen((position) {
      updateCurrentPosition();
    });
  }

/*void _startProgress() {
    _timer?.cancel();
    int durationInSeconds = speedChange();
    int durationInMilliseconds = durationInSeconds * 1000;
    int intervalInMilliseconds = 80;

    _timer = Timer.periodic(Duration(milliseconds: intervalInMilliseconds), (timer) {
      if (!_isScrolling) {
        timer.cancel();
        return;
      }

      _progress += 1.0 / (durationInMilliseconds / intervalInMilliseconds);
      if (_progress >= 1.0) {
        _progress = 0.0;
        _currentIndex++;

        if (_currentIndex >= widget.data!.length) {
          _timer!.cancel();
          if (widget.data!.length == 1) {
            startC.player.pause();
            Get.to(AffirmationGreatWork(theme: startC.themeList[chooseImage]));
          }
        } else {
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      }
      setState(() {});
    });
  }*/
  getLikeData() {
    if ((widget.data ?? []).isNotEmpty) {
      for (int i = 0; i < widget.data!.length; i++) {
        like.add(widget.data?[i].isLiked ?? false);
      }
    }
    setState(() {});
  }

  AudioSource? source;
  List<AudioSource> list = [];
  late ConcatenatingAudioSource myPlayList;

  init() async {
    getLikeData();
    audioPlayerVoices = AudioPlayer();
    setBackSounds();

    startC.loader.value = true;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    for (AffirmationData path in widget.data!) {
      if (path.audioFile != null) {
        try {
          source = AudioSource.uri(Uri.parse(path.audioFile!));
          /*  if(source != null) {
          final duration = await audioPlayerVoices.setAudioSource(source!);
          if (duration != null) {
            totalDuration += duration;
          }
        }*/
          list.add(source!);
        } catch (e) {
          print(e);
        }
      }
      try {
        // Preload the audio source
      } catch (e) {
        print('Error loading audio: $e');
      }
    }

    myPlayList = ConcatenatingAudioSource(
      children: list,
    );

    // Set the playlist in the player
    (await audioPlayerVoices.setAudioSource(
      myPlayList,
      initialIndex: 0,
      preload: true,
    ))!;

    setState(() {
      startC.play = true;
      startC.loader.value = false;
    });

    await audioPlayerVoices.play();
  }

  bool showBottom = false;

  Duration currentPosition = Duration.zero;
  late List<AlarmSettings> alarms;

  double value = 0;

  Future<Duration?> _getDuration(AudioSource item) async {
    // Load the item into the player temporarily to get its duration
    await audioPlayerVoices.setAudioSource(item);
    return audioPlayerVoices.duration;
  }

  updateCurrentPosition() {
    final currentIndex = audioPlayerVoices.currentIndex ?? 0;
    final currentItemPosition = audioPlayerVoices.position;
    Duration cumulativeDuration = Duration.zero;

    for (int i = 0; i < currentIndex; i++) {
      final duration = audioPlayerVoices.sequence![i].duration ?? Duration.zero;
      cumulativeDuration += duration;
    }

    currentPosition = cumulativeDuration + currentItemPosition;
    if (currentPosition.inSeconds != 0) {
      value =
          (currentPosition.inSeconds / widget.totalDuration!.inSeconds) * 100;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return WillPopScope(
      onWillPop: () async {
        await startC.player.pause();
        await audioPlayerVoices.stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  startC.setSpeed.value = false;
                });
              },
              child: Stack(
                children: [
                  //_________________________________ background Image _______________________
                  Stack(
                    children: [
                      CachedNetworkImage(
                        height: Get.height,
                        width: Get.width,
                        imageUrl: startC.themeList[chooseImage],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => PlaceHolderCNI(
                          height: Get.height,
                          width: Get.width,
                          borderRadius: 10.0,
                        ),
                        errorWidget: (context, url, error) => PlaceHolderCNI(
                          height: Get.height,
                          width: Get.width,
                          isShowLoader: false,
                          borderRadius: 8.0,
                        ),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                        // Adjust the sigmaX and sigmaY values to control the blur intensity
                        child: Container(
                          height: Get.height,
                          width: Get.width,
                          color: Colors.black.withOpacity(
                              0.5), // Adjust the opacity to your preference
                        ),
                      ),
                    ],
                  ),
                  //_________________________________ story Progress indicators _______________________
                  // Positioned(
                  //   top: 40,
                  //   left: 10,
                  //   right: 10,
                  //   child: Row(
                  //     children: List.generate(widget.data!.length, (index) {
                  //       return Expanded(
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  //           child: LinearProgressIndicator(
                  //             value: index == _currentIndex
                  //                 ? _progress
                  //                 : (index < _currentIndex ? 1.0 : 0.0),
                  //             backgroundColor: Colors.grey,
                  //             valueColor: const AlwaysStoppedAnimation<Color>(
                  //               Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     }),
                  //   ),
                  // ),

                  //_________________________________ close button  _______________________

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SfRadialGauge(axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          showLabels: false,
                          showTicks: false,
                          startAngle: 270,
                          endAngle: 270,
                          radiusFactor: 0.55,
                          axisLineStyle: const AxisLineStyle(
                            thickness: 0.02,
                            cornerStyle: CornerStyle.bothCurve,
                            color: Colors.white,
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: value,
                              cornerStyle: CornerStyle.bothCurve,
                              width: 0.02,
                              sizeUnit: GaugeSizeUnit.factor,
                              enableAnimation: true,
                              color: value == 0
                                  ? Colors.white
                                  : ColorConstant.themeColor,
                              animationDuration: 1500,
                              animationType: AnimationType.ease,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white)),
                              alignment: Alignment.center,
                            )),
                            // GaugeAnnotation(
                            //     widget: Container(
                            //   height: 250,
                            //   width: 250,
                            //   decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //     image: DecorationImage(image: AssetImage(
                            //       ImageConstant.logoSplashRemoved,
                            //     ),
                            //     opacity: 0.5
                            //     ),
                            //     ),
                            //   alignment: Alignment.center,
                            //
                            //
                            // )),
                          ],
                        )
                      ]),
                      InkWell(
                          onTap: () async {
                            if (widget.totalDuration != Duration.zero) {
                              if (startC.play) {
                                setState(() {
                                  startC.play = false;
                                });
                                await audioPlayerVoices.stop();
                              } else {
                                setState(() {
                                  startC.play = true;
                                });
                                try {
                                  await audioPlayerVoices.play();
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              (startC.play)
                                  ? Icons.pause
                                  : Icons.play_arrow_rounded,
                              size: 50,
                              color: ColorConstant.themeColor,
                            ),
                          )),
                    ],
                  ),
                  //_________________________________ Skip Method  _______________________
                  Positioned(
                    top: Dimens.d70,
                    left: 16,
                    child: GestureDetector(
                      onTap: () async {
                        Get.back();
                        await startC.player.pause();
                        await audioPlayerVoices.stop();
                      },
                      child: Container(
                        height: 42,
                        width: 42,
                        padding: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorConstant.white),
                        child: const Center(
                            child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 20,
                        )),
                      ),
                    ),
                  ),
                  //_________________________________ theme Change button  _______________________

                  Positioned(
                    top: Dimens.d70,
                    right: 16,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showBottom = true;
                                });
                                sheetSound();
                              },
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color:
                                        ColorConstant.white.withOpacity(0.15)),
                                child: Center(
                                  child: SvgPicture.asset(
                                    ImageConstant.music,
                                    height: Dimens.d28,
                                    width: Dimens.d28,
                                  ),
                                ),
                              ),
                            ),
                            Dimens.d5.spaceHeight,
                            Text(
                              "music".tr,
                              style: Style.gothamLight(
                                  fontSize: 10, color: Colors.white),
                            )
                          ],
                        ),
                        Dimens.d10.spaceWidth,
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showBottom = true;
                                });
                                sheetTheme();
                              },
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color:
                                        ColorConstant.white.withOpacity(0.15)),
                                child: Center(
                                  child: Image.asset(
                                    ImageConstant.themeChange,
                                    height: Dimens.d28,
                                    width: Dimens.d28,
                                  ),
                                ),
                              ),
                            ),
                            Dimens.d5.spaceHeight,
                            Text(
                              "theme".tr,
                              style: Style.gothamLight(
                                  fontSize: 10, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  //_____________________________ like ,clock, share________________________
                  showBottom
                      ? const SizedBox()
                      : Positioned(
                          bottom: Dimens.d246,
                          left: MediaQuery.of(context).size.width / 3.2,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Share.share(widget
                                      .data![_currentIndex].description
                                      .toString());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SvgPicture.asset(ImageConstant.share,
                                      color: ColorConstant.white,
                                      height: 22,
                                      width: 22),
                                ),
                              ),
                              Dimens.d40.spaceWidth,
                              GestureDetector(
                                onTap: () {
                                  // _stopScrolling();
                                  setState(() {
                                    showBottom = true;
                                  });
                                  sheetAlarm();
                                },
                                child: SvgPicture.asset(ImageConstant.alarm,
                                    color: ColorConstant.white,
                                    height: 20,
                                    width: 20),
                              ),
                              Dimens.d40.spaceWidth,
                              GestureDetector(
                                onTap: () async {
                                  like[likeIndex] = !like[likeIndex];

                                  await updateAffirmationLike(
                                      isLiked: like[likeIndex],
                                      id: widget.data![likeIndex].id);

                                  setState(() {
                                    likeAnimation = like[likeIndex];
                                    Future.delayed(const Duration(seconds: 2))
                                        .then(
                                      (value) {
                                        setState(() {
                                          likeAnimation = false;
                                        });
                                      },
                                    );
                                  });
                                },
                                child: SvgPicture.asset(
                                  like[likeIndex]
                                      ? ImageConstant.likeRedTools
                                      : ImageConstant.likeTools,
                                  color: like[likeIndex]
                                      ? ColorConstant.deleteRed
                                      : ColorConstant.white,
                                  height: 20,
                                  width: 20,
                                ),
                              )
                            ],
                          )),

                  startC.setSpeed.isTrue
                      ? Positioned(
                          bottom: Dimens.d170,
                          left: MediaQuery.of(context).size.width / 2.5,
                          child: Container(
                            width: 82,
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: ColorConstant.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: startC.speedList.length,
                                itemBuilder: (context, index) {
                                  bool isChecked =
                                      startC.selectedSpeedIndex == index;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        startC.setSelectedSpeedIndex(index);
                                        speedChange();
                                        audioPlayerVoices.setSpeed(
                                            speedChange().toDouble() / 10);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isChecked ? Icons.check : null,
                                            color: isChecked
                                                ? ColorConstant.themeColor
                                                : ColorConstant.transparent,
                                            size: 10,
                                          ),
                                          Dimens.d5.spaceWidth,
                                          Text(
                                            startC.speedList[index],
                                            style: Style.nunRegular(
                                                fontSize: 10,
                                                color: isChecked
                                                    ? ColorConstant.themeColor
                                                    : ColorConstant.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                      : const SizedBox(),
                  //_________________________________ bottom View sound  _______________________

                  showBottom
                      ? const SizedBox()
                      : Positioned(
                          bottom: Dimens.d85,
                          left: MediaQuery.of(context).size.width / 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 27, vertical: 10),
                            decoration: BoxDecoration(
                                color: ColorConstant.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      startC.soundMute = !startC.soundMute;
                                    });
                                    if (startC.soundMute) {
                                      startC.player.setVolume(0);
                                    } else {
                                      startC.player.setVolume(0.16);
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        startC.soundMute
                                            ? ImageConstant.soundMute
                                            : ImageConstant.soundMax,
                                        color: ColorConstant.white,
                                      ),
                                      commonText("sound".tr),
                                    ],
                                  ),
                                ),
                                Dimens.d32.spaceWidth,
                                Container(
                                  width: 1,
                                  height: 47,
                                  color: ColorConstant.white,
                                ),
                                Dimens.d32.spaceWidth,
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      startC.setSpeed.value =
                                          !startC.setSpeed.value;
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      commonTextTitle("auto".tr),
                                      Dimens.d6.spaceHeight,
                                      commonText("forEach".tr),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  likeAnimation == true
                      ? Center(
                          child: Image.asset(
                            ImageConstant.likeGif,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Obx(
              () => startC.loader.isTrue ? commonLoader() : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Future sheetAlarm() {
    return showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                Positioned(
                  top: 600,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      color: ColorConstant.black.withOpacity(0.4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Dimens.d10.spaceHeight,
                            Center(
                              child: Container(
                                height: 4,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: ColorConstant.colorBCBCBC,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            Dimens.d10.spaceHeight,
                            Row(
                              children: [
                                Text(
                                  "Alarm".tr,
                                  style: Style.nunMedium(
                                    fontSize: 32,
                                    color: ColorConstant.white,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 26,
                                  width: Dimens.d100,
                                  decoration: BoxDecoration(
                                    color: ColorConstant.transparent,
                                    borderRadius: BorderRadius.circular(17),
                                    border: Border.all(
                                      color: ColorConstant.colorBFBFBF,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState.call(() {
                                            am = true;
                                            pm = false;
                                          });
                                        },
                                        child: Container(
                                          width: Dimens.d49,
                                          decoration: BoxDecoration(
                                            color: am
                                                ? ColorConstant.themeColor
                                                : ColorConstant.transparent,
                                            borderRadius:
                                                BorderRadius.circular(17),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "AM",
                                              style: Style.nunRegular(
                                                fontSize: 12,
                                                color: am
                                                    ? ColorConstant.white
                                                    : ColorConstant.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState.call(() {
                                            am = false;
                                            pm = true;
                                          });
                                        },
                                        child: Container(
                                          height: 26,
                                          width: Dimens.d49,
                                          decoration: BoxDecoration(
                                            color: pm
                                                ? ColorConstant.themeColor
                                                : ColorConstant.transparent,
                                            borderRadius:
                                                BorderRadius.circular(17),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "PM",
                                              style: Style.nunRegular(
                                                fontSize: 12,
                                                color: pm
                                                    ? ColorConstant.white
                                                    : ColorConstant.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Dimens.d10.spaceHeight,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  commonTextA("hours".tr),
                                  commonTextA("minutes".tr),
                                  commonTextA("seconds".tr),
                                ],
                              ),
                            ),
                            Dimens.d10.spaceHeight,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              child: Row(
                                children: [
                                  NumberPicker(
                                    infiniteLoop: true,
                                    zeroPad: true,
                                    value: selectedHour,
                                    minValue: 0,
                                    textStyle: Style.nunRegular(
                                      fontSize: 14,
                                      color: ColorConstant.colorCACACA,
                                    ),
                                    selectedTextStyle: Style.montserratBold(
                                      fontSize: 22,
                                      color: ColorConstant.themeColor,
                                    ),
                                    maxValue: am ? 12 : 24,
                                    itemHeight: 50,
                                    itemWidth: 50,
                                    onChanged: (value) =>
                                        setState(() => selectedHour = value),
                                  ),
                                  const Spacer(),
                                  numericSymbol(),
                                  const Spacer(),
                                  NumberPicker(
                                    infiniteLoop: true,
                                    zeroPad: true,
                                    value: selectedMinute,
                                    minValue: 0,
                                    itemHeight: 50,
                                    itemWidth: 50,
                                    textStyle: Style.nunRegular(
                                      fontSize: 14,
                                      color: ColorConstant.colorCACACA,
                                    ),
                                    selectedTextStyle: Style.montserratBold(
                                      fontSize: 22,
                                      color: ColorConstant.themeColor,
                                    ),
                                    maxValue: 59,
                                    onChanged: (value) =>
                                        setState(() => selectedMinute = value),
                                  ),
                                  const Spacer(),
                                  numericSymbol(),
                                  const Spacer(),
                                  NumberPicker(
                                    infiniteLoop: true,
                                    zeroPad: true,
                                    value: selectedSeconds,
                                    minValue: 0,
                                    itemHeight: 50,
                                    itemWidth: 50,
                                    textStyle: Style.nunRegular(
                                      fontSize: 14,
                                      color: ColorConstant.colorCACACA,
                                    ),
                                    selectedTextStyle: Style.montserratBold(
                                      fontSize: 22,
                                      color: ColorConstant.themeColor,
                                    ),
                                    maxValue: 59,
                                    onChanged: (value) =>
                                        setState(() => selectedSeconds = value),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                index = await Navigator.push(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return const AudioList();
                                  },
                                ));
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                height: Dimens.d51,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: ColorConstant.backGround,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Dimens.d14.spaceWidth,
                                    Text(
                                      "sound".tr,
                                      style: Style.nunRegular(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "default".tr,
                                      style: Style.nunRegular(
                                        fontSize: 14,
                                        color: ColorConstant.color787878,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      ImageConstant.settingArrowRight,
                                      color: ColorConstant.color787878,
                                    ),
                                    Dimens.d14.spaceWidth,
                                  ],
                                ),
                              ),
                            ),
                            Dimens.d20.spaceHeight,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.d70.h),
                              child: CommonElevatedButton(
                                textStyle: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  color: ColorConstant.white,
                                ),
                                title: "save".tr,
                                onTap: () async {
                                  _setAlarm(
                                      widget.data?[_currentIndex].alarmId ?? 1);
                                  await createAlarm(widget.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      // _startScrolling();

      setState(() {
        showBottom = false;
      });
    });
  }

  createAlarm(id) async {
    setState(() {
      startC.loader.value = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('POST', Uri.parse(EndPoints.addAlarm));
    request.body = json.encode({
      "hours": selectedHour,
      "minutes": selectedMinute,
      "seconds": selectedSeconds,
      "time": am == true ? "AM" : "PM",
      "affirmationId": id,
      "created_by": PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      selectedSeconds = 0;
      selectedMinute = 0;
      selectedHour = 0;
      setState(() {
        startC.loader.value = false;
      });

      debugPrint(await response.stream.bytesToString());
      showSnackBarSuccess(context, "alarmSet".tr);
      Get.back();
    } else {
      selectedSeconds = 0;
      selectedMinute = 0;
      selectedHour = 0;
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message ?? "alarmAlreadySet".tr);
      Get.back();

      setState(() {
        startC.loader.value = false;
      });

      debugPrint(response.reasonPhrase);
    }
    setState(() {
      startC.loader.value = false;
    });
  }

  void _setAlarm(id) async {
    if (am == true) {
    } else {
      if (selectedHour < 12) {
        selectedHour = selectedHour + 12;
      }
    }

    DateTime alarmTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, selectedHour, selectedMinute, selectedSeconds);
    // File filePath =  await downloadAudioFile(widget.data![0].audioFile ?? 'assets/audio/audio.mp3');
    if (alarmTime.isAfter(DateTime.now())) {
      final alarmSettings = AlarmSettings(
          id: id,
          dateTime: alarmTime,
          //  assetAudioPath: filePath.path !=""?filePath.path: 'assets/audio/audio.mp3',
          assetAudioPath:
              index == 1 ? ImageConstant.bgAudio2 : ImageConstant.bgAudio1,
          loopAudio: true,
          vibrate: true,
          volume: 0.8,
          androidFullScreenIntent: true,
          fadeDuration: 3.0,
          notificationTitle: 'TransformYourMind',
          notificationBody: PrefService.getString(PrefKey.language) == "en-US" ||  PrefService.getString(PrefKey.language) == ""
              ? 'TransformYourMind Alarm ringing.....'
              : "Dein sanfter Weckruf in den Tag.....",
          enableNotificationOnKill:
              Platform.isAndroid ? Platform.isAndroid : Platform.isIOS);
      await Alarm.set(
        alarmSettings: alarmSettings,
      );
    }
  }

  Future<File> downloadAudioFile(String url) async {
    // Get the download path
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${DateTime.now().millisecond}.aac';

    // Download the file
    final response = await http.get(Uri.parse(url));

    // Check if the file was downloaded successfully
    if (response.statusCode == 200) {
      // Save the file to the download path
      response.bodyBytes.first;
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('Audio file downloaded and saved to $filePath');
      return file;
    } else {
      print('Failed to download audio file');
      return File("");
    }
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            AlarmNotificationScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
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

  updateAffirmationLike({String? id, bool? isLiked}) async {
    setState(() {
      startC.loader.value = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('${EndPoints.baseUrl}${EndPoints.updateAffirmation}$id'));

    request.fields.addAll({'isLiked': "$isLiked"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        startC.loader.value = false;
      });
      setState(() {});
    } else {
      setState(() {
        startC.loader.value = false;
      });
      debugPrint(response.reasonPhrase);
    }
    setState(() {
      startC.loader.value = false;
    });
  }

  setBackSounds() async {
    startC.soundMute = false;
    startC.player.setVolume(0.16);
    await startC.player.setAsset(startC.soundList[1]["audio"]);
    await startC.player.setLoopMode(LoopMode.one);
    await startC.player.play();
  }

  commonText(text) {
    return Text(
      text,
      style: Style.nunRegular(
          fontSize: 14, color: ColorConstant.white.withOpacity(0.5)),
    );
  }

  commonTextTitle(text) {
    return Text(
      text,
      style: Style.nunRegular(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: ColorConstant.white),
    );
  }

  Future sheetSound() {
    return showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: ColorConstant.black.withOpacity(0.2)),
              height: 280,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 0.0,
                    sigmaY: 0.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Dimens.d10.spaceHeight,
                      Center(
                        child: Container(
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                              color: ColorConstant.colorBCBCBC,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      Dimens.d20.spaceHeight,
                      Text('sound'.tr,
                          style: Style.nunMedium(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.white)),
                      Dimens.d20.spaceHeight,
                      Expanded(
                        child: ListView.builder(
                          itemCount: startC.soundList.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                setState.call(() {
                                  currentIndex = index;
                                });
                                await startC.player
                                    .setAsset(startC.soundList[index]["audio"]);
                                await startC.player.setLoopMode(LoopMode.one);
                                await startC.player.play();
                              },
                              child: startC.soundList[index]["title"] == "None"
                                  ? Container(
                                      width: 100,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: currentIndex == index
                                              ? Colors.black.withOpacity(0.5)
                                              : ColorConstant.white
                                                  .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: currentIndex == index
                                                  ? ColorConstant.white
                                                  : Colors.transparent)),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Dimens.d36.spaceHeight,
                                          Container(
                                            height: 27,
                                            width: 27,
                                            decoration: const BoxDecoration(
                                                color: ColorConstant.white,
                                                shape: BoxShape.circle),
                                          ),
                                          Dimens.d25.spaceHeight,
                                          Text(
                                            startC.soundList[index]["title"],
                                            textAlign: TextAlign.center,
                                            style: Style.nunRegular(
                                                fontSize: 12,
                                                color: ColorConstant.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      width: 100,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: currentIndex == index
                                              ? Colors.black.withOpacity(0.5)
                                              : ColorConstant.white
                                                  .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: currentIndex == index
                                                  ? ColorConstant.white
                                                  : Colors.transparent)),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Dimens.d20.spaceHeight,
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(80),
                                            child: Image.asset(
                                              ImageConstant.gratitudeBackground,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Dimens.d10.spaceHeight,
                                          Text(
                                            startC.soundList[index]["title"],
                                            textAlign: TextAlign.center,
                                            style: Style.nunRegular(
                                                fontSize: 12,
                                                color: ColorConstant.white),
                                          ),
                                        ],
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                      Dimens.d15.spaceHeight,
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            ImageConstant.soundLow,
                            color: ColorConstant.white,
                          ),
                          ValueListenableBuilder(
                            valueListenable: startC.slideValue,
                            builder: (context, value, child) {
                              return Expanded(
                                child: Slider(
                                  thumbColor: ColorConstant.white,
                                  min: 0,
                                  max: 1,
                                  activeColor: ColorConstant.themeColor,
                                  onChanged: (double value) {
                                    setState.call(() {
                                      _setVolumeValue = value;
                                      VolumeController()
                                          .setVolume(_setVolumeValue);
                                    });
                                    setState(() {});
                                  },
                                  value: _setVolumeValue,
                                ),
                              );
                            },
                          ),
                          SvgPicture.asset(
                            ImageConstant.soundMax,
                            color: ColorConstant.white,
                          ),
                        ],
                      ),
                      Dimens.d15.spaceHeight,
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(
      () {
        setState(() {
          showBottom = false;
        });
      },
    );
  }

  Future sheetTheme() {
    return showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: ColorConstant.black.withOpacity(0.3)),
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 0.0,
                    sigmaY: 0.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Dimens.d10.spaceHeight,
                      Center(
                        child: Container(
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                              color: ColorConstant.colorBCBCBC,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      Dimens.d25.spaceHeight,
                      Expanded(
                        child: ListView.builder(
                          itemCount: startC.themeList.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState.call(() {
                                  chooseImage = index;
                                });
                                setState(() {});
                              },
                              child: Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: chooseImage == index
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CachedNetworkImage(
                                  height: 160,
                                  width: 100,
                                  imageUrl: startC.themeList[index],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(
                                        10.0,
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => PlaceHolderCNI(
                                    height: Get.height,
                                    width: Get.width,
                                    borderRadius: 10.0,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      PlaceHolderCNI(
                                    height: Get.height,
                                    width: Get.width,
                                    isShowLoader: false,
                                    borderRadius: 8.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Dimens.d15.spaceHeight,
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(
      () {
        setState(() {
          showBottom = false;
        });
      },
    );
  }

  Widget commonTextA(title) {
    return Text(
      title,
      style: Style.nunRegular(fontSize: 12, color: Colors.white),
    );
  }

  Widget numericSymbol() {
    return Text(":",
        style: Style.montserratBold(
            fontSize: 22, color: ColorConstant.themeColor));
  }

  int speedChange() {
    switch (startC.selectedSpeedIndex) {
      case 0:
        return 10;
      case 1:
        return 20;
      case 2:
        return 15;
      case 3:
        return 10;
      case 4:
        return 5;
      default:
        return 8;
    }
  }

  @override
  void dispose() {
    audioPlayerVoices.stop();
    super.dispose();
  }
}
