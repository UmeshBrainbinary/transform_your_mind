import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class TroubleGuideScreen extends StatelessWidget {
  const TroubleGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final profileController = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.black
          : ColorConstant.backGround,
      appBar: CustomAppBar(title: "troubleshootingGuides".tr),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: Dimens.d100),
                child: SvgPicture.asset(ImageConstant.profile1),
              )),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.d120),
                child: SvgPicture.asset(ImageConstant.profile2),
              )),
          SingleChildScrollView(
            child: Column(
              children: [
                Dimens.d30.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Html(
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
              ${profileController.guideModel.data?.description ?? ""}
            """,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
