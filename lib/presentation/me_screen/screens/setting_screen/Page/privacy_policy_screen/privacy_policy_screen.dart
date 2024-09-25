import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  ProfileController profileController = Get.find<ProfileController>();
  String currentLanguage = PrefService.getString(PrefKey.language);

  @override
  void initState() {
    if (PrefService.getString(PrefKey.language) == "") {
      setState(() {
        currentLanguage = "en-US";
      });
    }
    profileController.getPrivacy();
    // TODO: implement initState
    super.initState();
  }
final audioPlayerController  = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(title: "privacySettings".tr),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimens.d100),
                  child: SvgPicture.asset(themeController.isDarkMode.isTrue
                      ? ImageConstant.profile1Dark
                      : ImageConstant.profile1),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimens.d400),
                  child: SvgPicture.asset(themeController.isDarkMode.isTrue
                      ? ImageConstant.profile2Dark
                      : ImageConstant.profile2),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dimens.d30.spaceHeight,
                  Text(
                    "PrivacyPolicy".tr,
                    style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: themeController.isDarkMode.isTrue
                            ? ColorConstant.white
                            : ColorConstant.black),
                  ),
                  Dimens.d10.spaceHeight,
                  currentLanguage == "en-US"
                      ? Html(
                          style: {
                      "p": Style(
                          fontFamily: 'Montserrat-Medium',
                          fontSize: FontSize(14.0),
                          fontWeight: FontWeight.w400,
                          color: themeController.isDarkMode.isTrue
                              ? ColorConstant.white
                              : ColorConstant.black),
                      "strong": Style(
                          fontFamily: 'Montserrat-Bold',
                          fontSize: FontSize(14.0),
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkMode.isTrue
                              ? ColorConstant.white
                              : ColorConstant.black),
                    },
                    data: """
            ${profileController.privacyModel.data?.description ?? ""}
          """,
                        )
                      : Html(
                          style: {
                            "p": Style(
                                fontFamily: 'Montserrat-Medium',
                                fontSize: FontSize(14.0),
                                fontWeight: FontWeight.w400,
                                color: themeController.isDarkMode.isTrue
                                    ? ColorConstant.white
                                    : ColorConstant.black),
                            "strong": Style(
                                fontFamily: 'Montserrat-Bold',
                                fontSize: FontSize(14.0),
                                fontWeight: FontWeight.bold,
                                color: themeController.isDarkMode.isTrue
                                    ? ColorConstant.white
                                    : ColorConstant.black),
                          },
                          data: """
            ${profileController.privacyModel.data?.gDescription ?? ""}
          """,
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
                child: Padding(
                  padding:  EdgeInsets.only(top: Get.height-300),
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
                                style:  const TextStyle(
                                    fontFamily: "Nunito-Regular",
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
        ),
      ),
    );
  }
}
