import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class SubscriptionScreen extends StatefulWidget {
  bool? skip;

  SubscriptionScreen({super.key, this.skip,});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeController.isDarkMode.value
            ? ColorConstant.black
            : ColorConstant.backGround,
        appBar: CustomAppBar(
          title: "subscription".tr,
          showBack: widget.skip! ? false : true,
          action: widget.skip!
              ? Row(children: [
                  GestureDetector(
                      onTap: () async {
                        await PrefService.setValue(PrefKey.subscription, true);
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return  AddGratitudePage(
                              registerUser: true,
                              isFromMyGratitude: true,
                              isSaved: true,
                            );
                          },
                        ));
                      },
                      child: Text(
                        "skip".tr,
                        style: Style.montserratRegular(
                            color: themeController.isDarkMode.value
                                ? ColorConstant.white
                                : ColorConstant.black),
                      )),
                  Dimens.d20.spaceWidth,
                ])
              : const SizedBox(),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Dimens.d22.spaceHeight,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.d45),
                child: Text(
                  "chooseSub".tr,
                  textAlign: TextAlign.center,
                  style: Style.montserratRegular(
                    fontSize: Dimens.d13,
                  ),
                ),
              ),
              Dimens.d20.spaceHeight,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.d45),
                child: Text(
                  "subscribeNow".tr,
                  textAlign: TextAlign.center,
                  style: Style.montserratRegular(
                    color: ColorConstant.themeColor,
                    fontSize: Dimens.d12,
                  ),
                ),
              ),
              Dimens.d20.spaceHeight,
              selectPlan()
            ],
          ),
        ),
      ),
    );
  }

  Widget selectPlan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "selectPlan".tr,
            textAlign: TextAlign.center,
            style: Style.montserratRegular(
              fontSize: Dimens.d16,
            ),
          ),
          Dimens.d10.spaceHeight,
          Text(
            "discountsSub".tr,
            style: Style.montserratRegular(
              fontSize: Dimens.d12,
            ),
          ),
          Dimens.d30.spaceHeight,
          SingleChildScrollView(
            child: Obx(
              () => ListView.builder(
                itemCount: subscriptionController.selectPlan.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var data = subscriptionController.selectPlan[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        for (int i = 0;
                            i < subscriptionController.plan.length;
                            i++) {
                          subscriptionController.plan[i] = i == index;
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: subscriptionController.plan[index] == true
                              ? ColorConstant.color7C9EA7.withOpacity(0.20)
                              : themeController.isDarkMode.isTrue
                                  ? ColorConstant.textfieldFillColor
                                  : ColorConstant.white.withOpacity(0.9),
                          border: Border.all(
                              color: subscriptionController.plan[index] == true
                                  ? themeController.isDarkMode.isTrue
                                      ? ColorConstant.themeColor
                                      : ColorConstant.themeColor
                                  : themeController.isDarkMode.isTrue
                                      ? ColorConstant.colorE3E1E1
                                          .withOpacity(0.2)
                                      : ColorConstant.colorE3E1E1,
                              width: 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              subscriptionController.plan[index] == true
                                  ? SvgPicture.asset(
                                      ImageConstant.subscriptionCheck,
                                      height: Dimens.d24,
                                      width: Dimens.d24,
                                    )
                                  : Container(
                                      height: Dimens.d24,
                                      width: Dimens.d24,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: themeController
                                                      .isDarkMode.isTrue
                                                  ? ColorConstant.colorE3E1E1
                                                      .withOpacity(0.2)
                                                  : ColorConstant.colorE3E1E1)),
                                    ),
                              Dimens.d10.spaceWidth,
                              Text(
                                data["plan"],
                                style: Style.montserratBold(fontSize: 14),
                              )
                            ],
                          ),
                          Dimens.d5.spaceHeight,
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: Text(
                              data["des"],
                              style: Style.montserratRegular(
                                  fontSize: 13,
                                  color: ColorConstant.color797777),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Dimens.d40.spaceHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: CommonElevatedButton(
              title: "purchase".tr,
              onTap: () {},
            ),
          ),
          Dimens.d20.spaceHeight,
          Center(
            child: Text(
              "restorePurchase".tr,
              textAlign: TextAlign.center,
              style: Style.montserratRegular(
                fontSize: Dimens.d15,
              ),
            ),
          ),
          Dimens.d33.spaceHeight,
          Text(
            textAlign: TextAlign.center,
            "trailEnds".tr,
            style: Style.montserratRegular(
              fontSize: Dimens.d11,
            ),
          ),
          Dimens.d40.spaceHeight,
        ],
      ),
    );
  }
}
