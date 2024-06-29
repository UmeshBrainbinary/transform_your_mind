import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/personalisations_screen/personalisations_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class PersonalizationScreenScreen extends StatefulWidget {
  final bool? intro;

  const PersonalizationScreenScreen({super.key, this.intro = false});

  @override
  State<PersonalizationScreenScreen> createState() =>
      _PersonalizationScreenScreenState();
}

class _PersonalizationScreenScreenState
    extends State<PersonalizationScreenScreen> {
  PersonalizationController personalizationController =
      Get.put(PersonalizationController());

  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    statusBarSet(themeController);

    return SafeArea(bottom: false,
      child: Scaffold(
        backgroundColor: themeController.isDarkMode.value
            ? ColorConstant.darkBackground
            : ColorConstant.backGround,
        appBar: CustomAppBar(
          title: "chooseLanguage".tr,
          showBack: widget.intro! ? false : true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Dimens.d44.spaceHeight,
      
              Center(child: Image.asset(ImageConstant.chooseLanguages,height: 195,width: 258,)),
              Dimens.d10.spaceHeight,
      
              Center(
                child: Text(
                  "chooseYourLanguage".tr,
                  style: Style.gothamMedium(
                      fontSize: Dimens.d22, fontWeight: FontWeight.w700),
                ),
              ),
              Dimens.d14.spaceHeight,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 47),
                child: Text(
                  "selectYourPreferred".tr,
                  textAlign: TextAlign.center,
                  style: Style.montserratRegular(fontSize: Dimens.d13),
                ),
              ),
              Dimens.d50.spaceHeight,
              Obx(
                    () => GestureDetector(
                  onTap: () async {
                    personalizationController.english.value = true;
                    personalizationController.german.value = false;
      
                    Locale newLocale;
      
                    newLocale = const Locale('en', 'US');
                    Get.updateLocale(newLocale);
      
                    await PrefService.setValue(
                        PrefKey.language, newLocale.toLanguageTag());
                  },
                  child: Container(
                    height: 46,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 17),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: ColorConstant.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          "English",
                          style: Style.montserratRegular(
                              fontSize: Dimens.d14,
                              fontWeight: FontWeight.w500),
                        ),
                        SvgPicture.asset(
                          personalizationController.english.isTrue
                              ? ImageConstant.select
                              : ImageConstant.unSelect,
                          height: 16,
                          width: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Dimens.d14.spaceHeight,
              Obx(
                    () =>
                    GestureDetector(
                      onTap: () async {
                        personalizationController.german.value = true;
                        personalizationController.english.value = false;
      
                        Locale newLocale;
      
                        newLocale = const Locale('de', 'DE');
                        Get.updateLocale(newLocale);
      
                        await PrefService.setValue(
                            PrefKey.language, newLocale.toLanguageTag());
                      },
                      child: Container(
                        height: 46,
                        margin: const EdgeInsets.symmetric(horizontal: 17),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            color: ColorConstant.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "German",
                              style: Style.montserratRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w500),
                            ),
                            SvgPicture.asset(
                              personalizationController.german.isTrue
                                  ? ImageConstant.select
                                  : ImageConstant.unSelect,
                              height: 16,
                              width: 16,
                            )
                          ],
                        ),
                      ),
                    ),
              ),
              Dimens.d20.spaceHeight,
              Dimens.d70.spaceHeight,
              widget.intro!?CommonElevatedButton(
                title: "continue".tr,
                onTap: () {
                   Get.toNamed(AppRoutes.loginPreviewScreen)!.then((value) {
                     menuBarSet(themeController);

                   },);
                },):const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class AccountListItem extends StatelessWidget {
  AccountListItem({
    super.key,
    required this.index,
    required this.title,
    //required this.suffixIcon,
    required this.isSettings,
    this.onTap,
  });

  final int index;
  final String title;

  //final String suffixIcon;
  final bool isSettings;
  final VoidCallback? onTap;

  ThemeController themeController = Get.find<ThemeController>();
  PersonalizationController pController = Get.put(PersonalizationController());

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
          vertical: Dimens.d10,
        ),
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Dimens.d12.spaceWidth,
            Text(
              title,
              style: Style.montserratMedium(fontSize: 14).copyWith(
                letterSpacing: Dimens.d0_16,
              ),
            ),
            const Spacer(),
            /*   index == 0
                ? CustomSwitch(
                    value: themeController.isDarkMode.value,
                    onChanged: (value) async {
                      themeController.switchTheme();
                      Get.forceAppUpdate();
                    },
                    width: 50.0,
                    height: 25.0,
                    activeColor: ColorConstant.themeColor,
                    inactiveColor: ColorConstant.backGround,
                  )
                : CustomSwitch(
                    value: pController.language.value,
                    onChanged: (value) async {

                      pController.language.value = value;
                      pController.onTapChangeLan();
                    },
                    width: 50.0,
                    height: 25.0,
                    activeColor: ColorConstant.themeColor,
                    inactiveColor: ColorConstant.backGround,
                  ),*/
            Dimens.d6.spaceWidth,
          ],
        ),
      ),
    );
  }
}
