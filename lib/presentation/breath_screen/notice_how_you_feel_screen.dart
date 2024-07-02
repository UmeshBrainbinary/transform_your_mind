import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/breath_screen/breath_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

class NoticeHowYouFeelScreen extends StatelessWidget {
  bool? notice;
  bool? setting;
   NoticeHowYouFeelScreen({super.key,this.notice,this.setting});

  @override
  Widget build(BuildContext context) {
    BreathController breathController = Get.put(BreathController());
    ThemeController themeController = Get.find<ThemeController>();
    //statusBarSet(themeController);
    return Scaffold(backgroundColor:  themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Dimens.d10.spaceHeight,
            Image.asset(ImageConstant.noticeImage,height: 222,width: 222,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d40),
              child: Text(
                "noticeHowYouFeel".tr,
                textAlign: TextAlign.center,
                style: Style.gothamMedium(fontSize: 22),
              ),
            ),
            Dimens.d18.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d45),
              child: Text(
                "allowYourSelf".tr,
                textAlign: TextAlign.center,
                style: Style.gothamLight(
                    fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
            Dimens.d30.spaceHeight,
            GetBuilder<BreathController>(
              id: "update",
              builder: (controller) {
                return ListView.builder(
                  itemCount: controller.feel.length,
                  shrinkWrap: true,padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => controller.toggleSelection(index),
                      child: Container(height: Dimens.d45,
                        margin: const EdgeInsets.symmetric(horizontal: Dimens.d70,vertical: Dimens.d8),

                        decoration: BoxDecoration(
                          color: ColorConstant.colorBFD0D4,
                          border: Border.all(
                            color: !controller.selectedIndices.contains(index)
                                ? ColorConstant.colorBFD0D4
                                : ColorConstant.themeColor,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: Center(
                          child: Text(
                            controller.feel[index],
                            style:Style.montserratRegular(fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Dimens.d30.spaceHeight,
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: CommonElevatedButton(
                title: "explorer".tr,
                onTap: () {
                  if(setting==true){
                    Get.back();
                    Get.back();
                  }else{
                    if(!notice!){
                      Get.offAllNamed(AppRoutes.dashBoardScreen);
                    }else{
                      Get.offAllNamed(AppRoutes.selectYourFocusPage);
                    }
                  }

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
