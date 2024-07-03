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
import 'package:transform_your_mind/presentation/breath_screen/notice_how_you_feel_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class BreathScreen extends StatefulWidget {
   bool? skip = false;
   bool? setting = false;
   BreathScreen({super.key,this.skip,this.setting});

  @override
  State<BreathScreen> createState() => _BreathScreenState();
}

class _BreathScreenState extends State<BreathScreen> with TickerProviderStateMixin{

  late final AnimationController  _lottieController;
  bool isPlaying = false;
  int playCount = 0;
  Timer? _timer;

  @override
  void initState() {
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Adjust the duration as needed
    );    super.initState();
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
    });
    _lottieController.forward();

    _timer = Timer(const Duration(seconds: 19), () {
      setState(() {
        isPlaying = false;
        playCount++;
      });
      if (playCount < 3) {
        _startAnimationSequence();
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NoticeHowYouFeelScreen(notice:widget.skip,setting: widget.setting,);
        },)).then((value) {
        setState(() {
         playCount = 0;
         _timer;
         isPlaying = false;
         _lottieController.reset();
         _lottieController.stop();
       });
        },);
      }
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
 ThemeController themeController  = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    //statusBarSet(themeController);
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "breathTraining".tr,
        action: widget.skip!?
        GestureDetector(
            onTap: () async {
               Get.toNamed(AppRoutes.selectYourFocusPage);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                "skip".tr,
                style: Style.montserratRegular(
                    fontSize: Dimens.d15, color: themeController.isDarkMode.isTrue?ColorConstant.white:ColorConstant.black),
              ),
            )):const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Dimens.d30.spaceHeight,
            Lottie.asset(
              ImageConstant.breathInhale,
              height: 212,
              width: 212,
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
            Dimens.d20.spaceHeight,
            GestureDetector(onTap: () {
              if (!isPlaying) {
                _startAnimationSequence();
              }

            },child: SvgPicture.asset(isPlaying?ImageConstant.breathPause:ImageConstant.breathPlay)),
            Dimens.d20.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d35),
              child: Text(
                "breathingMeditation".tr,
                textAlign: TextAlign.center,
                style: Style.montserratRegular(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Dimens.d20.spaceHeight,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d36),
              child: Text(
                "breatheNote".tr,
                textAlign: TextAlign.center,
                style: Style.montserratRegular(height: 2,
                    fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            Dimens.d30.spaceHeight,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color:  themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor:ColorConstant.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("In",
                          style: Style.montserratRegular(
                            fontSize: 16,
                          )),
                      const Spacer(),
                      Text("4sec".tr,
                          style: Style.montserratRegular(
                              fontSize: 16, color: ColorConstant.colorA49F9F)),
                    ],
                  ),
                  Dimens.d10.spaceHeight,
                  Row(
                    children: [
                      Text("out".tr,
                          style: Style.montserratRegular(
                            fontSize: 16,
                          )),
                      const Spacer(),
                      Text("4sec".tr,
                          style: Style.montserratRegular(
                              fontSize: 16, color: ColorConstant.colorA49F9F)),
                    ],
                  ),
                  Dimens.d10.spaceHeight,
                  Row(
                    children: [
                      Text("hold".tr,
                          style: Style.montserratRegular(fontSize: 16)),
                      const Spacer(),
                      Text("4sec".tr,
                          style: Style.montserratRegular(
                              fontSize: 16, color: ColorConstant.colorA49F9F)),
                    ],
                  ),
                ],
              ),
            ),
            Dimens.d30.spaceHeight,
            GestureDetector(onLongPress: () {
              _triggerSOS(context);
            },child: SvgPicture.asset(ImageConstant.sos,height: 86,width: 86,)),
            Dimens.d30.spaceHeight,

          ],
        ),
      ),
    );
  }
}
