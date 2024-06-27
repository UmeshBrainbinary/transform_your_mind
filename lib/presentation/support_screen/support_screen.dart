import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/setting_screen.dart';
import 'package:transform_your_mind/presentation/support_screen/contact_support_screen.dart';
import 'package:transform_your_mind/presentation/support_screen/faq_screen.dart';
import 'package:transform_your_mind/presentation/support_screen/support_controller.dart';
import 'package:transform_your_mind/presentation/support_screen/trouble_guide_screen.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

import '../../theme/theme_controller.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    SupportController supportController =Get.put(SupportController());
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: const CustomAppBar(title: "Support"),
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
                  padding: const EdgeInsets.only(bottom: Dimens.d120),
                  child: SvgPicture.asset(ImageConstant.profile2),
                )),
            ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 50, top: 30),
              children: [
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
                      var data = supportController.supportData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SettingListItem(
                          isSettings: true,
                          prefixIcon: data.prefixIcon,
                          title: data.title,
                          suffixIcon: data.suffixIcon,
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const FaqScreen();
                              },));
                            } else if (index == 1) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const ContactSupportScreen();
                                },));
                            } else  {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const TroubleGuideScreen();
                                },));
                            }
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                      padding: Dimens.d20.paddingHorizontal,
                      child: const SizedBox(
                        height: 15,
                      ),
                    ),
                    itemCount: supportController.supportData.length,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




