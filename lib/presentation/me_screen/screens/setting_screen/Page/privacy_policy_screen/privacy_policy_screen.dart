import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/privacy_policy_screen/privacy_policy_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PrivacyPolicyController controller = Get.put(PrivacyPolicyController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.backGround,
        appBar: CustomAppBar(title: "privacySettings".tr),
        body: SingleChildScrollView(
          child: Stack(
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
                    padding: const EdgeInsets.only(top: Dimens.d400),
                    child: SvgPicture.asset(ImageConstant.profile2),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Dimens.d30.spaceHeight,
                    /*   commonText("account"),
                    Dimens.d20.spaceHeight,
                    Container(
                      decoration: BoxDecoration(
                        color: ColorConstant.transparent,
                        borderRadius: BorderRadius.circular(Dimens.d16),
                      ),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          var data = controller.privacyData[index];
                          return SettingListItem(
                            isSettings: true,
                            prefixIcon: data.prefixIcon,
                            title: data.title,
                            suffixIcon: data.suffixIcon,
                            onTap: () {
                              if (index == 0) {
                                Get.toNamed(AppRoutes.editProfileScreen);
                              } else if (index == 1) {
                                Get.toNamed(AppRoutes.changePassword);
                              } else {
                                // Get.toNamed(AppRoutes.personalizationScreen);
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) => Padding(
                          padding: Dimens.d20.paddingHorizontal,
                          child: const SizedBox(
                            height: Dimens.d20,
                          ),
                        ),
                        itemCount: controller.privacyData.length,
                      ),
                    ),*/

                    commonText("PrivacyPolicy"),
                    Dimens.d10.spaceHeight,
                    Text(
                      "1. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                      style: Style.montserratRegular(fontSize: 14)
                          .copyWith(height: 2),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonText(String title) {
    return Text(
      title.tr,
      style: Style.cormorantGaramondBold(fontSize: 18),
    );
  }
}
