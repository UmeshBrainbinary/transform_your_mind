import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/audio_list.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_practice_affirmation_controller.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_practice_great_work.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:volume_controller/volume_controller.dart';

class StartPracticeAffirmation extends StatefulWidget {
  const StartPracticeAffirmation({super.key});

  @override
  State<StartPracticeAffirmation> createState() =>
      _StartPracticeAffirmationState();
}

class _StartPracticeAffirmationState extends State<StartPracticeAffirmation>
    with TickerProviderStateMixin {
  StartPracticeAffirmationController startC =
      Get.put(StartPracticeAffirmationController());
  double _setVolumeValue = 0;
  double _volumeListenerValue = 0;
  int currentIndex = 0;
  int chooseImage = 0;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  double _progress = 0.0;
  Timer? _timer;
  int selectedTime = 3;
  bool am = true;
  bool pm = false;
  Duration selectedDuration = const Duration(hours: 0, minutes: 0, seconds: 0);
  int selectedHour = 0;
  int selectedHourIndex = 0;
  int selectedMinute = 0;
  int selectedSeconds = 0;

  @override
  void initState() {
    super.initState();
    startC.selectedSpeedIndex = 0;
    startC.setSpeed = false.obs;

    startC.storyCompleted = List.generate(startC.quotes.length,
        (index) => false); // Initialize all stories as not completed

    _startProgress();
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    setBackSounds();
  }
  setBackSounds() async {
    startC.soundMute = false;
    startC.player.setVolume(1);
    await startC.player
        .setUrl(startC.soundList[0]["audio"]);
    await startC.player.play();
  }
  @override
  void dispose() {
    startC.timer.cancel();
    super.dispose();
  }

  void _startProgress() {
    _timer?.cancel(); // Cancel any existing timer
    int durationInSeconds = speedChange();
    int durationInMilliseconds = durationInSeconds * 1000;
    int intervalInMilliseconds = 30;

    _timer =
        Timer.periodic(Duration(milliseconds: intervalInMilliseconds), (timer) {
      setState(() {
        _progress += 1.0 / (durationInMilliseconds / intervalInMilliseconds);
        if (_progress >= 1.0) {
          _progress = 0.0;
          _currentIndex++;
          if (_currentIndex >= startC.quotes.length) {
            _timer!.cancel();
          } else {
            _pageController.animateToPage(
              _currentIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          }
        }
      });
    });
  }

  int speedChange() {
    switch (startC.selectedSpeedIndex) {
      case 0:
        return 3;
      case 1:
        return 20;
      case 2:
        return 15;
      case 3:
        return 10;
      case 4:
        return 5;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: GestureDetector(
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
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(startC.quotes.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: LinearProgressIndicator(
                        value: index == _currentIndex
                            ? _progress
                            : (index < _currentIndex ? 1.0 : 0.0),
                        backgroundColor: Colors.grey,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            //_________________________________ story list  _______________________

            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: startC.quotes.length,
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                  _progress = 0.0;
                });
                if (_currentIndex == (startC.quotes.length - 1)) {
                  Future.delayed(Duration(seconds: speedChange())).then(
                    (value) => Get.to(const AffirmationGreatWork()),
                  );
                }
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Dimens.d220.spaceHeight,
                    Text(
                      "Self-esteem",
                      style: Style.gothamMedium(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.white),
                    ),
                    Dimens.d20.spaceHeight,
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Text(startC.quotes[index],
                            maxLines: 5,
                            textAlign: TextAlign.center,
                            style: Style.gothamLight(
                                fontSize: 23,
                                color: ColorConstant.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                );
              },
            ),
            //_________________________________ close button  _______________________

            Positioned(
              top: Dimens.d70,
              left: 16,
              child: GestureDetector(
                onTap: () {
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
              top: Dimens.d70,
              right: 16,
              child: Row(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          sheetSound();
                        },
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: ColorConstant.white.withOpacity(0.15)),
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
                          sheetTheme();
                        },
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: ColorConstant.white.withOpacity(0.15)),
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
            Positioned(
                bottom: Dimens.d246,
                left: MediaQuery.of(context).size.width / 3.2,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(ImageConstant.share,
                          color: ColorConstant.white, height: 20, width: 20),
                    ),
                    Dimens.d40.spaceWidth,
                    GestureDetector(
                      onTap: () {
                        sheetAlarm();
                      },
                      child: SvgPicture.asset(ImageConstant.alarm,
                          color: ColorConstant.white, height: 20, width: 20),
                    ),
                    Dimens.d40.spaceWidth,
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        ImageConstant.likeTools,
                        color: ColorConstant.white,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                )),

            //_________________________________ Skip Method  _______________________

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
                            bool isChecked = startC.selectedSpeedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  startC.setSelectedSpeedIndex(index);
                                  speedChange();
                                  _progress = 0.0; // Reset the progress.
                                  _startProgress();
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
                                      style: Style.montserratRegular(
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

            Positioned(
              bottom: Dimens.d85,
              left: MediaQuery.of(context).size.width / 5,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
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
                          startC.audioPlayer.setVolume(0);
                        } else {
                          startC.audioPlayer.setVolume(1);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          startC.setSpeed.value = !startC.setSpeed.value;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
          ],
        ),
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

  Future sheetSound() {
    return showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: SizedBox(
                    height: 280,
                    width: Get.width,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      color: ColorConstant.black.withOpacity(0.3)),
                  height: 280,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            style: Style.montserratRegular(
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
                                  await startC.player
                                      .setUrl(startC.soundList[index]["audio"]);
                                  await startC.player.play();
                                  setState.call(() {
                                    currentIndex = index;
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: currentIndex == index
                                          ? Colors.black.withOpacity(0.5)
                                          : ColorConstant.white
                                              .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15),
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
                                        borderRadius: BorderRadius.circular(80),
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
                                        style: Style.montserratRegular(
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
                        Dimens.d20.spaceHeight,
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              ImageConstant.soundMax,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
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
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: SizedBox(
                    height: 200,
                    width: Get.width,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      color: ColorConstant.black.withOpacity(0.3)),
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                      color: chooseImage == index
                                          ? Colors.black.withOpacity(0.5)
                                          : ColorConstant.white
                                              .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: chooseImage == index
                                              ? ColorConstant.white
                                              : Colors.transparent)),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
                                    placeholder: (context, url) =>
                                        PlaceHolderCNI(
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
              ],
            );
          },
        );
      },
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
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: SizedBox(
                    height: 400,
                    width: Get.width,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      color: ColorConstant.black.withOpacity(0.4)),
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        Dimens.d18.spaceHeight,
                        Row(
                          children: [
                            Text(
                              "newAlarms".tr,
                              style: Style.montserratRegular(
                                  fontSize: 20, color: ColorConstant.white),
                            ),
                            const Spacer(),
                            Container(
                              height: 26,
                              width: Dimens.d100,
                              decoration: BoxDecoration(
                                  color: ColorConstant.white,
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(
                                      color: ColorConstant.colorBFBFBF)),
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
                                            color: am == true
                                                ? ColorConstant.themeColor
                                                : ColorConstant.white,
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        child: Center(
                                          child: Text(
                                            "AM",
                                            style: Style.montserratRegular(
                                                fontSize: 12,
                                                color: am == true
                                                    ? ColorConstant.white
                                                    : ColorConstant.black),
                                          ),
                                        )),
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
                                            color: pm == true
                                                ? ColorConstant.themeColor
                                                : ColorConstant.white,
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        child: Center(
                                          child: Text(
                                            "PM",
                                            style: Style.montserratRegular(
                                                fontSize: 12,
                                                color: pm == true
                                                    ? ColorConstant.white
                                                    : ColorConstant.black),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Dimens.d10.spaceHeight,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            commonTextA(
                              "hours".tr,
                            ),
                            commonTextA(
                              "minutes".tr,
                            ),
                            commonTextA(
                              "seconds".tr,
                            ),
                          ],
                        ),
                        Dimens.d10.spaceHeight,
                        Row(
                          children: [
                            NumberPicker(
                              zeroPad: true,
                              value: selectedHour,
                              minValue: 0,
                              textStyle: Style.montserratRegular(
                                  fontSize: 14,
                                  color: ColorConstant.colorCACACA),
                              selectedTextStyle: Style.montserratBold(
                                  fontSize: 22,
                                  color: ColorConstant.themeColor),
                              maxValue: 24,
                              itemHeight: 50,
                              itemWidth: 50,
                              onChanged: (value) =>
                                  setState(() => selectedHour = value),
                            ),
                            const Spacer(),
                            numericSymbol(),
                            const Spacer(),
                            NumberPicker(
                              zeroPad: true,
                              value: selectedMinute,
                              minValue: 0,
                              itemHeight: 50,
                              itemWidth: 50,
                              textStyle: Style.montserratRegular(
                                  fontSize: 14,
                                  color: ColorConstant.colorCACACA),
                              selectedTextStyle: Style.montserratBold(
                                  fontSize: 22,
                                  color: ColorConstant.themeColor),
                              maxValue: 60,
                              onChanged: (value) =>
                                  setState(() => selectedMinute = value),
                            ),
                            const Spacer(),
                            numericSymbol(),
                            const Spacer(),
                            NumberPicker(
                              zeroPad: true,
                              value: selectedSeconds,
                              minValue: 0,
                              itemHeight: 50,
                              itemWidth: 50,
                              textStyle: Style.montserratRegular(
                                  fontSize: 14,
                                  color: ColorConstant.colorCACACA),
                              selectedTextStyle: Style.montserratBold(
                                  fontSize: 22,
                                  color: ColorConstant.themeColor),
                              maxValue: 60,
                              onChanged: (value) =>
                                  setState(() => selectedSeconds = value),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const AudioList();
                              },
                            ));
                          },
                          child: Container(
                            height: Dimens.d51,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: ColorConstant.backGround,
                                borderRadius: BorderRadius.circular(6)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Dimens.d14.spaceWidth,
                                Text(
                                  "sound".tr,
                                  style: Style.montserratRegular(fontSize: 14),
                                ),
                                const Spacer(),
                                Text(
                                  "default".tr,
                                  style: Style.montserratRegular(
                                      fontSize: 14,
                                      color: ColorConstant.color787878),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: Dimens.d70.h),
                          child: CommonElevatedButton(
                            textStyle: Style.montserratRegular(
                                fontSize: Dimens.d12,
                                color: ColorConstant.white),
                            title: "save".tr,
                            onTap: () async {
                              /*      await notificationSettingController.editAffirmation(
                                  context: context,
                                  id: id,
                                  seconds: selectedSeconds,
                                  minutes: selectedMinute,
                                  hours: selectedHour,
                                  time: am==true?"AM":"PM");
                              await notificationSettingController.getAffirmationAlarm();*/
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget commonTextA(title) {
    return Text(
      title,
      style: Style.montserratRegular(fontSize: 12, color: Colors.white),
    );
  }

  Widget numericSymbol() {
    return Text(":",
        style: Style.montserratBold(
            fontSize: 22, color: ColorConstant.themeColor));
  }
}
