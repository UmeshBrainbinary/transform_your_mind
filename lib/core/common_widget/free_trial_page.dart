import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/welcome_screen/welcome_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class FreeTrialPage extends StatefulWidget {
  const FreeTrialPage({Key? key}) : super(key: key);
  static const freeTrial = '/freeTrial';

  @override
  State<FreeTrialPage> createState() => _FreeTrialPageState();
}

class _FreeTrialPageState extends State<FreeTrialPage>
    with TickerProviderStateMixin {
  late final AnimationController _lottieBgController;
  late final AnimationController _lottieFWController;

  @override
  void initState() {
    super.initState();

    _lottieBgController = AnimationController(vsync: this);
    _lottieFWController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieBgController.dispose();
    _lottieFWController.dispose();
    super.dispose();
  }
 ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
   /*statusBarSet(themeController);*/
    return Scaffold(backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dimens.d100.spaceHeight,
                Text(
                  "wT".tr,
                  style: Style.montserratSemiBold(
                    fontSize: Dimens.d28,
                  ),
                  textAlign: TextAlign.center,
                ),
                Dimens.d28.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 43),
                  child: Text(
                    "Your transform basic package is now live.".tr,
                    style: Style.montserratRegular(
                        fontSize: Dimens.d18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Dimens.d30.spaceHeight,
                const _DescriptionPoints(
                  title: "journalInput",
                ),
                const _DescriptionPoints(
                  title: "transOrSleep",
                ),
                const _DescriptionPoints(
                  title: "dailyProvide",
                ),
                const _DescriptionPoints(
                  title: "focusedAffirmations",
                ),
                const _DescriptionPoints(
                  title: "dailyProvideReminder",
                ),
                Dimens.d64.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                  child: CommonElevatedButton(
                    textStyle: Style.montserratRegular(
                        fontSize: 17, color: ColorConstant.white),
                    title: "premiumAccess".tr,
                    onTap: () async {
                      await PrefService.setValue(PrefKey.premium, true);
                      await PrefService.setValue(PrefKey.subscription, true);
                      await PrefService.setValue(
                          PrefKey.firstTimeRegister, true);
                      await PrefService.setValue(PrefKey.addGratitude, true);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const WelcomeHomeScreen();
                        },
                      ));
                    },
                  ),
                ),
                Dimens.d10.spaceHeight,
              ],
            ),
          ),
          const SizedBox(
            height: Dimens.d100,
            child: CustomAppBar(title: ''),
          )
        ],
      ),
    );
  }
}

class _DescriptionPoints extends StatelessWidget {
  final String title;

  const _DescriptionPoints({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.d20, vertical: Dimens.d10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
                color: ColorConstant.black, shape: BoxShape.circle),
          ),
          //SvgPicture.asset(ImageConstant.icTick,color: ColorConstant.black,),
          Dimens.d16.spaceWidth,
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title.tr,
                style: Style.montserratRegular(
                  fontSize: Dimens.d16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
