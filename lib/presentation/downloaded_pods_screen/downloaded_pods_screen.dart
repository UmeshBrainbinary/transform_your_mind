import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class DownloadedPodsScreen extends StatefulWidget {
  const DownloadedPodsScreen({super.key});

  @override
  State<DownloadedPodsScreen> createState() => _DownloadedPodsScreenState();
}

class _DownloadedPodsScreenState extends State<DownloadedPodsScreen> {
  late ScrollController scrollController = ScrollController();
  AudioContentController audioContentController =
      Get.put(AudioContentController());
   ThemeController themeController = Get.find<ThemeController>();
  String currentLanguage = PrefService.getString(PrefKey.language);

  @override
  void initState() {
    audioContentController.getDownloadedList();
    super.initState();
  }
  String _formatDuration(Duration? duration) {
    if (duration == null) return "00:00";
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
final audioPlayerController = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
        appBar: CustomAppBar(
          title: "Downloads".tr,
          showBack: true,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dimens.d30.h.spaceHeight,
                  GetBuilder<AudioContentController>(
                    id: 'update',
                    builder: (controller) {
                      return Expanded(
                        child: controller.audioDataDownloaded.isNotEmpty
                            ? GridView.builder(
                                controller: scrollController,
                                padding:
                                    const EdgeInsets.only(bottom: Dimens.d20),
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.78,
                                  crossAxisCount: 2,
                                  // Number of columns
                                  crossAxisSpacing: 20,
                                  // Spacing between columns
                                  mainAxisSpacing: 20, // Spacing between rows
                                ),
                                itemCount: controller.audioDataDownloaded.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _onTileClick(
                                        context: context,
                                        index: index,
                                        audioContent:
                                            controller.audioDataDownloaded[index],
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            CommonLoadImage(
                                              borderRadius: 10,
                                              url: controller
                                                      .audioDataDownloaded[index]
                                                      .image ??
                                                  "",
                                              width: Dimens.d170,
                                              height: Dimens.d113,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10, top: 10),
                                                child: SvgPicture.asset(
                                                    ImageConstant.play),
                                              ),
                                            ),
                                            Positioned( bottom: 6.0,
                                              right: 6.0,
                                              child: Container(padding:  EdgeInsets.only(top:Platform.isIOS?0: 1),
                                                height: 12,width: 30,decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                                                    borderRadius: BorderRadius.circular(13)),
                                                child: Center(child: Text(controller.audioListDurationD.length > index ? _formatDuration( controller.audioListDurationD[index]) : '8:00',style: Style.nunRegular(fontSize: 6,color: Colors.white),),) ,),
                                            )
                                          ],
                                        ),
                                        Dimens.d10.spaceHeight,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 72,
                                              child: Text(
                                                currentLanguage=="en-US"?controller
                                                    .audioDataDownloaded[index]
                                                    .name
                                                    .toString():controller
                                                    .audioDataDownloaded[index]
                                                    .gName
                                                    .toString(),
                                                // "Motivational",
                                                style: Style.nunitoBold(
                                                  fontSize: Dimens.d12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            const CircleAvatar(
                                              radius: 2,
                                              backgroundColor:
                                                  ColorConstant.colorD9D9D9,
                                            ),
                                            Dimens.d10.spaceWidth,
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  ImageConstant.rating,
                                                  color:
                                                      ColorConstant.colorFFC700,
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                Dimens.d3.spaceWidth,

                                                Text(
                                                  "${controller.audioDataDownloaded[index].rating.toString()}.0",
                                                  style: Style.nunMedium(
                                                    fontSize: Dimens.d12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Dimens.d4.spaceWidth,

                                            controller.audioDataDownloaded[index].download == true
                                                ? GestureDetector(
                                                    onTap: () async {

                                                      await controller
                                                          .removeData(index);
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      height: 22,
                                                      width: 22,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: themeController.isDarkMode.isTrue?Colors.white:Colors.black,
                                                              width: 1.5)),
                                                      child:  Icon(
                                                        Icons.close,
                                                        color: themeController.isDarkMode.isTrue?Colors.white:Colors.black,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox()
                                          ],
                                        ),
                                        Dimens.d7.spaceHeight,
                                        Text(
                                          currentLanguage=="en-US"?controller.audioDataDownloaded[index]
                                              .description
                                              .toString():controller.audioDataDownloaded[index]
                                              .gDescription
                                              .toString(),
                                          maxLines: Dimens.d2.toInt(),
                                          style: Style.nunMedium(
                                              fontSize: Dimens.d14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: Dimens.d120),
                            child: SizedBox(
                              height: Get.height,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    themeController.isDarkMode.isTrue?ImageConstant.darkData:ImageConstant
                                        .noData,height: 158,width: 200,),
                                  Text(
                                    "dataNotFound".tr,
                                    style: Style.montserratBold(fontSize: 24),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Obx(() {
              if (!audioPlayerController.isVisible.value) {
                return const SizedBox.shrink();
              }

              final currentPosition =
                  audioPlayerController.positionStream.value ??
                      Duration.zero;
              final duration =
                  audioPlayerController.durationStream.value ??
                      Duration.zero;
              final isPlaying = audioPlayerController.isPlaying.value;

              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          Dimens.d24,
                        ),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return NowPlayingScreen(
                        audioData: audioDataStore!,
                      );
                    },
                  );
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 72,
                    width: Get.width,
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 8, right: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 50),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            ColorConstant.colorB9CCD0,
                            ColorConstant.color86A6AE,
                            ColorConstant.color86A6AE,
                          ], // Your gradient colors
                          begin: Alignment.bottomLeft,
                          end: Alignment.bottomRight,
                        ),
                        color: ColorConstant.themeColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommonLoadImage(
                                borderRadius: 6.0,
                                url: audioDataStore!.image!,
                                width: 47,
                                height: 47),
                            Dimens.d12.spaceWidth,
                            GestureDetector(
                                onTap: () async {
                                  if (isPlaying) {
                                    await audioPlayerController
                                        .pause();
                                  } else {
                                    await audioPlayerController
                                        .play();
                                  }
                                },
                                child: SvgPicture.asset(
                                  isPlaying
                                      ? ImageConstant.pause
                                      : ImageConstant.play,
                                  height: 17,
                                  width: 17,
                                )),
                            Dimens.d10.spaceWidth,
                            Expanded(
                              child: Text(
                                audioDataStore!.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Style.nunRegular(
                                    fontSize: 12,
                                    color: ColorConstant.white),
                              ),
                            ),
                            Dimens.d10.spaceWidth,
                            GestureDetector(
                                onTap: () async {
                                  await audioPlayerController.reset();
                                },
                                child: SvgPicture.asset(
                                  ImageConstant.closePlayer,
                                  color: ColorConstant.white,
                                  height: 24,
                                  width: 24,
                                )),
                            Dimens.d10.spaceWidth,
                          ],
                        ),
                        Dimens.d8.spaceHeight,
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor:
                            ColorConstant.white.withOpacity(0.2),
                            inactiveTrackColor:
                            ColorConstant.color6E949D,
                            trackHeight: 1.5,
                            thumbColor: ColorConstant.transparent,
                            thumbShape: SliderComponentShape.noThumb,
                            overlayColor: ColorConstant.backGround
                                .withAlpha(32),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius:
                                16.0), // Customize the overlay shape and size
                          ),
                          child: SizedBox(
                            height: 2,
                            child: Slider(
                              thumbColor: Colors.transparent,
                              activeColor: ColorConstant.backGround,
                              value: currentPosition.inMilliseconds
                                  .toDouble(),
                              max: duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                audioPlayerController
                                    .seekForMeditationAudio(
                                    position: Duration(
                                        milliseconds:
                                        value.toInt()));
                              },
                            ),
                          ),
                        ),
                        Dimens.d5.spaceHeight,
                      ],
                    ),
                  ),
                ),
              );
            }),

          ],
        ));
  }

  void _onTileClick(
      {int? index, BuildContext? context, required AudioData audioContent}) {
    showModalBottomSheet(
      context: context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Dimens.d24,
          ),
        ),
      ),
      builder: (BuildContext context) {
        return NowPlayingScreen(
          d: true,
          audioData: audioContent,
        );
      },
    );
  }
}
