import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/pods_play_service.dart';
import 'package:transform_your_mind/core/utils/audio_manager/audio_player_manager.dart';
import 'package:transform_your_mind/core/utils/audio_manager/seek_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/duration_formatter.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with TickerProviderStateMixin {
  List<AudioSpeed> audioSpeedList = AudioSpeed.getAudioSpeedList();
  int currentAudioSpeedIndex = 0;
  Duration position = Duration.zero;
  Duration _totalAudioDuration = const Duration();
  Timer? volTimer;
  final ValueNotifier<bool> _isVolShowing = ValueNotifier(false);
  ValueNotifier<bool> isActivityApiCalled = ValueNotifier(false);
  final ValueNotifier<Duration> _updatedRealtimeAudioDuration =
      ValueNotifier(const Duration(hours: 0, minutes: 0, seconds: 0));
  final ValueNotifier<bool> _isAudioLoading = ValueNotifier(false);

  Random randomNumberGenerator = Random();
  late int randomNumberForSelectingLottie;
  double _opacityOfSpeedText = 0.0;
  Timer? _opacityOfSpeedTimer;
  final ValueNotifier<double> _slideValue = ValueNotifier(40.0);
  late final AnimationController _lottieBgController, _lottieController;
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  bool isPlaying = false;
  TextEditingController ratingController = TextEditingController();
  FocusNode ratingFocusNode = FocusNode();
  int? _currentRating = 0;
  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _lottieBgController = AnimationController(vsync: this);

    _setInitValues();

    _audioPlayerService.setUrl(
        'https://media.shoorah.io/admins/shoorah_pods/audio/1682952330-9588.mp3');
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
        body: SafeArea(
      child: Stack(
        children: [
          /// background image
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BgSemiCircleClipPath(),
              child: Container(
                height: Get.height * 0.78,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(ImageConstant.bgImagePlaying),
                        fit: BoxFit.cover)),
              ),
            ),
          ),

          /// app bar
              Column(
                children: [
                  Dimens.d30.h.spaceHeight,
                  CustomAppBar(
                    showBack: true,
                    title: "nowPlaying".tr,
                    leading: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          color: ColorConstant.themeColor,
                        )),
                    action: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showAlertDialog(context);
                          },
                          child: SvgPicture.asset(
                            ImageConstant.ratingIcon,
                          ),
                        ),
                        Dimens.d10.h.spaceWidth,
                        GestureDetector(
                          onTap: () async {},
                          child: SvgPicture.asset(
                            height: 25.h,
                            ImageConstant.share,
                          ),
                        ),
                        Dimens.d10.h.spaceWidth,
                        GestureDetector(
                          onTap: () async {},
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
                    stream: _audioPlayerService.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration?>(
                        stream: _audioPlayerService.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data ?? Duration.zero;
                          return SeekBar(
                            duration: duration,
                            position: position,
                            onChanged: (newPosition) {
                              if (newPosition != null) {
                                _audioPlayerService.seekForMeditationAudio(
                                    position: newPosition);
                              }
                            },
                            onChangeEnd: (newPosition) {
                              if (newPosition != null) {
                                _audioPlayerService.seekForMeditationAudio(
                                    position: newPosition);
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
                      builder: (BuildContext context, value, Widget? child) {
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
                                    _audioPlayerService.skipBackward();
                                  }
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
                                      if (isPlaying) {
                                        _lottieController.stop();
                                        _audioPlayerService.pause();
                                      } else {
                                        _audioPlayerService.play();
                                        _lottieController.repeat();
                                      }
                                      setState(() {
                                        isPlaying = !isPlaying;
                                      });
                                    },
                                    child: Container(
                                      height: Dimens.d64.h,
                                      width: Dimens.d64.h,
                                      decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorConstant.themeColor),
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimens.d17.h),
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      transitionBuilder: (child, animation) =>
                                          RotationTransition(
                                        turns: child.key ==
                                                const ValueKey('ic_pause')
                                            ? Tween<double>(
                                                    begin: Dimens.d1,
                                                    end: Dimens.d0_5)
                                                .animate(animation)
                                            : Tween<double>(
                                                    begin: Dimens.d0_75,
                                                    end: Dimens.d1)
                                                .animate(animation),
                                        child: ScaleTransition(
                                            scale: animation, child: child),
                                      ),
                                      child: isPlaying
                                          ? SvgPicture.asset(
                                              ImageConstant.pause,
                                              key: const ValueKey('ic_pause'))
                                          : SvgPicture.asset(
                                              ImageConstant.play,
                                              // key: const ValueKey(
                                              //     'ic_play'),
                                            ),
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
                                _audioPlayerService.skipForward();
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
                                        setState(() {
                                          _opacityOfSpeedText = 1.0;
                                        });
                                        _opacityOfSpeedTimer?.cancel();
                                        _opacityOfSpeedTimer = Timer(
                                            const Duration(seconds: 5), () {
                                          setState(() {
                                            _opacityOfSpeedText = 0.0;
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
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: AutoSizeText(
                                          audioSpeedList[currentAudioSpeedIndex]
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
                          image: AssetImage(ImageConstant.curveBottomImg),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: Dimens.d20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          _updatedRealtimeAudioDuration
                                              .value.durationFormatter,
                                          style: Style.montserratMedium(
                                          fontSize: Dimens.d14,
                                          color: ColorConstant.white),
                                    );
                                  },
                                ),
                              ),
                            ),

                            /// music animation
                                Lottie.asset(
                                  ImageConstant.lottieAudio,
                                  controller: _lottieController,
                                  height: Dimens.d40,
                                  width: Dimens.d40,
                                  fit: BoxFit.fill,
                                  repeat: true,
                                  onLoaded: (composition) {
                                    _lottieController.duration =
                                        composition.duration;
                                  },
                                ),

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
                                      (_totalAudioDuration -
                                              _updatedRealtimeAudioDuration
                                                  .value)
                                          .durationFormatter,
                                      style: Style.montserratMedium(
                                          fontSize: Dimens.d14,
                                          color: ColorConstant.white),
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
                                vertical: Dimens.d200, horizontal: Dimens.d16),
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
                                          _slideValue.value = value;
                                        },
                                        onChangeStart: (_) {
                                          volTimer?.cancel();
                                        },
                                        onChangeEnd: (_) {
                                          Future.delayed(
                                            const Duration(milliseconds: 500),
                                                () =>
                                            _isVolShowing.value = false,
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
        ));
  }

  void _volumeTapHandler() {
    _isVolShowing.value = true;
    volTimer = Timer(const Duration(milliseconds: 1500), () {
      _isVolShowing.value = false;
    });
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              //backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              actions: <Widget>[
                Dimens.d10.spaceHeight,
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(ImageConstant.close,
                        color: themeController.isDarkMode.value
                            ? ColorConstant.white
                            : ColorConstant.black)),
                Dimens.d3.spaceHeight,
                Center(
                  child: Text("rateYourExperience".tr,
                      textAlign: TextAlign.center,
                      style: Style.cormorantGaramondBold(
                        fontSize: Dimens.d22,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                Dimens.d28.spaceHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                        onTap: () {
                          setState.call(() {
                            _currentRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SvgPicture.asset(
                            index < _currentRating!
                                ? ImageConstant.rating
                                : ImageConstant.rating,
                            color: index < _currentRating!
                                ? ColorConstant.colorFFC700
                                : ColorConstant.colorD9D9D9,
                            height: Dimens.d26,
                            width: Dimens.d26,
                          ),
                        ));
                  }),
                ),
                Dimens.d22.spaceHeight,
                CommonTextField(
                    borderRadius: Dimens.d10,
                    filledColor: ColorConstant.colorECECEC,
                    hintText: "writeYourNote".tr,
                    maxLines: 5,
                    controller: ratingController,
                    focusNode: ratingFocusNode),
                Dimens.d18.spaceHeight,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
                  child: CommonElevatedButton(
                    height: Dimens.d33,
                    textStyle: Style.montserratRegular(
                      fontSize: Dimens.d18,
                      color: ColorConstant.white,
                    ),
                    title: "submit".tr,
                    onTap: () {
                      ratingController.clear();
                      Get.back();
                    },
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _setInitValues() async {
    randomNumberForSelectingLottie = Dimens.d1.toInt() +
        randomNumberGenerator.nextInt(Dimens.d7.toInt() - Dimens.d1.toInt());

    _totalAudioDuration = parseAudioDuration('00:00');

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
