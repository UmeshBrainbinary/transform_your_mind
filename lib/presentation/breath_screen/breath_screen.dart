import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/breath_screen/breath_controller.dart';
import 'package:transform_your_mind/presentation/breath_screen/notice_how_you_feel_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class BreathScreen extends StatefulWidget {
  bool? skip = false;
  bool? setting = false;

  BreathScreen({super.key, this.skip, this.setting});

  @override
  State<BreathScreen> createState() => _BreathScreenState();
}

class _BreathScreenState extends State<BreathScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  bool isPlaying = false;
  bool _isPaused = false;
  int playCount = 0;
  Timer? _timer;
  int _remainingSeconds = 16;
  ThemeController themeController = Get.find<ThemeController>();
  BreathController breathController = Get.put(BreathController());
  @override
  void initState() {
    setAudioFile();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    super.initState();
  }
  setAudioFile() async {

    await breathController.setUrl(
        "assets/audio/breathing_music.mp3"
      // "https://media.shoorah.io/admins/shoorah_pods/audio/1682951517-7059.mp3"
    );

  }

  @override
  void dispose() {
    _lottieController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimationSequence() {
    setState(() {
      isPlaying = true;
      _isPaused = false;
    });
    _lottieController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!_isPaused) {
        setState(() {
          _remainingSeconds--;
        });
      }

      if (_remainingSeconds <= 0) {
        setState(() {
          isPlaying = false;
          playCount++;
          _remainingSeconds = 16;
        });
        _timer?.cancel();
        if (playCount < 3) {
          _startAnimationSequence();
        } else {
          await breathController.pause();
          if (alreadySkipped == false) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NoticeHowYouFeelScreen(
                  notice: widget.skip, setting: widget.setting);
            })).then((value) {
              setState(() {
                playCount = 0;
                _timer;
                isPlaying = false;
                _lottieController.reset();
                _lottieController.stop();
              });
            });
          }
        }
      }
    });
  }

  void _pauseAnimation() {
    setState(() {
      _isPaused = true;
      _lottieController.stop();
      _timer?.cancel();
    });
  }

  void _resumeAnimation() {
    setState(() {
      _isPaused = false;
      _lottieController.forward();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        setState(() {
          _remainingSeconds--;
        });

        if (_remainingSeconds <= 0) {
          setState(() {
            isPlaying = false;
            playCount++;
            _remainingSeconds = 16;
          });
          _timer?.cancel();
          if (playCount < 3) {
            _startAnimationSequence();
          } else {
            await breathController.pause();
if(alreadySkipped == false) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return NoticeHowYouFeelScreen(
        notice: widget.skip, setting: widget.setting);
  })).then((value) {
    setState(() {
      playCount = 0;
      _timer;
      isPlaying = false;
      _lottieController.reset();
      _lottieController.stop();
    });
  });
}
          }
        }
      });
    });
  }

  void _triggerSOS(BuildContext context) async {
    final url = Uri.parse('tel:+911234567899');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showSnackBarError(context, "CouldLaunch".tr);
    }
  }
  final audioPlayerController = Get.put(NowPlayingController());
  bool alreadySkipped = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        onTap: () async {
          await breathController.pause();
          Get.back();
          },
        centerTitle: widget.skip!?true:false,
        showBack:widget.skip!?false:true,
        title: "breathTraining".tr,
        action: widget.skip!
            ? GestureDetector(
                onTap: () async {
                  await breathController.pause();
setState(() {
alreadySkipped =true;

});
                  Get.toNamed(AppRoutes.selectYourFocusPage);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "skip".tr,
                    style: Style.nunitoBold(
                      fontSize: Dimens.d18,
                      color: themeController.isDarkMode.isTrue
                          ? ColorConstant.white
                          : ColorConstant.black,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: Dimens.d35,right: 40,left: 40),
              child: Text(
                "breathingMeditation".tr,
                textAlign: TextAlign.center,
                style: Style.nunitoBold(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ).copyWith(letterSpacing: 1),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Lottie.asset(
                ImageConstant.animation,
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController
                    ..duration = composition.duration
                    ..addListener(() {
                      setState(() {});
                    })
                    ..addStatusListener((status) {
                      if (status == AnimationStatus.completed) {
                        _lottieController.reset();
                      }
                    });
                },
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Dimens.d280.spaceHeight,
                GestureDetector(
                  onTap: () async {
                    if (isPlaying && !_isPaused) {
                      _pauseAnimation();
                      await breathController.pause();

                    } else if (isPlaying && _isPaused) {
                      _resumeAnimation();
                      await breathController.play();

                    } else {

                      _startAnimationSequence();
                      await breathController.play();

                    }
                  },
                  child: SvgPicture.asset(isPlaying && !_isPaused
                      ? ImageConstant.breathPause
                      : ImageConstant.breathPlay),
                ),
                Dimens.d20.spaceHeight,

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d36),
                  child: Text(
                    "breatheNote".tr,
                    textAlign: TextAlign.center,
                    style: Style.nunRegular(
                      height: 2,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Dimens.d44.spaceHeight,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.isTrue
                        ? ColorConstant.textfieldFillColor
                        : ColorConstant.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("In".tr,
                            style: Style.nunRegular(
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text("4sec".tr,
                            style: Style.nunRegular(
                              fontSize: 16,
                              color: ColorConstant.colorA49F9F,
                            ),
                          ),
                        ],
                      ),
                      Dimens.d10.spaceHeight,
                      Row(
                        children: [
                          Text("hold".tr,
                            style: Style.nunRegular(
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text("4sec".tr,
                            style: Style.nunRegular(
                              fontSize: 16,
                              color: ColorConstant.colorA49F9F,
                            ),
                          ),
                        ],
                      ),
                      Dimens.d10.spaceHeight,
                      Row(
                        children: [
                          Text("out".tr,
                            style: Style.nunRegular(
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text("4sec".tr,
                            style: Style.nunRegular(
                              fontSize: 16,
                              color: ColorConstant.colorA49F9F,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                Dimens.d30.spaceHeight,
              ///_________________________________ SOS button _________________________
              /*  GestureDetector(
                  onLongPress: () {
                    _triggerSOS(context);
                  },
                  child: SvgPicture.asset(ImageConstant.sos, height: 86, width: 86),
                ),
                Dimens.d30.spaceHeight,*/
              ],
            ),
            Obx(() {
              if (!audioPlayerController.isVisible.value) {
                return const SizedBox.shrink();
              }

              final currentPosition =
                  audioPlayerController.positionStream.value ??
                      Duration.zero;
              final duration =
                  audioPlayerController.durationStream.value ??
                      Duration.zero;
              final isPlaying = audioPlayerController.isPlaying.value;

              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          Dimens.d24,
                        ),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return NowPlayingScreen(
                        audioData: audioDataStore!,
                      );
                    },
                  );
                },
                child: Padding(
                  padding:  EdgeInsets.only(top: Get.height-300),
                  child: Container(
                    height: 72,
                    width: Get.width,
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 8, right: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 50),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            ColorConstant.colorB9CCD0,
                            ColorConstant.color86A6AE,
                            ColorConstant.color86A6AE,
                          ], // Your gradient colors
                          begin: Alignment.bottomLeft,
                          end: Alignment.bottomRight,
                        ),
                        color: ColorConstant.themeColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommonLoadImage(
                                borderRadius: 6.0,
                                url: audioDataStore!.image!,
                                width: 47,
                                height: 47),
                            Dimens.d12.spaceWidth,
                            GestureDetector(
                                onTap: () async {
                                  if (isPlaying) {
                                    await audioPlayerController
                                        .pause();
                                  } else {
                                    await audioPlayerController
                                        .play();
                                  }
                                },
                                child: SvgPicture.asset(
                                  isPlaying
                                      ? ImageConstant.pause
                                      : ImageConstant.play,
                                  height: 17,
                                  width: 17,
                                )),
                            Dimens.d10.spaceWidth,
                            Expanded(
                              child: Text(
                                audioDataStore!.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Style.nunRegular(
                                    fontSize: 12,
                                    color: ColorConstant.white),
                              ),
                            ),
                            Dimens.d10.spaceWidth,
                            GestureDetector(
                                onTap: () async {
                                  await audioPlayerController.reset();
                                },
                                child: SvgPicture.asset(
                                  ImageConstant.closePlayer,
                                  color: ColorConstant.white,
                                  height: 24,
                                  width: 24,
                                )),
                            Dimens.d10.spaceWidth,
                          ],
                        ),
                        Dimens.d8.spaceHeight,
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor:
                            ColorConstant.white.withOpacity(0.2),
                            inactiveTrackColor:
                            ColorConstant.color6E949D,
                            trackHeight: 1.5,
                            thumbColor: ColorConstant.transparent,
                            thumbShape: SliderComponentShape.noThumb,
                            overlayColor: ColorConstant.backGround
                                .withAlpha(32),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius:
                                16.0), // Customize the overlay shape and size
                          ),
                          child: SizedBox(
                            height: 2,
                            child: Slider(
                              thumbColor: Colors.transparent,
                              activeColor: ColorConstant.backGround,
                              value: currentPosition.inMilliseconds
                                  .toDouble(),
                              max: duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                audioPlayerController
                                    .seekForMeditationAudio(
                                    position: Duration(
                                        milliseconds:
                                        value.toInt()));
                              },
                            ),
                          ),
                        ),
                        Dimens.d5.spaceHeight,
                      ],
                    ),
                  ),
                ),
              );
            }),

          ],
        ),
      ),
    );
  }
}
