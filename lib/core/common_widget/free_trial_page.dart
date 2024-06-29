import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/bg_semi_circle_texture_painter.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
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
   statusBarSet(themeController);
    return SafeArea(bottom: false,
      child: Scaffold(backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
        body: Stack(
          children: [
            const BgSemiCircleTexture(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.d105, vertical: Dimens.d115),
              child: SizedBox(
                width: Dimens.d200,
                height: Dimens.d120,
                child: Image.asset(ImageConstant.splashLogo),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Spacer(),
                    Dimens.d251.spaceHeight,
                    Text(
                      "welcomeTransform".tr,
                      style: Style.montserratRegular(
                        fontSize: Dimens.d15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Dimens.d25.spaceHeight,
                    Text(
                      //i10n.freeGeneralDesc,
                      "accessTo".tr,
                      style: Style.montserratRegular(
                          fontSize: Dimens.d12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    Dimens.d30.spaceHeight,
                    const _DescriptionPoints(
                      title: "journalInput",
                    ),
                    const _DescriptionPoints(
                      title: "transOrSleep",
                    ),
                    const _DescriptionPoints(
                      title: "transformMood",
                    ),
                    const _DescriptionPoints(
                      title: "focusedAffirmations",
                    ),
                    // const Spacer(),
                    Dimens.d20.spaceHeight,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                      child: CommonElevatedButton(textStyle: Style.montserratRegular(fontSize: 17,color: ColorConstant.white),
                        title: "premiumAccess".tr,
                        onTap: () async {
                          await PrefService.setValue(PrefKey.premium, true);

                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return SubscriptionScreen(
                                skip: true,
                              );
                            },
                          ));
                        },
                      ),
                    ),
                    Dimens.d10.spaceHeight,
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: Dimens.d100,
              child: CustomAppBar(title: ''),
            )
          ],
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(ImageConstant.icTick,color: ColorConstant.black,),
          Dimens.d6.spaceWidth,
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title.tr,
                style: Style.montserratRegular(
                  fontSize: Dimens.d14,

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
