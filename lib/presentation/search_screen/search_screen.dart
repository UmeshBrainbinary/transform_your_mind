import 'dart:io';

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
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/search_screen/s_controller.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SController sController = Get.put(SController());
  AudioContentController audioContentController  =Get.find<AudioContentController>();
  FocusNode searchFocusNode = FocusNode();
  late ScrollController scrollController = ScrollController();
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);
  ThemeController themeController = Get.find<ThemeController>();
  String currentLanguage = PrefService.getString(PrefKey.language);
  final audioPlayerController = Get.find<NowPlayingController>();

  @override
  void initState() {
    if(PrefService.getString(PrefKey.language)==""){
      setState(() {
        currentLanguage ="en-US";

      });
    }
    scrollController.addListener(() {
      double showOffset = 10.0;

      if (scrollController.offset > showOffset) {
        showScrollTop.value = true;
      } else {
        showScrollTop.value = false;
      }
    });
    audioContentController
        .searchController.clear();
    super.initState();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "00:00";
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
  /*checkInternet() async {
    if (await isConnected()) {
      await audioContentController.getPodsData();
    } else {
      showSnackBarError(Get.context!, "noInternet".tr);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomInset > 0;
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.white,
      appBar: CustomAppBar(
        title: "search".tr,
        showBack: true,
      ),
      body: Stack(
        children: [
          isKeyboardOpen
              ? const SizedBox()
              : Align(
                  alignment: const Alignment(1, 0),
                  child: SvgPicture.asset(
                      themeController.isDarkMode.isTrue
                          ? ImageConstant.profile1Dark
                          : ImageConstant.bgVector,
                      height: Dimens.d230.h),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Dimens.d30.h.spaceHeight,
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: themeController.isDarkMode.isTrue
                                    ? Colors.transparent
                                    : ColorConstant.themeColor.withOpacity(0.1),
                                blurRadius: Dimens.d8,
                              )
                            ],
                          ),
                          child: CommonTextField(
                              onChanged: (value) {
                                setState(() {
                                  audioContentController.audioData =
                                      audioContentController.filterList(value,
                                          audioContentController.audioData);
                                });
                              },
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(ImageConstant.search,
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.colorBFBFBF
                                        : ColorConstant.color545454),
                              ),
                              hintStyle: const TextStyle(fontSize: 14),

                              suffixIcon: audioContentController
                                  .searchController.text.isEmpty
                                  ? const SizedBox()
                                  : Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: GestureDetector(
                                    onTap: () {
                                      audioContentController.searchFocusNode.unfocus();

                                      audioContentController
                                          .searchController
                                          .clear();
                                      setState(() {
                                        audioContentController
                                            .getPodApi();
                                      });
                                    },
                                    child: SvgPicture.asset(
                                              ImageConstant.close,
                                              color: themeController
                                                      .isDarkMode.isTrue
                                                  ? ColorConstant.colorBFBFBF
                                                  : ColorConstant.color545454)),
                                    ),
                              hintText: "search".tr,
                              textStyle: Style.nunRegular(fontSize: 14),
                              controller:
                              audioContentController.searchController,
                              focusNode:
                              audioContentController.searchFocusNode),
                        ),

                        Dimens.d20.h.spaceHeight,
                        GetBuilder<AudioContentController>(
                          id: 'update',
                          builder: (controller) {
                            return Expanded(
                              child: controller.audioData.isNotEmpty
                                  ? GridView.builder(
                                      controller: scrollController,
                                      padding: const EdgeInsets.only(
                                          bottom: Dimens.d20),
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 0.78,
                                        crossAxisCount: 2,
                                        // Number of columns
                                        crossAxisSpacing: 20,
                                        // Spacing between columns
                                        mainAxisSpacing:
                                            20, // Spacing between rows
                                      ),
                                      itemCount: controller.audioData.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            audioContentController
                                                .searchFocusNode
                                                .unfocus();
                                            if (!controller
                                                .audioData[index].isPaid!) {
                                              _onTileClick(
                                                  audioContent: controller
                                                      .audioData[index],
                                                  context: context);
                                            } else {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return SubscriptionScreen(
                                                    skip: false,
                                                  );
                                                },
                                              ));
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.topLeft,
                                            children: [
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      CommonLoadImage(
                                                        borderRadius: 10,
                                                        url: controller
                                                                .audioData[
                                                                    index]
                                                                .image ??
                                                            "",
                                                        width: Dimens.d170,
                                                        height: Dimens.d113,
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10,
                                                                  top: 10),
                                                          child:
                                                              SvgPicture.asset(
                                                                  ImageConstant
                                                                      .play),
                                                        ),
                                                      ),
                                                      Positioned( bottom: 6.0,
                                                        right: 6.0,
                                                        child: Container(padding:  EdgeInsets.only(  top:Platform.isIOS?0: 1),
                                                          height: 12,width: 30,decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                                                              borderRadius: BorderRadius.circular(13)),
                                                          child: Center(child: Text( controller.audioListDuration.length > index ? _formatDuration( controller.audioListDuration[index]) : '8:00',style: Style.nunRegular(fontSize: 6,color: Colors.white),),) ,),
                                                      )
                                                    ],
                                                  ),
                                                  Dimens.d10.spaceHeight,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 90,
                                                        child: Text(
                                                          currentLanguage=="en-US"?controller
                                                              .audioData[index]
                                                              .name
                                                              .toString():controller
                                                              .audioData[index]
                                                              .gName
                                                              .toString(),
                                                          // "Motivational",
                                                          style:
                                                              Style.nunMedium(
                                                            fontSize:
                                                                Dimens.d14,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      const CircleAvatar(
                                                        radius: 2,
                                                        backgroundColor:
                                                            ColorConstant
                                                                .colorD9D9D9,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            ImageConstant
                                                                .rating,
                                                            color: ColorConstant
                                                                .colorFFC700,
                                                            height: 10,
                                                            width: 10,
                                                          ),
                                                          Dimens.d3.spaceWidth,
                                                          Text(
                                                            "${controller.audioData[index].rating.toString()}.0",
                                                            style:
                                                                Style.nunMedium(
                                                              fontSize:
                                                                  Dimens.d12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Dimens.d7.spaceHeight,
                                                  Text(
                                                    currentLanguage=="en-US"? controller.audioData[index]
                                                        .description
                                                        .toString():controller.audioData[index]
                                                        .gDescription
                                                        .toString(),
                                                    maxLines: Dimens.d2.toInt(),
                                                    style: Style.nunMedium(
                                                        fontSize: Dimens.d14),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              controller
                                                      .audioData[index].isPaid!
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              7.0),
                                                      height: 14,
                                                      width: 14,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              shape: BoxShape
                                                                  .circle),
                                                      child: Center(
                                                          child: Image.asset(
                                                        ImageConstant.lockHome,
                                                        height: 7,
                                                        width: 7,
                                                      )),
                                                    )
                                                  : const SizedBox(),

                                            ],
                                          ),
                                        );
                                      })
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: Dimens.d50),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            themeController.isDarkMode.isTrue
                                                ? ImageConstant.darkData
                                                : ImageConstant.noData,
                                          ),
                                          Text(
                                            "dataNotFound".tr,
                                            style: Style.gothamMedium(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Dimens.d11.spaceHeight,
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 35),
                                            child: Text(
                                              "noSearchAgain".tr,
                                              textAlign: TextAlign.center,
                                              style: Style.nunRegular(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
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
      ),
    );
  }

  void _onTileClick({
    AudioData? audioContent,
    BuildContext? context,
  }) {
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
          audioData: audioContent!,
        );
      },
    );
  }
}
