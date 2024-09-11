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
import 'package:transform_your_mind/presentation/breath_screen/breath_controller.dart';
import 'package:transform_your_mind/presentation/breath_screen/notice_how_you_feel_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
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
          ],
        ),
      ),
    );
  }
}
