import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/audio_manager/audio_player_manager.dart';
import 'package:transform_your_mind/core/utils/audio_manager/seek_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:volume_controller/volume_controller.dart';

AudioData? audioDataStore;

class NowPlayingScreen extends StatefulWidget {
  final AudioData? audioData;

  bool? d = false;

  NowPlayingScreen({super.key, this.audioData, this.d});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with TickerProviderStateMixin {
  List<AudioSpeed> audioSpeedList = AudioSpeed.getAudioSpeedList();
  int currentAudioSpeedIndex = 0;
  Timer? volTimer;
  final NowPlayingController nowPlayingController =
      Get.put(NowPlayingController());
  final ValueNotifier<bool> _isVolShowing = ValueNotifier(false);
  ValueNotifier<bool> isActivityApiCalled = ValueNotifier(false);
  final volumeController = VolumeController();

  Random randomNumberGenerator = Random();
  late int randomNumberForSelectingLottie;
  double _opacityOfSpeedText = 1.0;


  ThemeController themeController = Get.find<ThemeController>();
  double _volumeListenerValue = 0;

  double _setVolumeValue = 0;
  //____________________________________ playing controller ___________________________//
  @override
  void initState() {
    super.initState();
  /*  nowPlayingController.rated.value = widget.audioData?.isRated ?? false;
    nowPlayingController.bookmark.value =
        widget.audioData?.isBookmarked ?? false;
    nowPlayingController.update();
    nowPlayingController.lottieController = AnimationController(
        vsync: this, duration: const Duration(seconds: 4));
    nowPlayingController.lottieBgController =
        AnimationController(vsync: this);

    _setInitValues();
    if (widget.d == true) {
      nowPlayingController.setUrlFile(
          img: widget.audioData?.image ?? "",
          description: widget.audioData?.description ?? "",
          expertName: widget.audioData?.expertName ?? "",
          name: widget.audioData?.name ?? "",
          widget.audioData?.downloadedPath ?? "");
    } else {
      nowPlayingController.setUrl(
          img: widget.audioData?.image ?? "",
          description: widget.audioData?.description ?? "",
          expertName: widget.audioData?.expertName ?? "",
          name: widget.audioData?.name ?? "",
          widget.audioData?.audioFile ?? "");
    }

    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    getUserDetails();
    setState(() {});*/

    setUrlPlaying();
  }
  bool checkUrlSameOrNot = false;

  setUrlPlaying() {
    nowPlayingController.rated.value = widget.audioData?.isRated ?? false;
    nowPlayingController.bookmark.value =
        widget.audioData?.isBookmarked ?? false;
    nowPlayingController.update();
    nowPlayingController.lottieController = AnimationController(
        vsync: this, duration: const Duration(seconds: 4));
    nowPlayingController.lottieBgController =
        AnimationController(vsync: this);
    if(nowPlayingController.isPlaying.isTrue){
      if(nowPlayingController.currentUrl==widget.audioData?.audioFile){
        nowPlayingController.lottieController!.reset();
        nowPlayingController.lottieController!.repeat();
      }


    }else{
      nowPlayingController.lottieController?.stop();
    }
        if(nowPlayingController.currentUrl==widget.audioData?.audioFile){
         setState(() {
           checkUrlSameOrNot = true;
         });
      nowPlayingController.rated.value = widget.audioData?.isRated ?? false;
      nowPlayingController.bookmark.value =
          widget.audioData?.isBookmarked ?? false;
      nowPlayingController.update();

      _setInitValues();
      if (widget.d == true) {
        nowPlayingController.setUrlFile(
            img: widget.audioData?.image ?? "",
            description: widget.audioData?.description ?? "",
            expertName: widget.audioData?.expertName ?? "",
            name: widget.audioData?.name ?? "",
            widget.audioData?.downloadedPath ?? "");
      } else {
        nowPlayingController.setUrl(
            img: widget.audioData?.image ?? "",
            description: widget.audioData?.description ?? "",
            expertName: widget.audioData?.expertName ?? "",
            name: widget.audioData?.name ?? "",
            widget.audioData?.audioFile ?? "");
      }

      VolumeController().listener((volume) {
        setState(() => _volumeListenerValue = volume);
      });

      VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
      getUserDetails();
      setState(() {});
    }else{
      setState(() {
        checkUrlSameOrNot = false;
      });
    }


  }

  whenMusicPlying() {
    nowPlayingController.rated.value = widget.audioData?.isRated ?? false;
    nowPlayingController.bookmark.value =
        widget.audioData?.isBookmarked ?? false;
    nowPlayingController.update();
    nowPlayingController.lottieController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    nowPlayingController.lottieBgController = AnimationController(vsync: this);

    _setInitValues();
    if (widget.d == true) {
      nowPlayingController.setUrlFile(
          img: widget.audioData?.image ?? "",
          description: widget.audioData?.description ?? "",
          expertName: widget.audioData?.expertName ?? "",
          name: widget.audioData?.name ?? "",
          widget.audioData?.downloadedPath ?? "");
    } else {
      nowPlayingController.afterPlayingMusic(
          img: widget.audioData?.image ?? "",
          description: widget.audioData?.description ?? "",
          expertName: widget.audioData?.expertName ?? "",
          name: widget.audioData?.name ?? "",
          widget.audioData?.audioFile ?? "");
    }

    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    getUserDetails();
    setState(() {});
    nowPlayingController.update();
  }

  getUserDetails() async {

    setState(() {

    });
    await nowPlayingController.getUser(widget.audioData!.id);
  }

  AudioContentController audioContentController =
      Get.put(AudioContentController());
  @override
  void dispose() {
    nowPlayingController.lottieController!.dispose();
    nowPlayingController.lottieBgController!.dispose();
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
        body: Stack(
      children: [
            Stack(
              children: [
                /// background image
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: BgSemiCircleClipPath(),
                    child: CommonLoadImage(
                      url: widget.audioData?.image ?? '',
                      height: Get.height - 150,
                      width: Get.width,
                    ),
                  ),
                ),

                /// description, subtitle
            Padding(
              padding: const EdgeInsets.only(top: Dimens.d300),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(

                      widget.audioData?.description ??
                          "",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Style.montserratRegular(
                          fontSize: 16, color: ColorConstant.white),
                    ),
                  ),
                  Dimens.d20.spaceHeight,
                  Text(

                    widget.audioData?.expertName ??
                        "",
                    textAlign: TextAlign.center,
                    style: Style.montserratRegular(
                        fontSize: 15, color: ColorConstant.white),
                  ),
                  Dimens.d20.spaceHeight,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      widget.audioData?.name ??
                          "",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Style.montserratRegular(
                          fontSize: 15, color: ColorConstant.white),
                    ),
                  ),
                ],
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
                          onTap: () async {
                            await audioContentController.getPodsData();
                            Get.back();
                            setState(() {});
                          },
                          child: Icon(
                            Icons.close,
                            color: themeController.isDarkMode.isTrue
                                ? ColorConstant.white
                                : ColorConstant.black,
                          )),
                      action: Row(
                        children: [
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (nowPlayingController.rated.isTrue) {
                                } else {
                                  _showAlertDialog(
                                      context: context,
                                      id: widget.audioData?.id ?? "",
                                      star: nowPlayingController.currentRating);
                                }
                              },
                              child: SvgPicture.asset(
                                nowPlayingController.rated.isTrue
                                    ? ImageConstant.rating
                                    : ImageConstant.ratingIcon,
                              ),
                            ),
                          ),
                          Dimens.d10.h.spaceWidth,
                          GestureDetector(
                            onTap: () async {},
                            child: SvgPicture.asset(
                              height: Dimens.d25,
                              ImageConstant.share,
                            ),
                          ),
                          Dimens.d10.h.spaceWidth,
                          Obx(
                            () => GestureDetector(
                              onTap: () async {
                                if (nowPlayingController.bookmark.isTrue) {
                                  nowPlayingController.bookmark.value = false;
                                } else {
                                  nowPlayingController.bookmark.value = true;
                                }
                                nowPlayingController.update();

                                await nowPlayingController.addBookmark(
                                    widget.audioData!.id,
                                    context,
                                    nowPlayingController.bookmark.value);
                                await nowPlayingController
                                    .getUser(widget.audioData!.id);
                                setState(() {});
                              },
                              child: nowPlayingController.bookmark.isFalse
                                  ? SvgPicture.asset(
                                      height: Dimens.d25,
                                      ImageConstant.bookmark,
                                    )
                                  : const Icon(
                                      Icons.bookmark,
                                      color: ColorConstant.deleteRed,
                                      size: Dimens.d25,
                                    ),
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
                controller: nowPlayingController.lottieBgController,
                height: 160,
                width: 160,
                onLoaded: (composition) {
                      nowPlayingController.lottieBgController!
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
                  stream: nowPlayingController.audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                      stream: nowPlayingController.audioPlayer.durationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return checkUrlSameOrNot == false ? SeekBar(
                          duration: const Duration(seconds: 0),
                          position: const Duration(seconds: 0),
                          onChanged: (newPosition) {
                            if (newPosition != null) {
                              nowPlayingController.seekForMeditationAudio(
                                  position: newPosition);
                            }
                          },
                          onChangeEnd: (newPosition) {
                            if (newPosition != null) {
                              nowPlayingController.seekForMeditationAudio(
                                  position: newPosition);
                            }
                          },
                        ) : SeekBar(
                          duration: duration,
                          position: position,
                          onChanged: (newPosition) {
                            if (newPosition != null) {
                              nowPlayingController.seekForMeditationAudio(
                                  position: newPosition);
                            }
                          },
                          onChangeEnd: (newPosition) {
                            if (newPosition != null) {
                              nowPlayingController.seekForMeditationAudio(
                                  position: newPosition);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
                Dimens.d20.h.spaceHeight,
                ValueListenableBuilder(
                        valueListenable: nowPlayingController.isAudioLoading,
                        builder: (BuildContext context, value, Widget? child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (!nowPlayingController
                                        .isAudioLoading.value) {
                                      _volumeTapHandler();
                                      nowPlayingController.update();
                                    }
                                  },
                                  child: SvgPicture.asset(
                                      ImageConstant.loudSpeaker,
                                      color: nowPlayingController
                                              .isAudioLoading.value
                                          ? ColorConstant.grey
                                          : ColorConstant.white),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (!nowPlayingController
                                        .isAudioLoading.value) {
                                      nowPlayingController.skipBackward();
                                      nowPlayingController.update();
                                    }
                                  },
                                  child: Image.asset(
                                    ImageConstant.audio15second,
                                    color: nowPlayingController
                                            .isAudioLoading.value
                                        ? ColorConstant.grey
                                        : ColorConstant.white,
                                    width: Dimens.d24,
                                    height: Dimens.d24,
                                  ),
                                ),
                              ),
                              GetBuilder<NowPlayingController>(
                                builder: (controller) {
                                  return ValueListenableBuilder(
                                    builder: (context, value, child) {
                                      return Flexible(
                                        fit: FlexFit.loose,
                                        child: checkUrlSameOrNot == false
                                            ? GestureDetector(
                                                onTap: () async {
                                                  await whenMusicPlying();
                                                  audioDataStore =
                                                      widget.audioData;

                                                  if (nowPlayingController
                                                      .isPlaying.value) {
                                                    nowPlayingController
                                                        .lottieController!
                                                        .stop();
                                                    nowPlayingController
                                                        .pause();
                                                    nowPlayingController
                                                        .update();
                                                  } else {
                                                    nowPlayingController.play();
                                                    nowPlayingController
                                                        .lottieController!
                                                        .repeat();
                                                    nowPlayingController
                                                        .addRecently(widget
                                                            .audioData!.id);
                                                    nowPlayingController
                                                        .update();
                                                  }
                                                  setState(() {
                                                    nowPlayingController
                                                            .isPlaying.value =
                                                        !nowPlayingController
                                                            .isPlaying.value;
                                                    nowPlayingController
                                                        .update();
                                                  });
                                                  checkUrlSameOrNot = true;
                                                  nowPlayingController.update();
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  height: Dimens.d64.h,
                                                  width: Dimens.d64.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: ColorConstant
                                                              .themeColor),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        Dimens.d17.h),
                                                    child: AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      transitionBuilder: (child,
                                                              animation) =>
                                                          RotationTransition(
                                                        turns: child.key ==
                                                                const ValueKey(
                                                                    'ic_pause')
                                                            ? Tween<double>(
                                                                    begin:
                                                                        Dimens
                                                                            .d1,
                                                                    end: Dimens
                                                                        .d0_5)
                                                                .animate(
                                                                    animation)
                                                            : Tween<double>(
                                                                    begin: Dimens
                                                                        .d0_75,
                                                                    end: Dimens
                                                                        .d1)
                                                                .animate(
                                                                    animation),
                                                        child: ScaleTransition(
                                                            scale: animation,
                                                            child: child),
                                                      ),
                                                      child: SvgPicture.asset(
                                                        ImageConstant.play,
                                                        // key: const ValueKey(
                                                        //     'ic_play'),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  audioDataStore =
                                                      widget.audioData;

                                                  if (nowPlayingController
                                            .isPlaying.value) {
                                          nowPlayingController
                                              .lottieController!
                                              .stop();
                                          nowPlayingController.pause();
                                          nowPlayingController.update();
                                        } else {
                                          nowPlayingController.play();
                                          nowPlayingController
                                              .lottieController!
                                              .repeat();
                                          nowPlayingController
                                              .addRecently(
                                              widget.audioData!.id);
                                          nowPlayingController.update();
                                        }
                                        setState(() {
                                          nowPlayingController
                                              .isPlaying.value =
                                          !nowPlayingController
                                              .isPlaying.value;
                                          nowPlayingController.update();
                                        });
                                        nowPlayingController.update();
                                      },
                                      child:
                                      Container(
                                        height: Dimens.d64.h,
                                        width: Dimens.d64.h,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                            ColorConstant.themeColor),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              Dimens.d17.h),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            transitionBuilder: (child,
                                                animation) =>
                                                RotationTransition(
                                                  turns: child.key ==
                                                      const ValueKey(
                                                          'ic_pause')
                                                      ? Tween<double>(
                                                      begin: Dimens.d1,
                                                      end: Dimens.d0_5)
                                                      .animate(animation)
                                                      : Tween<double>(
                                                      begin: Dimens.d0_75,
                                                      end: Dimens.d1)
                                                      .animate(animation),
                                                  child: ScaleTransition(
                                                      scale: animation,
                                                      child: child),
                                                ),
                                            child: nowPlayingController
                                                .isPlaying.value
                                                ? SvgPicture.asset(
                                                ImageConstant.pause,
                                                key: const ValueKey(
                                                    'ic_pause'))
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
                              );
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!nowPlayingController.isAudioLoading
                                    .value) {
                                  nowPlayingController.skipForward();
                                }
                                nowPlayingController.update();
                              },
                              child: Image.asset(
                                ImageConstant.audio15second2,
                                color: nowPlayingController.isAudioLoading
                                    .value
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
                                            color: nowPlayingController
                                                .isAudioLoading.value
                                                ? ColorConstant.grey
                                                : ColorConstant.white,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            if (_opacityOfSpeedText == 1.0) {
                                              _opacityOfSpeedText = 1.5;
                                            } else if (_opacityOfSpeedText ==
                                                1.5) {
                                              _opacityOfSpeedText = 2.0;
                                            } else if (_opacityOfSpeedText ==
                                                2.0) {
                                              _opacityOfSpeedText = 1.0;
                                            }
                                          });
                                          nowPlayingController
                                              .setPlaybackSpeed(
                                              _opacityOfSpeedText);
                                        },
                                      ),
                                      _opacityOfSpeedText == 1.0
                                          ? const SizedBox()
                                          : Positioned(
                                        top: -20,
                                        left: 1,
                                        child: Text(
                                          "${_opacityOfSpeedText.toDouble()}x",
                                          style:
                                          Style.montserratRegular(
                                              fontSize: 12,
                                              color: ColorConstant
                                                  .white),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: Dimens.d35,
                                    width: Dimens.d55,
                                    child: Center(
                                      child: ValueListenableBuilder(
                                        valueListenable: nowPlayingController
                                            .updatedRealtimeAudioDuration,
                                        builder: (BuildContext context, value,
                                            Widget? child) {
                                          return StreamBuilder<Duration?>(
                                            stream: nowPlayingController
                                                .audioPlayer.positionStream,
                                            builder: (context, snapshot) {
                                              final currentDuration =
                                                  snapshot.data ??
                                                      Duration.zero;
                                              return checkUrlSameOrNot == false ?Text(
                                               "00:00",
                                                style: Style.montserratMedium(
                                                    fontSize: Dimens.d14,
                                                    color: ColorConstant.white),
                                              ):Text(
                                                currentDuration
                                                    .toString()
                                                    .split('.')
                                                    .first,
                                                style: Style.montserratMedium(
                                                    fontSize: Dimens.d14,
                                                    color: ColorConstant.white),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  /// music animation
                              Lottie.asset(
                                ImageConstant.lottieAudio,
                                controller:
                                nowPlayingController.lottieController,
                                height: Dimens.d40,
                                width: Dimens.d40,
                                fit: BoxFit.fill,
                                repeat: true,
                                  ),
                                  SizedBox(
                                    height: Dimens.d35,
                                    width: Dimens.d55,
                                    child: Center(
                                      child: ValueListenableBuilder(
                                        valueListenable: nowPlayingController
                                            .updatedRealtimeAudioDuration,
                                        builder: (BuildContext context, value,
                                            Widget? child) {
                                          return StreamBuilder<Duration?>(
                                            stream: nowPlayingController
                                                .audioPlayer.durationStream,
                                            builder: (context, snapshot) {
                                              final totalDuration =
                                                  snapshot.data ??
                                                      Duration.zero;
                                              return Text(
                                                totalDuration
                                                    .toString()
                                                    .split('.')
                                                    .first,
                                                style: Style.montserratMedium(
                                                    fontSize: Dimens.d14,
                                                    color: ColorConstant.white),
                                              );
                                            },
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
                                valueListenable:
                                nowPlayingController.slideValue,
                                builder: (context, value, child) {
                                  return Expanded(
                                    child: Slider(
                                      min: 0,
                                      max: 1,
                                      activeColor: ColorConstant.themeColor,
                                      onChanged: (double value) {
                                        setState(() {
                                          _setVolumeValue = value;
                                          VolumeController()
                                              .setVolume(_setVolumeValue);
                                        });
                                      },
                                      value: _setVolumeValue,
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
        Obx(
          () => nowPlayingController.loader.isTrue
              ? commonLoader()
              : const SizedBox(),
        )
      ],
    ));
  }

  void _volumeTapHandler() {
    _isVolShowing.value = true;
    volTimer = Timer(const Duration(seconds: 2), () {
      _isVolShowing.value = false;
    });
  }

  void _showAlertDialog({
    String? id,
    BuildContext? context,
    int? star,
  }) {
    showDialog(
      context: context!,
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
                            if (nowPlayingController.currentRating ==
                                index + 1) {
                              nowPlayingController.currentRating = 0;
                            } else {
                              nowPlayingController.currentRating = index + 1;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SvgPicture.asset(
                            index < nowPlayingController.currentRating!
                                ? ImageConstant.rating
                                : ImageConstant.rating,
                            color: index < nowPlayingController.currentRating!
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
                    controller: nowPlayingController.ratingController,
                    focusNode: nowPlayingController.ratingFocusNode),
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
                    onTap: () async {
                      nowPlayingController.addRating(
                          context: context,
                          id: id,
                          star: nowPlayingController.currentRating);
                      nowPlayingController.currentRating = 0;
                      nowPlayingController.ratingController.clear();
                      await nowPlayingController.getUser(widget.audioData!.id);
                      setState.call(() {});
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
