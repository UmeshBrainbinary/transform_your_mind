import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_motivational.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_stress.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feeling_today_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feelings_evening.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/motivational_questions.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/sleep_questions.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/stress_questions.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_controller.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:volume_controller/volume_controller.dart';

class MotivationalMessageScreen extends StatefulWidget {
  bool? skip, back, like;
  String? userName, date, data, id;

  MotivationalMessageScreen({super.key,
    this.skip = false,
    this.userName = "",
    this.date = "",
    this.data = "",
    this.id = "",
    this.back = false,
    this.like = false});

  @override
  State<MotivationalMessageScreen> createState() => _MotivationalMessageScreenState();
}

class _MotivationalMessageScreenState extends State<MotivationalMessageScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  LoginController loginController = Get.put(LoginController());
  MotivationalController motivationalController =
  Get.put(MotivationalController());
  double _setVolumeValue = 0;
  Timer? _timer;
  ScreenshotController screenshotController = ScreenshotController();
  int chooseImage = 0;
  bool showBottom = false;
  int currentIndex = 1;
  PageController _pageController = PageController();
  String greeting = "";
  double _progress = 0.0;
  int _currentIndex = 0;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    _setGreetingBasedOnTime();
    soundPlay();
    _startProgress();
    VolumeController().listener((volume) {});
    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    if (widget.data!.isNotEmpty) {
      setState(() {
        motivationalController.like.add(widget.like!);
      });
    }
  }
  Future<void> soundPlay() async {
    motivationalController.soundMute = false;
    try {
      await motivationalController.setUrl(motivationalController.soundList[1]["audio"]);
      await motivationalController.play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
   setState(() {

   });
  }
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

  String currentLanguage = PrefService.getString(PrefKey.language);

  addLike({String? id, bool? isLiked}) async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));

    request.fields
        .addAll({'isLikeMotivationalMessage': "$isLiked", 'messageId': "$id"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      setState(() {});
    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void dispose() {
    motivationalController.timer?.cancel();
    super.dispose();
  }

  int speedChange() {
    switch (motivationalController.selectedSpeedIndex) {
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
            motivationalController.motivationalModel.data!.length) {
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
  bool likeAnimation = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return WillPopScope(onWillPop: () async {
      await motivationalController.pause();

      return true;
    },
      child: Stack(
        children: [
          Scaffold(
            floatingActionButton: GetBuilder<MotivationalController>(
              builder: (controller) {
                return widget.data!.isEmpty
                    ? GestureDetector(
                        onTap: () async {
                          controller.allFavList.value = !controller.allFavList.value;
                    controller.update();
                    if (controller.allFavList.isTrue) {
                      _pageController = PageController();
                      _progress = 0.0;
                      _currentIndex = 0;
                      _startProgress();

                      await controller.getLikeList(context);
                    } else {
                      await controller.getMotivational();
                    }
                    controller.update();
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20, right: 2),
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                        color: ColorConstant.themeColor,
                        borderRadius: BorderRadius.circular(9)),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: controller.allFavList.isTrue
                            ? ColorConstant.deleteRed
                            : ColorConstant.white,
                        size: 20,
                      ),
                    ),
                  ),
                      )
                    : const SizedBox();
              },
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [

                //_________________________________ background Image _______________________
                Stack(
                  children: [
                    GetBuilder<MotivationalController>(
                      builder: (controller) =>
                          Container(
                            height: Get.height,
                            width: Get.width,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                              image: DecorationImage(
                                image: AssetImage(motivationalController.themeList[chooseImage]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                       /*   CachedNetworkImage(
                        height: Get.height,
                        width: Get.width,
                        imageUrl: motivationalController.themeList[chooseImage],
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
                      ),*/
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

                //_________________________________ story list  _______________________
                PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.data!.isEmpty
                      ? motivationalController.motivationalModel.data?.length ??
                          0
                      : 1,
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentIndex = value;
                      motivationalController.likeIndex = value;
                      _progress = 0.0;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: widget.data!.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 48, right: 48, top: 40),
                              child: currentLanguage != "en-US"
                                  ? Text(
                                      "“${motivationalController.motivationalModel.data![index].gMessage}”" ??
                                          "",
                                      textAlign: TextAlign.center,
                                      maxLines: 5,
                                      style: Style.gothamLight(
                                          fontSize: 23,
                                          color: ColorConstant.white,
                                          fontWeight: FontWeight.w600))
                                  : Text(
                                      "“${motivationalController.motivationalModel.data![index].message}”" ??
                                          "",
                                      textAlign: TextAlign.center,
                                      maxLines: 5,
                            style: Style.gothamLight(
                                fontSize: 23,
                                color: ColorConstant.white,
                                fontWeight: FontWeight.w600)),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 48, right: 48, top: 40),
                              child: Text("“${widget.data ?? ""}”",
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
                //_________________________________ like motivational message _____________________
                Positioned(
                    bottom: Dimens.d220.h,
                    child: Row(
                      children: [
                        motivationalController.like.isEmpty?const SizedBox(): GestureDetector(
                          onTap: () {
                            Share.share(motivationalController
                                    .motivationalModel
                                    .data?[motivationalController.likeIndex]
                                    .message ??
                                "");
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
                      GetBuilder<MotivationalController>(
                          builder: (controller) {
                            return   controller.like.isEmpty?const SizedBox():GestureDetector(
                              onTap: () async {

                                setState(() {
                                        controller.like[controller.likeIndex] =
                                            !controller
                                                .like[controller.likeIndex];
                                        likeAnimation = controller
                                            .like[controller.likeIndex];
                                        Future.delayed(
                                                const Duration(seconds: 2))
                                            .then(
                                          (value) {
                                            setState(() {
                                              likeAnimation = false;
                                            });
                                  },);
                                      });
                                      await addLike(
                                          id: motivationalController
                                              .motivationalModel
                                              .data?[controller.likeIndex].id,
                                    isLiked:
                                        controller.like[controller.likeIndex]);
                              },
                              child:SvgPicture.asset(
                                controller.like[controller.likeIndex]?ImageConstant.likeRedTools:ImageConstant.likeTools,
                                      color: controller.like[controller.likeIndex]?ColorConstant.deleteRed:ColorConstant.white,
                                      height: 20,
                                      width: 20,
                                    ),
                            );
                          },
                        )
                      ],
                    )),
                //_______________________________ skip method _____________________
                Positioned(
                  top: Dimens.d48,
                  left: 21,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.skip!)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width *0.75,
                                  child: Text(
                                    widget.userName ?? "",
                                    style: Style.nunitoBold(
                                        fontSize: 18, color: ColorConstant.white),
                                  ),
                                ),
                                Dimens.d4.spaceHeight,
                                Text(
                                  widget.date ?? "",
                                  style: Style.nunLight(
                                      fontSize: 14, color: ColorConstant.white),
                                ),
                              ],
                            ),
                            Dimens.d20.spaceWidth,
                            GestureDetector(
                                onTap: () async {
                                  await motivationalController.pause();

                                  if (loginController.getUserModel.data
                                          ?.morningMoodQuestions ??
                                      false == false &&
                                          greeting == "goodMorning") {
                                    Get.offAll(() =>  SleepQuestions());
                                  } else if (loginController.getUserModel.data
                                          ?.morningSleepQuestions ??
                                      false == false &&
                                          greeting == "goodMorning") {
                                    Get.offAll(() => StressQuestions());
                                  } else if (loginController.getUserModel.data
                                          ?.morningStressQuestions ??
                                      false == false &&
                                          greeting == "goodMorning") {
                                    Get.offAll(() => const HowFeelingTodayScreen());
                                  } else if (loginController.getUserModel.data
                                          ?.morningMotivationQuestions ??
                                      false == false &&
                                          greeting == "goodMorning") {
                                    Get.offAll(() => MotivationalQuestions());
                                  } else if (loginController.getUserModel.data
                                          ?.eveningMoodQuestions ??
                                      false == false &&
                                          greeting == "goodEvening") {
                                    Get.offAll(() => const HowFeelingsEvening());
                                  } else if (loginController.getUserModel.data
                                          ?.eveningStressQuestions ??
                                      false == false &&
                                          greeting == "goodEvening") {
                                    Get.offAll(() => EveningStress());
                                  } else if (loginController.getUserModel.data
                                          ?.eveningMotivationQuestions ??
                                      false == false &&
                                          greeting == "goodEvening") {
                                    Get.offAll(() => EveningMotivational());
                                  } else {
                                    await motivationalController.pause();

                                    Get.offAll(() => const DashBoardScreen());
                                    /*if((PrefService.getBool(PrefKey.isFreeUser) == false && PrefService.getBool(PrefKey.isSubscribed) == false))
                                    {
                                      Get.offAll(() =>  SubscriptionScreen(skip: true,));

                                    }
                                    else
                                    {

                                      Get.offAll(() => const DashBoardScreen());
                                    }*/
                                  }
                                },
                                child: Text(
                                  "skip".tr,
                                  style: Style.nunitoSemiBold(
                                      fontSize: 18, color: ColorConstant.white),
                                )),
                          ],
                        )
                      else
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await motivationalController.pause();

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
                            Dimens.d20.spaceWidth,
                            Text(
                              "motivationalMessages".tr,
                              style: Style.nunitoSemiBold(
                                  fontSize: 20, color: ColorConstant.white),
                            )
                          ],
                        ),
                      Dimens.d24.spaceHeight,
                      Row(
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
                    ],
                  ),
                ),
                likeAnimation==true?Center(
                  child: Image.asset(
                    ImageConstant.likeGif,
                  ),
                ):const SizedBox(),
              ],
            ),
          ),
          Obx(
            () => motivationalController.loader.isTrue
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
            return Stack(
              children: [
                Positioned(top: 600,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(),
                  ),
                ),
                Container(
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
                            itemCount: motivationalController.soundList.length,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  setState.call(() {
                                    currentIndex = index;
                                  });
                                  await motivationalController.audioPlayer.setAsset(
                                      motivationalController.soundList[index]
                                          ["audio"]);
                                  await motivationalController.play();

                                },
                                child: motivationalController.soundList[index]
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
                                              motivationalController
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
                                              motivationalController
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
                              valueListenable: motivationalController.slideValue,
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
                ),
              ],
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
            return Stack(
              children: [
                Positioned(top: 600,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(),
                  ),
                ),
                Container(
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
                            itemCount: motivationalController.themeList.length,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  chooseImage = index;
                                  setState.call(() {});

                                  setState(() {});
                                  motivationalController.update();
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
                                  child:
                                /*  CachedNetworkImage(
                                    height: 160,
                                    width: 100,

                                    imageUrl:
                                        motivationalController.themeList[index],
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
                                  ),*/
                                  Container(
                                    height: 160,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(
                                        10.0,
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            motivationalController.themeList[index]
                                        ),
                                        fit: BoxFit.cover,
                                      ),
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
