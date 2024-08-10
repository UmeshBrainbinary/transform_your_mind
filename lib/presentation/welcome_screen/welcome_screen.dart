import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_api/common_api.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_message.dart';
import 'package:transform_your_mind/presentation/welcome_screen/welcome_home_controller.dart';
import 'package:vibration/vibration.dart';
class WelcomeHomeScreen extends StatefulWidget {
  const WelcomeHomeScreen({super.key});

  @override
  State<WelcomeHomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeHomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  WelcomeHomeController welcomeHomeController = Get.put(WelcomeHomeController());
  String greeting = "";

  void _setGreetingBasedOnTime() {
    greeting = _getGreetingBasedOnTime();
    setState(() {});
  }

  String _getGreetingBasedOnTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'goodMorning';
    } else if (hour >= 12 && hour < 17) {
      return 'goodAfternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'goodEvening';
    } else {
      return 'goodNight';
    }
  }

  late AnimationController _controller;
  late Animation<Color?> _animation;

  bool _showText = false;
  bool _stopE = true;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = ColorTween(
      begin: Colors.black.withOpacity(0.1),
      end: Colors.white,
    ).animate(_controller);
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    setAudioFile();

    _setGreetingBasedOnTime();
    super.initState();
  }

  setAudioFile() async {

    await welcomeHomeController.setUrl(
      "assets/audio/breathing_music.mp3"
       // "https://media.shoorah.io/admins/shoorah_pods/audio/1682951517-7059.mp3"
    );
    await welcomeHomeController.play();
  }

  Future<void> _onTap() async {

    setState(() {
    });
  }

  bool _isLongPressed = false;

  int startTimer = 0;

  Future<void> _onLongPress() async {

    Vibration.vibrate(
      pattern: [80, 80, 0, 0, 0, 0, 0, 0],
      intensities: [20, 20, 0, 0, 0, 0, 0, 0],
    );
    _lottieController.repeat();
    _isLongPressed = true;
    setState(() {
      _showText = true;
      _stopE = false;
    });
    Future.delayed(const Duration(seconds: 2)).then(
      (value) async {
        if (_isLongPressed) {
          _controller.forward();
          await PrefService.setValue(PrefKey.welcomeScreen, true);
          await welcomeHomeController.pause();
          await welcomeHomeController.audioPlayer.stop();
          await updateApi(context,pKey: "welcomeScreen");
           Future.delayed(const Duration(seconds: 1)).then((value) {
            return Get.offAll(MotivationalMessageScreen(
              skip: true,
              date: DateFormat('d MMMM yyyy').format(DateTime.now()),
              userName:
                  "${greeting.tr}, ${PrefService.getString(PrefKey.name).toString()}",
            ));
          });
        }
      },
    );
  }


  Future<void> _onLongPressEnd(LongPressEndDetails details) async {
    await welcomeHomeController.pause();
    await welcomeHomeController.audioPlayer.stop();

    _lottieController.stop();
    if (_isLongPressed) {
      setState(() {
        _showText = false;
        _stopE = true;

      });
      _controller.reverse();
    }
    _isLongPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return Scaffold(
      body: Stack(
        children: [
          backImage(),
          SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, right: 27),
                    child: GestureDetector(
                        onTap: () async {
                          await welcomeHomeController.pause();
                          await welcomeHomeController.audioPlayer.stop();
                          await updateApi(context,pKey: "welcomeScreen");

                          Get.offAll(MotivationalMessageScreen(
                            skip: true,
                            date: DateFormat('d MMMM yyyy')
                                .format(DateTime.now()),
                            userName:
                                "${greeting.tr}, ${PrefService.getString(PrefKey.name).toString()}",
                          ));
                        },
                        child: Text(
                          _showText ? "" : "skip".tr,
                          style: Style.nunRegular(color: ColorConstant.white),
                        )),
                  ),
                ),
                Dimens.d100.h.spaceHeight,
                Text(
                  _showText
                      ? ""
                      : DateFormat('d MMMM yyyy').format(DateTime.now()),
                  style: Style.nunRegular(
                      fontSize: 16, color: ColorConstant.white),
                ),
                Dimens.d15.h.spaceHeight,
                Text(
                  _showText
                      ? ""
                      : "${greeting.tr}, ${PrefService.getString(PrefKey.name).toString()}",
                  textAlign: TextAlign.center,
                  style: Style.nunRegular(
                      fontSize: 28, color: ColorConstant.white),
                ),
                Dimens.d90.h.spaceHeight,
                GestureDetector(
                    onTap: _onTap,
                    onLongPress: _onLongPress,
                    onLongPressEnd: _onLongPressEnd,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Lottie.asset(
                          controller: _lottieController,
                          ImageConstant.rippleEffect,
                          fit: BoxFit.fill,
                          height: Dimens.d190,
                          width: Dimens.d190,
                          repeat: false,
                        ),
                        Lottie.asset(
                          ImageConstant.rippleE,
                          fit: BoxFit.fill,
                          height: Dimens.d190,
                          width: Dimens.d190,
                          repeat: _stopE,
                        ),
                        Image.asset(
                          ImageConstant.welcomeLogo,
                          height: Dimens.d190,
                          width: Dimens.d190,
                        ),
                      ],
                    )),
                Dimens.d120.h.spaceHeight,
                Text(
                  _showText ? "" : "pressHold".tr,
                  style: Style.nunMedium(
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.white,
                      fontSize: 26),
                ),
                Dimens.d23.h.spaceHeight,
                Text(
                  _showText ? "" : "TransformYourMind",
                  style: Style.nunLight(
                          fontWeight: FontWeight.w700,
                      color: ColorConstant.white,
                          fontSize: 16)
                      .copyWith(letterSpacing: 1),
                ),
                Dimens.d46.h.spaceHeight,
              ],
            ),
          ),
          _showText
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 140),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Text(
                          'takeDeepBreath'.tr,
                          style: TextStyle(
                            fontSize: 24,
                            color: _animation.value,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget backImage() {
    return Image.asset(
      ImageConstant.welcomeBack,
      height: Get.height,
      width: Get.width,
      fit: BoxFit.fill,
    );
  }
}
