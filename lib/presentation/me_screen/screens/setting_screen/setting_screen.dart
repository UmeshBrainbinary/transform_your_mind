import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/bookmark_screen/bookmark_screen.dart';
import 'package:transform_your_mind/presentation/breath_screen/breath_screen.dart';
import 'package:transform_your_mind/presentation/downloaded_pods_screen/downloaded_pods_screen.dart';
import 'package:transform_your_mind/presentation/favourite_screen/favourite_screen.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_affirmation_focus_page.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_focus_page.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/setting_controller.dart';
import 'package:transform_your_mind/presentation/support_screen/support_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingController settingController = Get.put(SettingController());

  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
  }
  final audioPlayerController = Get.find<NowPlayingController>();

  @override
  Widget build(BuildContext context) {
    themeController.isDarkMode.value
        ? ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        dialogTheme: const DialogTheme(
            backgroundColor: ColorConstant.textfieldFillColor),
        scaffoldBackgroundColor: ColorConstant.black,
        navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            iconTheme: WidgetStatePropertyAll(IconThemeData(
              color: Colors.white, // Icon color
            ),)
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: ColorConstant.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: ColorConstant.black)

    )
        : ThemeData(
        appBarTheme: Theme.of(Get.context!)
            .appBarTheme
            .copyWith(backgroundColor: Colors.black),
        primaryColor: ColorConstant.backGround,
        visualDensity: VisualDensity.adaptivePlatformDensity);
    //statusBarSet(themeController);
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "settings".tr,
      ),
      body: Stack(
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
          Padding(
            padding: Dimens.d20.paddingHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 50, top: 30),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ColorConstant.transparent,
                          borderRadius: BorderRadius.circular(Dimens.d16),
                        ),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            var data = settingController.settingsData[index];
                            return SettingListItem(
                              setting: data.settings,
                              isSettings: true,
                              prefixIcon: data.prefixIcon,
                              title: data.title,
                              suffixIcon: data.suffixIcon,
                              onTap: () {
                                if (index == 0) {
                                  Get.toNamed(AppRoutes.notificationSetting);
                                } else if (index == 1) {
                                  Get.toNamed(AppRoutes.subscriptionScreen);
                                } else if (index == 2) {
                                  Get.toNamed(AppRoutes.accountScreen);
                                } else if (index == 3) {
                                } else if (index == 4) {
                                  Get.toNamed(
                                      AppRoutes.personalizationScreen);
                                } else if (index == 5) {
                                  Get.toNamed(AppRoutes.feedbackScreen);
                                } else if (index == 6) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return  SupportScreen();
                                    },
                                  ));
                                } else if (index == 7) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const DownloadedPodsScreen();
                                    },
                                  ));
                                } else if (index == 8) {
                                  Get.to(
                                      BreathScreen(
                                        skip: false,
                                        setting: true,
                                      ),
                                      transition: Transition.noTransition);
                                } else if (index == 9) {
                                  Get.to( SelectYourFocusPage(setting: true,
                                      isFromMe: false));
                                } else if (index == 10) {
                                  Get.to( SelectYourAffirmationFocusPage(setting: true,
                                      isFromMe: false));
                                } else if (index == 11) {
                                  Get.to(const FavouriteScreen());
                                } else {
                                  Get.to(const BookmarkScreen());
                                }
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Padding(
                            padding: Dimens.d20.paddingHorizontal,
                            child: const SizedBox(
                              height: 15,
                            ),
                          ),
                          itemCount: settingController.settingsData.length,
                        ),
                      ),
                    ],
                  ),
                ),
                Dimens.d30.spaceHeight,
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
      ),
    );
  }
}

class SettingListItem extends StatelessWidget {
  SettingListItem({
    super.key,
    required this.prefixIcon,
    required this.title,
    required this.suffixIcon,
    required this.isSettings,
    this.onTap,
    this.setting,
  });

  final String prefixIcon;
  final String title;
  final String suffixIcon;
  final bool isSettings;
  final VoidCallback? onTap;
  final Widget? setting;

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    String theme =
        PrefService.getBool(PrefKey.theme) ? "Dark Mode" : "Light Mode";
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.2),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value
              ? ColorConstant.textfieldFillColor
              : ColorConstant.white,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.d10,
          vertical: Dimens.d5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Dimens.d12.spaceWidth,
            Expanded(
              child: Text(
                title == "Light Mode" ? theme : title.tr,
                style: Style.nunMedium().copyWith(
                  letterSpacing: Dimens.d0_16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: setting,
              ),
            ),
            title != "Light Mode"
                ? title != "Dark Mode"
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(suffixIcon,
                            color: themeController.isDarkMode.value
                                ? ColorConstant.white
                                : ColorConstant.black),
                      )
                    : const SizedBox()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 50.0,
    this.height = 20.0,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _value;
  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          color: _value ? widget.activeColor : widget.inactiveColor,
        ),
        child: Row(
          mainAxisAlignment:
              _value ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: widget.height - 5,
              height: widget.height - 5,
              margin: const EdgeInsets.all(3),
              decoration:   BoxDecoration(
                shape: BoxShape.circle,
                color: themeController.isDarkMode.isTrue?ColorConstant.white
                    :ColorConstant.themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
