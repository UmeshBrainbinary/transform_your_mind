import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/account_screen/account_controller.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/setting_screen.dart';
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
            top: Dimens.d200.h,
            right: null,
            left: 0,
            child: Transform.rotate(
              angle: 3.14,
              child: Image.asset(ImageConstant.bgStar, height: Dimens.d274.h),
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
                      return SettingListItem(
                        isSettings: false,
                        prefixIcon: data.prefixIcon,
                        title: data.title,
                        //suffixIcon: data.suffixIcon,
                        onTap: () {
                          //_handleSettingsTap(index);
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
