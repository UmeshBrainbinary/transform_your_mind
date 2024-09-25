import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/support_screen/support_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  SupportController supportController = Get.put(SupportController());
  String currentLanguage = PrefService.getString(PrefKey.language);

  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  checkInternet() async {
    if (await isConnected()) {
      supportController.getFaqList();
    } else {
      showSnackBarError(context, "noInternet".tr);
    }
  }
final audioPlayerController = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.isTrue
              ? ColorConstant.darkBackground
              : ColorConstant.backGround,
          appBar: const CustomAppBar(title: "FAQ"),
          body: GetBuilder<SupportController>(id: "update",builder: (controller) {
            return   Stack(
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
                      padding: const EdgeInsets.only(bottom: Dimens.d120),
                      child: SvgPicture.asset(themeController.isDarkMode.isTrue
                          ? ImageConstant.profile2Dark
                          : ImageConstant.profile2),
                    )),
                Column(
                  children: [
                    Dimens.d10.spaceHeight,
                    Expanded(
                        child: ListView.builder(
                          itemCount: controller.faqData?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var data = controller.faqData?[index];
                            return GestureDetector(onTap: () {
                              setState(() {
                                controller.faq[index] =
                                !controller.faq[index];
                              });
                            },
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                                decoration: BoxDecoration(
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.textfieldFillColor
                                        : ColorConstant.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            width: 260,
                                            child: Text(
                                                (currentLanguage == "en-US" || currentLanguage == "")
                                                    ? data?.question ?? ""
                                                : data?.gQuestion ?? "",
                                            style: Style.nunitoSemiBold(fontSize: 16),
                                            )),
                                        SvgPicture.asset(
                                          controller.faq[index]
                                              ? ImageConstant.upArrowFaq
                                              : ImageConstant.downArrowFaq,
                                          height: 18,
                                          width: 18,
                                          color: themeController.isDarkMode.isTrue
                                              ? ColorConstant.white
                                              : ColorConstant.black,
                                        ),
                                      ],
                                    ),
                                    controller.faq[index]
                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(
                                          thickness: 0.7,
                                        ),
                                        Text(
                                          (currentLanguage == "en-US" || currentLanguage == "")
                                              ? data?.answer ?? ""
                                                  : data?.gAnswer ?? "",
                                              textAlign: TextAlign.start,
                                          style: Style.nunRegular(fontSize: 14)
                                              .copyWith(height: 1.5),
                                        )
                                      ],
                                    )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
                  ],
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
            );
          },),
        ),
        Obx(() => supportController.loader.isTrue?commonLoader():const SizedBox(),)
      ],
    );
  }
}
