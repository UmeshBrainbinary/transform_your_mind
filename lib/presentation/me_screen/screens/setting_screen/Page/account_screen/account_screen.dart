import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/account_screen/account_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  AccountController accountController = Get.put(AccountController());
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    themeController.isDarkMode.isTrue?
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.darkBackground, // Status bar background color
      statusBarIconBrightness: Brightness.light, // Status bar icon/text color
    )):
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    return SafeArea(
      child: Scaffold(
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
                  child: SvgPicture.asset(ImageConstant.profile1),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.d120),
                  child: SvgPicture.asset(ImageConstant.profile2),
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
                        Get.toNamed(AppRoutes.changePassword);
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
            )
          ],
        ),
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
                style: Style.montserratMedium().copyWith(
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
