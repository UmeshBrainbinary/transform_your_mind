import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/personalisations_screen/personalisations_controller.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/setting_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class PersonalisationsScreen extends StatelessWidget {
   PersonalisationsScreen({super.key});

   PersonalisationsController personalisationsController = Get.put(PersonalisationsController());
   ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? ColorConstant.black : ColorConstant.backGround,
      appBar: CustomAppBar(title: "account".tr),
      body: Stack(
        children: [
          /* Positioned(
            top: Dimens.d80.h,
            right: null,
            left: 0,
            child: Transform.rotate(
              angle: 3.14,
              child: Image.asset(ImageConstant.bgStar, height: Dimens.d177.h),
            ),
          ),*/
          Padding(
            padding: Dimens.d20.paddingAll,
            child: Column(
              children: [
                Dimens.d30.spaceHeight,
                Container(
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value ?  ColorConstant.textfieldFillColor : ColorConstant.white,
                    borderRadius: BorderRadius.circular(Dimens.d16),
                  ),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var data = personalisationsController.accountData[index];
                      return AccountListItem(
                        isSettings: false,
                        index: index,
                        title: data.title,
                        //suffixIcon: data.suffixIcon,
                        onTap: () {

                        },
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                      padding: Dimens.d20.paddingHorizontal,
                      child: const Divider(),
                    ),
                    itemCount: personalisationsController.accountData.length,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class AccountListItem extends StatelessWidget {
  AccountListItem({
    Key? key,
    required this.index,
    required this.title,
    //required this.suffixIcon,
    required this.isSettings,
    this.onTap,
  }) : super(key: key);

 final int index;
  final String title;
  //final String suffixIcon;
  final bool isSettings;
  final VoidCallback? onTap;

  ThemeController themeController = Get.find<ThemeController>();
  PersonalisationsController personalisationsController = Get.put(PersonalisationsController());

  @override
  Widget build(BuildContext context) {
    return

      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.2),
          decoration: BoxDecoration(
            color:  themeController.isDarkMode.value ?  ColorConstant.textfieldFillColor : ColorConstant.white,
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
              Spacer(),
              index == 0
              ? CustomSwitch(
                value: themeController.isDarkMode.value,
                onChanged: (value) async{
                  themeController.switchTheme();
                  Get.forceAppUpdate();
                },
                width: 50.0,
                height: 25.0,
                activeColor: ColorConstant.themeColor,
                inactiveColor: ColorConstant.backGround,
              )
              : CustomSwitch(
                value: personalisationsController.language.value,
                onChanged: (value) async{
                  personalisationsController.language.value = value;
                },
                width: 50.0,
                height: 25.0,
                activeColor: ColorConstant.themeColor,
                inactiveColor: ColorConstant.backGround,
              ),
              Dimens.d6.spaceWidth,
            ],
          ),
        ),
      );

  }


}