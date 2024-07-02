import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/screen_info_widget.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/notification_screen/notification_screen.dart';
import 'package:transform_your_mind/presentation/transform_pods_screen/transform_pods_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieBgController;
  late AnimationController _controller;
  ThemeController themeController = Get.find<ThemeController>();

  List<Map<String, dynamic>> menuItems = [
    {
      "title": "selfDevelopment".tr,
      "desc": "Self Development Description",
      "buttonTitle": "startToday".tr,
      "icon": ImageConstant.journalIconQuick
    },
    {
      "title": "transformPods".tr,
      "desc": "Self Development Description",
      "buttonTitle": "listenGrow".tr,
      "icon": ImageConstant.podIconQuick
    },
  ];
  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  ValueNotifier<bool> info = ValueNotifier(false);
  final audioPlayerController = Get.find<NowPlayingController>();
  @override
  void initState() {

    _lottieBgController = AnimationController(vsync: this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue?
      ColorConstant.darkBackground:ColorConstant.white,
      appBar: CustomAppBar(
        title: "tools".tr,
        showBack: false,
        action: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const NotificationScreen();
                },
              ));
            },
            child: SvgPicture.asset(
              height: Dimens.d25,
              ImageConstant.notification,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.centerLeft,
                          key: ValueKey(menuItems[index]),
                          children: [
                            GestureDetector(
                              key: ValueKey(menuItems[index]),
                              onTap: () {
                                if (menuItems[index]["title"] ==
                                    "selfDevelopment".tr) {
                                  Navigator.pushNamed(
                                          context, AppRoutes.journalScreen)
                                      .then((value) {
                                    setState(() {});
                                  });
                                } else if (menuItems[index]["title"] ==
                                    "transformPods".tr) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const TransformPodsScreen();
                                    },
                                  ));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 50, left: 30, right: 30),
                                child: Stack(
                                  key: ValueKey(menuItems[index]),
                                  // Use ValueKey for reordering
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          color:
                                              themeController.isDarkMode.value
                                                  ? ColorConstant
                                                      .textfieldFillColor
                                                  : ColorConstant.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.2))),
                                      padding: const EdgeInsets.only(
                                        left: 140,
                                        top: 10,
                                        bottom: 10,
                                        right: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Dimens.d10.spaceHeight,
                                          AutoSizeText(
                                            menuItems[index]["title"],
                                            style: Style.montserratMedium(
                                              fontSize: 15,
                                            ),
                                          ),
                                          Dimens.d10.spaceHeight,
                                          AutoSizeText(
                                            menuItems[index]["desc"],
                                            style: Style.montserratRegular(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          Dimens.d15.spaceHeight,
                                          CommonElevatedButton(
                                            title: menuItems[index]
                                                ["buttonTitle"],
                                            onTap: () {
                                              if (menuItems[index]["title"] ==
                                                  "selfDevelopment".tr) {
                                                Navigator.pushNamed(
                                                        context,
                                                        AppRoutes
                                                            .journalScreen)
                                                    .then((value) {
                                                  setState(() {});
                                                });
                                              } else if (menuItems[index]
                                                      ["title"] ==
                                                  "transformPods".tr) {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return const TransformPodsScreen();
                                                  },
                                                ));
                                              } else {
                                                /*   Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return const RitualsPage();
                                                },));*/
                                              }
                                            },
                                            height: 26.0,
                                            textStyle:
                                                Style.montserratRegular(
                                                    fontSize: 14.0,
                                                    color:
                                                        ColorConstant.white),
                                          ),
                                          Dimens.d10.spaceHeight,
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      bottom: -10,
                                      width: 120,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            color: themeController
                                                    .isDarkMode.value
                                                ? ColorConstant
                                                    .textfieldFillColor
                                                : ColorConstant.white,
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.2))),
                                        padding: const EdgeInsets.all(20),
                                        child: IconButton(
                                          onPressed: null,
                                          iconSize: 40.0,
                                          icon: SvgPicture.asset(
                                            menuItems[index]["icon"],
                                            height: 40,
                                            width: 40,
                                            color: themeController
                                                    .isDarkMode.value
                                                ? ColorConstant.white
                                                : ColorConstant.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 15),
                                        child: SvgPicture.asset(
                                            ImageConstant.menueIcon,
                                            height: 15,
                                            width: 15,
                                            color: themeController
                                                    .isDarkMode.value
                                                ? ColorConstant.white
                                                : ColorConstant.black))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = menuItems.removeAt(oldIndex);
                          menuItems.insert(newIndex, item);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          info.value
              ? Padding(
                  padding: EdgeInsets.only(top: Dimens.d110.h),
                  child: SizedBox(
                    child: ScreenInfoWidget(
                      info: info,
                      controller: _controller,
                      isTutorialVideoVisible: isTutorialVideoVisible,
                      screenTitle: "welcomeToTools".tr,
                      screenHeading:
                          "Use this self reflection fetaure to pratice the art of gratitude, clear unwanted fellings from your life, set goals and help you feel more clam and contect." ??
                              '',
                      screenDesc:
                          "Use this self reflection fetaure to pratice the art of gratitude," ??
                              '',
                      onVideoViewTap: () {},
                    ),
                  ),
                )
              : const SizedBox(),
          Obx(() {
            if (!audioPlayerController.isVisible.value) {
              return const SizedBox.shrink();
            }

            final currentPosition =
                audioPlayerController.positionStream.value ?? Duration.zero;
            final duration =
                audioPlayerController.durationStream.value ?? Duration.zero;
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
                );                },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 87,
                  width: Get.width,
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
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
                    children: [
                      Row(
                        children: [
                          CommonLoadImage(borderRadius: 6.0,
                              url:audioDataStore!.image!,
                              width: 47,
                              height: 47),
                          Dimens.d12.spaceWidth,
                          GestureDetector(
                              onTap: () async {
                                if (isPlaying) {
                                  await audioPlayerController.pause();
                                } else {
                                  await audioPlayerController.play();
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
                              style: Style.montserratRegular(
                                  fontSize: 12, color: ColorConstant.white),
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
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor:
                          ColorConstant.white.withOpacity(0.2),
                          inactiveTrackColor: ColorConstant.color6E949D,
                          trackHeight: 1.5,
                          thumbColor: ColorConstant.transparent,
                          // Color of the thumb
                          thumbShape: SliderComponentShape.noThumb,
                          // Customize the thumb shape and size
                          overlayColor:
                          ColorConstant.backGround.withAlpha(32),
                          // Color when thumb is pressed
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius:
                              16.0), // Customize the overlay shape and size
                        ),
                        child: Slider(
                          thumbColor: Colors.transparent,
                          activeColor: ColorConstant.backGround,
                          value: currentPosition.inMilliseconds.toDouble(),
                          max: duration.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            audioPlayerController.seekForMeditationAudio(
                                position:
                                Duration(milliseconds: value.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
