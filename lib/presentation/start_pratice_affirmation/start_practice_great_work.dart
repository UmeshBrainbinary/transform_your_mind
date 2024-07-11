import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_practice_affirmation_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';

class AffirmationGreatWork extends StatefulWidget {
  const AffirmationGreatWork({super.key});

  @override
  State<AffirmationGreatWork> createState() => _AffirmationGreatWorkState();
}

class _AffirmationGreatWorkState extends State<AffirmationGreatWork> {
  StartPracticeAffirmationController startController =
      Get.put(StartPracticeAffirmationController());
  late ConfettiController _controllerCenter;
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  late ConfettiController _controllerTopCenter;
  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    _controllerCenter.play();

    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: ConfettiWidget(
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.yellow,
          Colors.red,
        ],
        confettiController: _controllerCenter,
        child: GestureDetector(
          onTap: () {},
          child: Stack(
            children: [
              //_________________________________ background Image _______________________
              Stack(
                children: [
                  CachedNetworkImage(
                    height: Get.height,
                    width: Get.width,
                    imageUrl:
                        "https://transformyourmind.s3.eu-north-1.amazonaws.com/1719464225736-Rectangle 5781.png",
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

              //_________________________________ close button  _______________________

              Positioned(
                top: Dimens.d70,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.back();
                  },
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: ColorConstant.white.withOpacity(0.15)),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              //_________________________________ theme Change button  _______________________

              Positioned(
                  top: Dimens.d140,
                  left: 16,
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        "greatWork".tr,
                        style: Style.gothamLight(
                            fontSize: 30, color: ColorConstant.white),
                      )),
                      Dimens.d20.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "YouCompleted".tr,
                          textAlign: TextAlign.center,
                          style: Style.gothamLight(
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              color: ColorConstant.white),
                        ),
                      ),
                      Dimens.d50.spaceHeight,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 27, vertical: 10),
                        decoration: BoxDecoration(
                            color: ColorConstant.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                commonText("totalSessions".tr),
                                Dimens.d6.spaceHeight,
                                commonTextTitle("10".tr),
                              ],
                            ),
                            Dimens.d32.spaceWidth,
                            Container(
                              width: 1,
                              height: 47,
                              color: ColorConstant.white,
                            ),
                            Dimens.d32.spaceWidth,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                commonText("gratitude".tr),
                                Dimens.d6.spaceHeight,
                                commonTextTitle("10".tr),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Dimens.d40.spaceHeight,
                      Container(
                        width: 300,
                        height: 1,
                        color: ColorConstant.white,
                      ),
                      Dimens.d60.spaceHeight,
                    ],
                  )),
              Positioned(
                  bottom: Dimens.d140,
                  left: 16,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: 120,
                      width: Get.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: startController.weekList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              children: [
                                startController.currentDayIndex == index + 1
                                    ? Container(
                                        height: 30,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: const Center(
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white)),
                                      ),
                                Dimens.d6.spaceHeight,
                                Text(
                                  startController.weekList[index],
                                  style: Style.montserratRegular(
                                      fontSize: 14, color: ColorConstant.white),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ), // Your widget here
      ),
    );
  }

  commonText(text) {
    return Text(
      text,
      style: Style.montserratRegular(
          fontSize: 14, color: ColorConstant.white.withOpacity(0.5)),
    );
  }

  commonTextTitle(text) {
    return Text(
      text,
      style: Style.montserratRegular(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: ColorConstant.white),
    );
  }
}
