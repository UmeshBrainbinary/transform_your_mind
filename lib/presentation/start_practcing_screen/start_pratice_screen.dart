import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/gratitude_model.dart';
import 'package:transform_your_mind/presentation/start_practcing_screen/greate_work.dart';
import 'package:transform_your_mind/presentation/start_practcing_screen/start_pratice_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:volume_controller/volume_controller.dart';

class StartPracticeScreen extends StatefulWidget {
  List<GratitudeData>? gratitudeList;
   StartPracticeScreen({super.key,this.gratitudeList});

  @override
  State<StartPracticeScreen> createState() => _StartPracticeScreenState();
}

class _StartPracticeScreenState extends State<StartPracticeScreen>
    with TickerProviderStateMixin {
  StartPracticeController startC = Get.put(StartPracticeController());
  double _setVolumeValue = 0;
  Timer? _autoScrollTimer;

  int currentIndex = 1;
  int chooseImage = 0;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  double _progress = 0.0;
  int selectedTime = 3;
  bool showBottom = false;
  bool isAlreadyBack = false;
  bool isPro = false;
  AnimationController? _progressController;
  Animation<double>? _progressAnimation;
  @override
  void initState() {
    super.initState();
    startC.selectedSpeedIndex = 0;
    startC.setSpeed = false.obs;

    startC.storyCompleted = List.generate(widget.gratitudeList!.length, (index) => false);
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: speedChange()),
    )..addListener(() {
        setState(() {
          _progress = _progressController!.value;
        });
      });

    _progressAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_progressController!);

    _startAutoScrollTimer();
    VolumeController().listener((volume) {
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    setBackSounds();
  }
  setBackSounds() async {
    startC.soundMute = false;
    try {
      await startC.setUrl(startC.soundList[1]["audio"]);
      await startC.play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void _startProgressAnimation() {
    _progressController?.reset();
    _progressController?.forward();
  }

  @override
  void dispose() {
    startC.timer?.cancel();
    super.dispose();
  }

/*  void _startProgress() {
    _timer?.cancel();
    int durationInSeconds = speedChange();
    int durationInMilliseconds = durationInSeconds * 1000;
    int intervalInMilliseconds = 80;

    _timer =
        Timer.periodic(Duration(milliseconds: intervalInMilliseconds), (timer) {
      setState(() {
        _progress += 1.0 / (durationInMilliseconds / intervalInMilliseconds);
        if (_progress >= 1.0) {
          _progress = 0.0;
          _currentIndex++;
          if (_currentIndex >= widget.gratitudeList!.length) {
            _timer!.cancel();
            if(widget.gratitudeList!.length==1) {
              startC.pause();
               updateGratitude(widget.gratitudeList![0].id);

              Get.to(()=> GreatWork(theme: startC.themeList[chooseImage],));
            }
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
  }*/

  void _startAutoScrollTimer() {
    _autoScrollTimer?.cancel();
    _startProgressAnimation();// Cancel any existing timer
    _autoScrollTimer = Timer.periodic( Duration(seconds: speedChange()), (timer) {
      if(isPro) {
        if (_currentIndex < widget.gratitudeList!.length - 1) {
          _currentIndex++;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          if (_progress == 1.0) {
            timer.cancel();


            _onComplete(); // Handle completion

          }
          // Stop the timer
        }
      }

      else {
        if (_currentIndex < widget.gratitudeList!.length - 1) {
          _currentIndex++;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          timer.cancel();


          _onComplete(); // Handle completion

        }
      }
    });
  }

  void _onComplete() async {
    await updateGratitude(widget.gratitudeList![0].id);
    if(isAlreadyBack ==false) {

    Get.to(() => GreatWork(theme: startC.themeList[chooseImage]));
    }
  }
  updateGratitude(id) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'POST', Uri.parse('${EndPoints.baseUrl}update-gratitude?id=$id'));
    request.body = json.encode({
      "isCompleted":true,
      "created_by":PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {

    } else {



    }

  }

  int speedChange() {
    switch (startC.selectedSpeedIndex) {
      case 0:
        return 5;
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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return WillPopScope( onWillPop: () async {
      await startC.pause();
      setState(() {
        isAlreadyBack =true;
        _progressController?.stop();
        _progressController?.dispose();
        _autoScrollTimer?.cancel();
      });
      return true;
    },
      child: Scaffold(
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
                  children: List.generate(widget.gratitudeList!.length, (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: LinearProgressIndicator(
                          value: index == _currentIndex
                              ? _progressAnimation?.value
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
                itemCount: widget.gratitudeList!.length,
                controller: _pageController,
                onPageChanged: (value) async {
                  await updateGratitude([widget.gratitudeList![value].id]);

                  setState(() {
                    _currentIndex = value;
                    _progress = 0.0;
                    _startProgressAnimation(); // Restart animation

                    _startAutoScrollTimer(); // Restart timer
                  });
                },
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding:  const EdgeInsets.symmetric(horizontal: 40),
                          child: Text("“ ${widget.gratitudeList?[index].description} ”",maxLines: 7,
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
                  onTap: () async {
                    await startC.pause();
                    _progressController?.stop();
                    _progressController?.dispose();
                    _autoScrollTimer?.cancel();
                    setState(() {
                      isAlreadyBack =true;
                    });
                    Get.back();

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
                              isPro = true;
                            });
                            _progressController?.stop();
                            sheetSound().then((v){
                                                   _progressController?.forward();

                            });
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
                              fontSize: 12, color: Colors.white),
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
                              isPro = true;
                            });
                            _progressController?.stop();
                            sheetTheme().then((v){
                              _progressController?.forward();

                            });
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
                              fontSize: 14, color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),

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
                                    _startAutoScrollTimer();
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
                                            fontSize: 12,
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
                            startC.audioPlayer.setVolume(0);
                          } else {
                            startC.audioPlayer.setVolume(1);
                          }
                          setState(() {

                          });
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
                        itemCount: startC.soundList.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              setState.call(() {
                                currentIndex = index;
                              });
                              await startC.audioPlayer
                                  .setAsset(startC.soundList[index]["audio"]);
                              await startC.play();

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
                                          startC.soundList[index]["title"],
                                          textAlign: TextAlign.center,
                                          style: Style.nunRegular(
                                              fontSize: 14,
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
                        itemCount: startC.themeList.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              chooseImage = index;

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
}
