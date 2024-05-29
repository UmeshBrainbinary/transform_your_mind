import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/account_screen/account_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';

import 'package:transform_your_mind/widgets/custom_appbar.dart';

class AccountScreen extends StatelessWidget {
   AccountScreen({super.key});

   AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "account".tr),
      body: Stack(
        children: [
          Positioned(
            top: Dimens.d80.h,
            right: null,
            left: 0,
            child: Transform.rotate(
              angle: 3.14,
              child: Image.asset(ImageConstant.bgStar, height: Dimens.d177.h),
            ),
          ),
          Padding(
              padding: Dimens.d20.paddingAll,
            child: Column(
              children: [
                Dimens.d30.spaceHeight,
                Container(
                  decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(Dimens.d16),
                  ),
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
                           if(index==0){
                             Get.toNamed(AppRoutes.editProfileScreen);
                           } else if(index==1){
                            // Get.toNamed(AppRoutes.);
                           }
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                      padding: Dimens.d20.paddingHorizontal,
                      child: const Divider(),
                    ),
                    itemCount: accountController.accountData.length,
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
    required this.prefixIcon,
    required this.title,
    //required this.suffixIcon,
    required this.isSettings,
    this.onTap,
  }) : super(key: key);

  final String prefixIcon;
  final String title;
  //final String suffixIcon;
  final bool isSettings;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return

      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.2),
          decoration: BoxDecoration(
              color: ColorConstant.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                    color: ColorConstant.grey.withOpacity(0.1),
                    blurRadius: 5,spreadRadius: 1
                )
              ]
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.d10,
            vertical: Dimens.d10,
          ),
          child: Row(
            //mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                height: Dimens.d50.h,
                width: Dimens.d50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorConstant.white,
                  shape: BoxShape.circle),
                child: Image.asset(
                  prefixIcon,
                  color: ColorConstant.black,
                ),
              ),
              Dimens.d6.spaceWidth,
              Text(
                title,
                style: Style.cormorantGaramondBold(fontSize: 16).copyWith(
                  letterSpacing: Dimens.d0_16,
                ),
              ),
              Spacer(),
              Transform.rotate(
                  angle: 1.5,
                child: SvgPicture.asset(
                  ImageConstant.icUpArrow,
                  height: Dimens.d18.h,
                  color: Colors.black,
                ),
              ),
              Dimens.d6.spaceWidth,
            ],
          ),
        ),
      );

  }


}
