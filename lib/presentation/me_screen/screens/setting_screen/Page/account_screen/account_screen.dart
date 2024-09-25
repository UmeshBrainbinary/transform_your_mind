import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/account_screen/account_controller.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/change_password_screen/change_password_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AccountController accountController = Get.put(AccountController());

  ThemeController themeController = Get.find<ThemeController>();
final audioPlayerController = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(title: "account".tr),
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
            padding: Dimens.d20.paddingAll,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              clipBehavior: Clip.none,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var data = accountController.accountData[index];
                return AccountListItem(
                  isSettings: false,
                  prefixIcon: data.prefixIcon,
                  title: data.title,
                  //suffixIcon: data.suffixIcon,
                  onTap: () {
                    if (index == 0) {
                      Get.toNamed(AppRoutes.editProfileScreen);
                    } else if (index == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                         return ChangePasswordScreen(title: "change",);
                      },));
                     // Get.toNamed(AppRoutes.changePassword);
                    } else if (index == 2) {
                      Get.toNamed(AppRoutes.privacyPolicy);
                    }
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 15,
                );
              },
              itemCount: accountController.accountData.length,
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

class AccountListItem extends StatelessWidget {
  AccountListItem({
    super.key,
    required this.prefixIcon,
    required this.title,
    //required this.suffixIcon,
    required this.isSettings,
    this.onTap,
  });

  final String prefixIcon;
  final String title;

  //final String suffixIcon;
  final bool isSettings;
  final VoidCallback? onTap;

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
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
                title,
                style: Style.nunMedium().copyWith(
                  letterSpacing: Dimens.d0_16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(ImageConstant.settingArrowRight,
                  color: themeController.isDarkMode.value
                      ? ColorConstant.white
                      : ColorConstant.black),
            )
          ],
        ),
      ),
    );
  }
}
