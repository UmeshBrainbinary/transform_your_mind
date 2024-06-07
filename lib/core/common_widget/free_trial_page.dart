import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/bg_semi_circle_texture_painter.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            ImageConstant.homeScreenMeshLottie,
            controller: _lottieBgController,
            height: MediaQuery.of(context).size.height / 3,
            fit: BoxFit.fill,
            onLoaded: (composition) {
              _lottieBgController
                ..duration = composition.duration
                ..repeat();
            },
          ),
          const BgSemiCircleTexture(),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.d105, vertical: Dimens.d115),
            child: SizedBox(
              width: Dimens.d200,
              height: Dimens.d30,
              child: Image.asset(ImageConstant.splashLogo),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Dimens.d251.spaceHeight,
                Text(
                  "Welcome to Transform.....you\'re all set to get started.\n\nYour Transform Basic package is now live.",
                  style: Style.montserratRegular(
                    fontSize: Dimens.d15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Dimens.d25.spaceHeight,
                Text(
                  //i10n.freeGeneralDesc,
                  "This means you have access to....",
                  style: Style.montserratRegular(
                      fontSize: Dimens.d12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Dimens.d30.spaceHeight,
                const _DescriptionPoints(
                  title: "x1 journal input for all Journal features",
                ),
                const _DescriptionPoints(
                  title: "x3 meditations, Shoorah pods or sleep sounds",
                ),
                const _DescriptionPoints(
                  title: "Transform mood & emotions tracker",
                ),
                const _DescriptionPoints(
                  title: "Focused affirmations up to x10 per day",
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                  child: CommonElevatedButton(
                    buttonColor: Colors.white,
                    textStyle: Style.cormorantGaramondBold(
                        fontSize: Dimens.d23, color: ColorConstant.themeColor),
                    title: "Premium Access to all features",
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return  SubscriptionScreen(skip: true,);
                        },
                      ));
                    },
                  ),
                ),
                Dimens.d50.spaceHeight,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(ImageConstant.icTick),
          Dimens.d6.spaceWidth,
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Style.montserratRegular(
                  fontSize: Dimens.d14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
