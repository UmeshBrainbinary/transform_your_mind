import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:volume_controller/volume_controller.dart';
import 'dart:math' as math;
class PositiveStoryMoment extends StatefulWidget {
  const PositiveStoryMoment({super.key});

  @override
  State<PositiveStoryMoment> createState() => _PositiveStoryMomentState();
}

class _PositiveStoryMomentState extends State<PositiveStoryMoment> {
  ThemeController themeController = Get.find<ThemeController>();
  PositiveController positiveController =
  Get.put(PositiveController());
  double _setVolumeValue = 0;
  Timer? _timer;

  ScreenshotController screenshotController = ScreenshotController();
  int chooseImage = 0;
  bool showBottom = false;
  int currentIndex = 1;
  PageController _pageController = PageController();

  double _progress = 0.0;
  int _currentIndex = 0;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    setBackSounds();

    _startProgress();
    VolumeController().listener((volume) {});
    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  setBackSounds() async {
    positiveController.soundMute = false;
    try {
      await positiveController
          .setUrl(positiveController.soundList[1]["audio"]);
      await positiveController.play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }





  @override
  void dispose() {
    positiveController.timer?.cancel();
    super.dispose();
  }

  int speedChange() {
    switch (positiveController.selectedSpeedIndex) {
      case 0:
        return 5;
      default:
        return 5;
    }
  }

  void _startProgress() {
    _timer?.cancel(); // Cancel any existing timer
    int durationInSeconds = speedChange();
    int durationInMilliseconds = durationInSeconds * 1000;
    int intervalInMilliseconds = 30;

    _timer =
        Timer.periodic(Duration(milliseconds: intervalInMilliseconds), (timer) {
          _progress += 1.0 / (durationInMilliseconds / intervalInMilliseconds);
          if (_progress >= 1.0) {
            _progress = 0.0;
            _currentIndex++;
            if (_currentIndex >=
                positiveController.filteredBookmarks!.length) {
              _timer!.cancel();
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
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return WillPopScope(onWillPop: () async {
      await positiveController.pause();

      return true;
    },
      child: Stack(
        children: [
          Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                //_________________________________ background Image _______________________
                Stack(
                  children: [
                    GetBuilder<PositiveController>(
                      builder: (controller) => CachedNetworkImage(
                        height: Get.height,
                        width: Get.width,
                        imageUrl: positiveController.themeList[chooseImage],
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
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
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
                    children: List.generate(positiveController.filteredBookmarks!.length, (index) {
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
                  itemCount:
                  positiveController.filteredBookmarks?.length ?? 0,
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentIndex = value;
                      _progress = 0.0;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 48, right: 48, top: 40),
                        child: Text(
                            "“${positiveController.filteredBookmarks![index]["des"]}”" ??
                                "",
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            style: Style.gothamLight(
                                fontSize: 23,
                                color: ColorConstant.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),
                //_________________________________ close button  _______________________

                Positioned(
                  top: Dimens.d70,
                  left: 16,
                  child: GestureDetector(
                    onTap: () async {
                      await positiveController.pause();

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


              ],
            ),
          ),
          Obx(
                () => positiveController.loader.isTrue
                ? commonLoader()
                : const SizedBox(),
          )
        ],
      ),
    );
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: ColorConstant.black.withOpacity(0.2)),
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
                        style: Style.nunMedium(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.white)),
                    Dimens.d20.spaceHeight,
                    Expanded(
                      child: ListView.builder(
                        itemCount: positiveController.soundList.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              setState.call(() {
                                currentIndex = index;
                              });
                              await positiveController.audioPlayer.setUrl(
                                  positiveController.soundList[index]
                                  ["audio"]);
                              await positiveController.play();

                            },
                            child: positiveController.soundList[index]
                            ["title"] ==
                                "None"
                                ? Container(
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
                                  horizontal: 3.0),
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
                                    positiveController
                                        .soundList[index]["title"],
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
                                    positiveController
                                        .soundList[index]["title"],
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
                    Dimens.d20.spaceHeight,
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          ImageConstant.soundLow,
                          color: ColorConstant.white,
                        ),
                        ValueListenableBuilder(
                          valueListenable: positiveController.slideValue,
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
                  ],
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: ColorConstant.black.withOpacity(0.2)),
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
                        itemCount: positiveController.themeList.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              chooseImage = index;
                              setState.call(() {});

                              setState(() {});
                              positiveController.update();
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
                                imageUrl:
                                positiveController.themeList[index],
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
            );
          },
        );
      },
    ).whenComplete(
          () => setState(() {
        showBottom = false;
      }),
    );
  }
  void shareScreenShot() {
    // invoking capture on screenshotController
    screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((capturedImage) async {
      try {
        final documentDirectory = await getApplicationDocumentsDirectory();
        String filePathAndName =
            '${documentDirectory.path}/${'transform'}${math.Random().nextInt(1000)}_shoorah.png';
        File imgFile = File(filePathAndName);
        await imgFile.writeAsBytes(capturedImage!);
        ShareResult res = await Share.shareXFiles([XFile(imgFile.path)]);

        if (res.status == ShareResultStatus.success) {

        }
      } catch (e) {
      }
    }).catchError((onError) {
    });
  }

}
