import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
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
  String currentLanguage = '';
  double height  = Get.height;
  double width   = Get.width;
  bool checkInternetCheck = false;
  @override
  void initState() {
    checkInternet();
    debugPrint("height ^^^^^^^^^^^^^^^^^^^^^ $height");
    debugPrint("width ^^^^^^^^^^^^^^^^^^^^^^ $width");
    super.initState();
  }
  checkInternet() async {
    if (await isConnected()) {
      setState(() {
        checkInternetCheck = true;
      });
      await personalizationController.getScreen();


      currentLanguage = PrefService.getString(PrefKey.language).isEmpty
          ? "en-US"
          : PrefService.getString(PrefKey.language);
      setState(() {});
    } else {
      setState(() {
        checkInternetCheck = false;
      });
      showSnackBarError(Get.context!, "noInternet".tr);
    }
  }


  updateUser(
    BuildContext context,
  ) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));
      request.fields.addAll({
        'language': PrefService.getString(PrefKey.language).isEmpty
            ? "english"
            : PrefService.getString(PrefKey.language) != "en-US"
                ? "german"
                : "english"
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return Stack(
      children: [
        GetBuilder<PersonalizationController>(
          id: "u",
          builder: (controller) {
            return Stack(
              children: [
              if( controller.getScreenModel.data!=null)
                checkInternetCheck
                    ? Image.network(
                        controller.getScreenModel.data?.first.image ?? "",
                        height: Get.height,
                        width: Get.width,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        ImageConstant.chooseBack,
                        height: Get.height,
                        width: Get.width,
                        fit: BoxFit.cover,
                      ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: CustomAppBar(
                    centerTitle: widget.intro!,
                    title: "chooseLanguage".tr,
                    showBack: widget.intro! ? false : true,
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          height > 820
                              ? Dimens.d200.spaceHeight
                              : Platform.isIOS
                                  ? Dimens.d155.spaceHeight
                                  : Dimens.d120.spaceHeight,
                          Text(
                            checkInternetCheck
                                ? currentLanguage == 'en-US' ||
                                        currentLanguage == ""
                                    ? controller
                                        .getScreenModel.data?.first.quote??""
                                    : controller
                                        .getScreenModel.data?.first.gQuote??""
                                : "".tr,
                            textAlign: TextAlign.center,
                            style: Style.nunitoSemiBold(
                                fontSize: 24, color: ColorConstant.white),
                          ),
                          Dimens.d40.spaceHeight,
                          Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Text(
                                  checkInternetCheck
                                      ? currentLanguage == 'en-US' ||
                                              currentLanguage == ""
                                          ? controller.getScreenModel.data
                                                  ?.first.authorName ??
                                          "":controller.getScreenModel.data?.first
                                      .gAuthorName??""
                                      : "Norman Vincent Peale",
                                  style: Style.nunRegular(
                                      fontSize: 12, color: ColorConstant.white),
                                ),
                              )),
                          Dimens.d100.spaceHeight,
                          Obx(
                            () => GestureDetector(
                              onTap: () async {
                                personalizationController.english.value = true;
                                personalizationController.german.value = false;
                                Locale newLocale;
                                newLocale = const Locale('en', 'US');

                                Get.updateLocale(newLocale);
                                    await PrefService.setValue(
                                        PrefKey.language,
                                        newLocale.toLanguageTag());
                                    setState(() {
                                      currentLanguage =
                                          PrefService.getString(
                                              PrefKey.language);
                                    });

                                await updateUser(context);
                              },
                                  child: Container(
                                    height: 46,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 17),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80),
                                        color: themeController.isDarkMode.isTrue
                                            ? ColorConstant.textfieldFillColor
                                            : ColorConstant.white),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          "English",
                                          style: Style.nunRegular(
                                              fontSize: Dimens.d16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        personalizationController.english.isTrue
                                            ? SvgPicture.asset(
                                          ImageConstant.select,
                                          height: 16,
                                          width: 16,
                                        )
                                            : SvgPicture.asset(
                                          ImageConstant.unSelect,
                                          height: 16,
                                          width: 16,
                                          color: themeController.isDarkMode
                                              .isTrue
                                              ? ColorConstant.white
                                              : Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                          Dimens.d25.spaceHeight,
                          Obx(
                                () =>
                                GestureDetector(
                                  onTap: () async {
                                    personalizationController.german.value =
                                    true;
                                    personalizationController.english.value =
                                    false;

                                Locale newLocale;

                                newLocale = const Locale('de', 'DE');

                                Get.updateLocale(newLocale);

                                await PrefService.setValue(
                                        PrefKey.language,
                                        newLocale.toLanguageTag());
                                    setState(() {
                                      currentLanguage =
                                          PrefService.getString(
                                              PrefKey.language);
                                    });
                                await updateUser(context);
                              },
                                  child: Container(
                                    height: 46,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 17),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80),
                                        color: themeController.isDarkMode.isTrue
                                            ? ColorConstant.textfieldFillColor
                                            : ColorConstant.white),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          "German",
                                          style: Style.nunRegular(
                                              fontSize: Dimens.d16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        personalizationController.german.isTrue
                                            ? SvgPicture.asset(
                                          ImageConstant.select,
                                          height: 16,
                                          width: 16,
                                        )
                                            : SvgPicture.asset(
                                          ImageConstant.unSelect,
                                          height: 16,
                                          width: 16,
                                          color: themeController.isDarkMode
                                              .isTrue
                                              ? ColorConstant.white
                                              : Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                          Dimens.d70.spaceHeight,
                          widget.intro!
                              ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CommonElevatedButton(
                            title: "continue".tr,
                            onTap: () {
                              Get.toNamed(AppRoutes.introScreen);
                            },
                          ),
                        )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        personalizationController.loader.isTrue
            ? commonLoader()
            : const SizedBox()
      ],
    );
  }
}

class AccountListItem extends StatefulWidget {
  const AccountListItem({
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

  @override
  State<AccountListItem> createState() => _AccountListItemState();
}

class _AccountListItemState extends State<AccountListItem> {
  ThemeController themeController = Get.find<ThemeController>();

  PersonalizationController pController = Get.put(PersonalizationController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
              widget.title,
              style: Style.nunMedium(fontSize: 14).copyWith(
                letterSpacing: Dimens.d0_16,
              ),
            ),
            const Spacer(),

            Dimens.d6.spaceWidth,
          ],
        ),
      ),
    );
  }
}
