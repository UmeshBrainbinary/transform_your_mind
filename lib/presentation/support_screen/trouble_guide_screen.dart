import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class TroubleGuideScreen extends StatefulWidget {
  const TroubleGuideScreen({super.key});

  @override
  State<TroubleGuideScreen> createState() => _TroubleGuideScreenState();
}

class _TroubleGuideScreenState extends State<TroubleGuideScreen> {
  final themeController = Get.find<ThemeController>();
  final profileController = Get.find<ProfileController>();
  bool loader = false;
  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  checkInternet() async {
    if (await isConnected()) {
      getGuide();
    } else {
      showSnackBarError(Get.context!, "noInternet".tr);
    }
  }

  getGuide() async {
    setState(() {
      loader = true;
    });
    await profileController.getGuide();
    setState(() {
      loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.isTrue
              ? ColorConstant.darkBackground
              : ColorConstant.backGround,
          appBar: CustomAppBar(title: "troubleshootingGuides".tr),
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
        ),
        loader?commonLoader():const SizedBox()
      ],
    );
  }
}
