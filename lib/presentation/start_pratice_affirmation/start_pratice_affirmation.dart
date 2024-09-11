import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/affirmation_model.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/affirmation_controller.dart';
import 'package:transform_your_mind/presentation/home_screen/AlarmNotification.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/audio_list.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_practice_affirmation_controller.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_practice_great_work.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:volume_controller/volume_controller.dart';

import '../../core/utils/end_points.dart';

class StartPracticeAffirmation extends StatefulWidget {
  List<AffirmationData>? data;
  String? id;
  String? alarmId;


  StartPracticeAffirmation({super.key, this.id,this.data,this.alarmId});

  @override
  State<StartPracticeAffirmation> createState() =>
      _StartPracticeAffirmationState();
}

class _StartPracticeAffirmationState extends State<StartPracticeAffirmation>
    with TickerProviderStateMixin {
  StartPracticeAffirmationController startC =
      Get.put(StartPracticeAffirmationController());
  double _setVolumeValue = 0;
  int currentIndex = 1;
  CommonModel commonModel = CommonModel();

  int chooseImage = 0;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int likeIndex = 0;
  double _progress = 0.0;
  int selectedTime = 3;
  bool am = true;
  bool pm = false;
  Duration selectedDuration = const Duration(hours: 0, minutes: 0, seconds: 0);
  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSeconds = 0;
  List<bool> like = [];
  bool _isScrolling = true;
  AffirmationController affirmationController = Get.put(AffirmationController());
  bool likeAnimation = false;
  AnimationController? _progressController;
  Animation<double>? _progressAnimation;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    getLikeData();
    setBackSounds();
    startC.selectedSpeedIndex = 0;
    startC.setSpeed = false.obs;

    startC.storyCompleted = List.generate(widget.data!.length, (index) => false);
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: speedChange()),
    )..addListener(() {
      setState(() {
        _progress = _progressController!.value;
      });
    });

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_progressController!);
    _startAutoScrollTimer();
    VolumeController().listener((volume) {
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  getLikeData() {
    if ((widget.data ?? []).isNotEmpty) {
      for (int i = 0; i < widget.data!.length; i++) {
        like.add(widget.data?[i].isLiked ?? false);
      }
    }
    setState(() {

    });
  }

  setBackSounds() async {
    startC.soundMute = false;
    startC.player.setVolume(1);
    await startC.player.setAsset(startC.soundList[1]["audio"]);
    await startC.player.play();
  }
  void _startScrolling() {
    setState(() {
      _isScrolling = true;
    });
    _startAutoScrollTimer();
  }

  void _stopScrolling() {
    setState(() {
      _isScrolling = false;
    });
  }
  @override
  void dispose() {
    startC.timer?.cancel();
    super.dispose();
  }

  /*void _startProgress() {
    _timer?.cancel();
    int durationInSeconds = speedChange();
    int durationInMilliseconds = durationInSeconds * 1000;
    int intervalInMilliseconds = 80;

    _timer = Timer.periodic(Duration(milliseconds: intervalInMilliseconds), (timer) {
      if (!_isScrolling) {
        timer.cancel();
        return;
      }

      _progress += 1.0 / (durationInMilliseconds / intervalInMilliseconds);
      if (_progress >= 1.0) {
        _progress = 0.0;
        _currentIndex++;

        if (_currentIndex >= widget.data!.length) {
          _timer!.cancel();
          if (widget.data!.length == 1) {
            startC.player.pause();
            Get.to(AffirmationGreatWork(theme: startC.themeList[chooseImage]));
          }
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
  }*/
  void _startAutoScrollTimer() {
    _autoScrollTimer?.cancel();
    _startProgressAnimation();
    _autoScrollTimer = Timer.periodic( Duration(seconds: speedChange()), (timer) {
      if (_currentIndex < widget.data!.length - 1) {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex,
          duration:  const Duration(milliseconds:300),
          curve: Curves.easeInOut,
        );

      } else {
        timer.cancel();
        if(_progressController?.isAnimating  ?? false){

        _onComplete(); // Handle completion
        }// Stop the timer
      }
    });
  }
  void _startProgressAnimation() {
    _progressController?.reset();
    _progressController?.forward();
    _progressController?.animateTo(currentIndex.toDouble(),duration:   Duration(seconds: speedChange()),curve: Curves.easeInOut,);
  }

  void _onComplete() async {
    startC.player.pause();
    Get.to(AffirmationGreatWork(theme: startC.themeList[chooseImage]));
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

  bool loader = false;

  createAlarm(id) async {
    setState(() {
      loader == true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('POST', Uri.parse(EndPoints.addAlarm));
    request.body = json.encode({
      "hours": selectedHour,
      "minutes": selectedMinute,
      "seconds": selectedSeconds,
      "time": am == true ? "AM" : "PM",
      "affirmationId": id,
      "created_by": PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      selectedSeconds = 0;
      selectedMinute = 0;
      selectedHour = 0;
      setState(() {
        loader == false;
      });

      debugPrint(await response.stream.bytesToString());
      showSnackBarSuccess(context, "alarmSet".tr);
      Get.back();
    } else {
      selectedSeconds = 0;
      selectedMinute = 0;
      selectedHour = 0;
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message ?? "alarmAlreadySet".tr);
      Get.back();

      setState(() {
        loader == false;
      });

      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader == false;
    });
  }
int index =0;
  bool showBottom = false;
  late List<AlarmSettings> alarms;

  void _setAlarm(id) async {
    DateTime alarmTime = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,
        selectedHour,selectedMinute,selectedSeconds);
    final alarmSettings = AlarmSettings(
        id: id,
        dateTime: alarmTime,
        assetAudioPath:   index ==1?ImageConstant.bgAudio2:ImageConstant.bgAudio1,
        loopAudio: true,
        vibrate: true,
        volume: 0.2,
        androidFullScreenIntent: true,
        fadeDuration: 3.0,
        notificationTitle: 'TransformYourMind',
        notificationBody: 'TransformYourMind Alarm ringing.....',
        enableNotificationOnKill: Platform.isAndroid?Platform.isAndroid:Platform.isIOS);
    await Alarm.set(
      alarmSettings: alarmSettings,
    );
  }
  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            AlarmNotificationScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }
  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }
  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }
  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (kDebugMode) {
      print('Schedule exact alarm permission: $status.');
    }
    if (status.isDenied) {
      if (kDebugMode) {
        print('Requesting schedule exact alarm permission...');
      }
      final res = await Permission.scheduleExactAlarm.request();
      if (kDebugMode) {
        print(
            'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
      }
    }
  }

  updateAffirmationLike({String? id, bool? isLiked}) async {
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
            '${EndPoints.baseUrl}${EndPoints.updateAffirmation}$id'));

    request.fields.addAll({'isLiked': "$isLiked"});
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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return WillPopScope(onWillPop: () async{
      await startC.player.pause();

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
                  children: List.generate(widget.data!.length, (index) {
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
                itemCount: widget.data!.length,
                controller: _pageController,
                onPageChanged: (value) async {
                  setState(() {
                    _currentIndex = value;
                    likeIndex = value;
                    _startProgressAnimation(); // Restart animation

                    _startAutoScrollTimer(); //
                    _progress = 0.0;
                  });

                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Dimens.d220.spaceHeight,
                      Text(
                        widget.data?[index].name??"",
                        style: Style.gothamMedium(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.white),
                      ),
                      Dimens.d20.spaceHeight,
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45),
                          child: Text(widget.data?[index].description??"",
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
                  onTap: () async {
                    Get.back();
                    await startC.player.pause();
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
                              fontSize: 10, color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              //_____________________________ like ,clock, share________________________
              showBottom
                  ? const SizedBox()
                  : Positioned(
                      bottom: Dimens.d246,
                      left: MediaQuery.of(context).size.width / 3.2,
                  child: Row(
                    children: [
                      GestureDetector(
                            onTap: () {
                              Share.share(widget.data![_currentIndex].description.toString());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SvgPicture.asset(ImageConstant.share,
                                  color: ColorConstant.white, height: 22, width: 22),
                            ),
                      ),
                      Dimens.d40.spaceWidth,
                      GestureDetector(
                        onTap: () {
                          _stopScrolling();
                              setState(() {
                                showBottom = true;
                              });
                          _progressController?.stop();
                              sheetAlarm().then((v){
                                _progressController?.forward();
                              });
                            },
                        child: SvgPicture.asset(ImageConstant.alarm,
                            color: ColorConstant.white, height: 20, width: 20),
                      ),
                      Dimens.d40.spaceWidth,
                      GestureDetector(
                            onTap: () async {
                              like[likeIndex] = !like[likeIndex];

                              await updateAffirmationLike(
                                  isLiked: like[likeIndex],
                                  id: widget.data![likeIndex].id);

                              setState(() {
                                likeAnimation = like[likeIndex];
                                Future.delayed(const Duration(seconds: 2)).then(
                                  (value) {
                                    setState(() {
                                      likeAnimation = false;
                              });
                            },);
                          });
                        },
                        child:  SvgPicture.asset(
                          like[likeIndex]?ImageConstant.likeRedTools:ImageConstant.likeTools,
                          color: like[likeIndex]?ColorConstant.deleteRed:ColorConstant.white,
                          height: 20,
                          width: 20,
                        ),
                      )

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

              showBottom
                  ? const SizedBox()
                  : Positioned(
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
                                  startC.player.setVolume(0);
                                } else {
                                  startC.player.setVolume(1);
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
              likeAnimation==true?Center(
                child: Image.asset(
                  ImageConstant.likeGif,
                ),
              ):const SizedBox(),

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
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: ColorConstant.black.withOpacity(0.2)),
              height: 280,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 0.0,
                    sigmaY: 0.0,
                  ),
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
                                await startC.player
                                    .setAsset(startC.soundList[index]["audio"]);
                                await startC.player.play();

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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: currentIndex == index
                                                  ? ColorConstant.white
                                                  : Colors.transparent)),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                      Dimens.d20.spaceHeight,
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
                    ],
                  ),
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
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: ColorConstant.black.withOpacity(0.3)),
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 0.0,
                    sigmaY: 0.0,
                  ),
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
                Positioned(top: 600,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      color: ColorConstant.black.withOpacity(0.4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Dimens.d10.spaceHeight,
                          Center(
                            child: Container(
                              height: 4,
                              width: 40,
                              decoration: BoxDecoration(
                                color: ColorConstant.colorBCBCBC,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          Dimens.d10.spaceHeight,
                          Row(
                            children: [
                              Text(
                                "Alarm".tr,
                                style: Style.nunMedium(
                                  fontSize: 32,
                                  color: ColorConstant.white,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 26,
                                width: Dimens.d100,
                                decoration: BoxDecoration(
                                  color: ColorConstant.transparent,
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(
                                    color: ColorConstant.colorBFBFBF,
                                  ),
                                ),
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
                                          color: am
                                              ? ColorConstant.themeColor
                                              : ColorConstant.transparent,
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "AM",
                                            style: Style.nunRegular(
                                              fontSize: 12,
                                              color: am
                                                  ? ColorConstant.white
                                                  : ColorConstant.white,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                          color: pm
                                              ? ColorConstant.themeColor
                                              : ColorConstant.transparent,
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "PM",
                                            style: Style.nunRegular(
                                              fontSize: 12,
                                              color: pm
                                                  ? ColorConstant.white
                                                  : ColorConstant.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Dimens.d10.spaceHeight,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                commonTextA("hours".tr),
                                commonTextA("minutes".tr),
                                commonTextA("seconds".tr),


                              ],
                            ),
                          ),
                          Dimens.d10.spaceHeight,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: Row(
                              children: [

                                NumberPicker(
                                  infiniteLoop: true,
                                  zeroPad: true,
                                  value: selectedHour,
                                  minValue: 0,
                                  textStyle: Style.nunRegular(
                                    fontSize: 14,
                                    color: ColorConstant.colorCACACA,
                                  ),
                                  selectedTextStyle: Style.montserratBold(
                                    fontSize: 22,
                                    color: ColorConstant.themeColor,
                                  ),
                                  maxValue: am ? 12 : 24,
                                  itemHeight: 50,
                                  itemWidth: 50,
                                  onChanged: (value) =>
                                      setState(() => selectedHour = value),
                                ),
                                const Spacer(),
                                numericSymbol(),
                                const Spacer(),
                                NumberPicker(
                                  infiniteLoop: true,
                                  zeroPad: true,
                                  value: selectedMinute,
                                  minValue: 0,
                                  itemHeight: 50,
                                  itemWidth: 50,
                                  textStyle: Style.nunRegular(
                                    fontSize: 14,
                                    color: ColorConstant.colorCACACA,
                                  ),
                                  selectedTextStyle: Style.montserratBold(
                                    fontSize: 22,
                                    color: ColorConstant.themeColor,
                                  ),
                                  maxValue: 59,
                                  onChanged: (value) =>
                                      setState(() => selectedMinute = value),
                                ),
                                const Spacer(),
                                numericSymbol(),
                                const Spacer(),
                                NumberPicker(
                                  infiniteLoop: true,
                                  zeroPad: true,
                                  value: selectedSeconds,
                                  minValue: 0,
                                  itemHeight: 50,
                                  itemWidth: 50,
                                  textStyle: Style.nunRegular(
                                    fontSize: 14,
                                    color: ColorConstant.colorCACACA,
                                  ),
                                  selectedTextStyle: Style.montserratBold(
                                    fontSize: 22,
                                    color: ColorConstant.themeColor,
                                  ),
                                  maxValue: 59,
                                  onChanged: (value) =>
                                      setState(() => selectedSeconds = value),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                             index  =await Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const AudioList();
                                },
                              ));

                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              height: Dimens.d51,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: ColorConstant.backGround,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Dimens.d14.spaceWidth,
                                  Text(
                                    "sound".tr,
                                    style: Style.nunRegular(fontSize: 14,color: Colors.black),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "default".tr,
                                    style: Style.nunRegular(
                                      fontSize: 14,
                                      color: ColorConstant.color787878,
                                    ),
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
                              textStyle: Style.nunRegular(
                                fontSize: Dimens.d14,
                                color: ColorConstant.white,
                              ),
                              title: "save".tr,
                              onTap: () async {
                                _setAlarm(widget.data?[_currentIndex].alarmId??0);
                                await createAlarm(widget.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      _startScrolling();

      setState(() {
        showBottom = false;
      });
    });
  }

  Widget commonTextA(title) {
    return Text(
      title,
      style: Style.nunRegular(fontSize: 12, color: Colors.white),
    );
  }

  Widget numericSymbol() {
    return Text(":",
        style: Style.montserratBold(
            fontSize: 22, color: ColorConstant.themeColor));
  }
}
