

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

Future<void> showAppConfirmationDialog({
  required BuildContext context,
  required String message,
  String? primaryBtnTitle,
  VoidCallback? primaryBtnAction,
  String? secondaryBtnTitle,
  VoidCallback? secondaryBtnAction,
  bool showSingleButton = false,
  ThemeController? themeController
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(contentPadding: EdgeInsets.zero,
        backgroundColor: themeController!.isDarkMode.isTrue?ColorConstant.darkBackground:Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11.0), // Set border radius
        ),
      content: Column(mainAxisSize: MainAxisSize.min,
        children: [
        Dimens.d10.spaceHeight,

        Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(ImageConstant.close,color:themeController.isDarkMode.isTrue?Colors.white:Colors.black ,),
                ))),
        Dimens.d44.spaceHeight,
        Center(child: SvgPicture.asset(ImageConstant.logOutCheck)),
        Dimens.d30.spaceHeight,

        Padding(
          padding: const EdgeInsets.symmetric(horizontal:72.0),
          child: Text(
            message,textAlign: TextAlign.center,
            style: Style.nunRegular(
              height: Dimens.d1_8,
            ),
          ),
        ),
        Dimens.d24.spaceHeight,
        Row(children: [
          const Spacer(),
          CommonElevatedButton(
            textStyle:
            Style.nunRegular(
                fontSize: Dimens.d14, color: ColorConstant.white),
            height: 33,width: 93,
            title: secondaryBtnTitle!,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimens.d32,
            ),
            onTap:
            secondaryBtnAction ?? () => Navigator.pop(context),
          ),
          Dimens.d20.spaceWidth,
          GestureDetector(onTap: () {
            Get.back();
          },
            child: Container(            height: 33,

              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  color:themeController.isDarkMode.isTrue?Colors.transparent: ColorConstant.white,
                  border: Border.all(color: themeController.isDarkMode.isTrue?ColorConstant.themeColor:ColorConstant.black,width: 0.5),
                  borderRadius: BorderRadius.circular(60)),
              child: Center(child:
              Text(
                "no".tr,
                textAlign: TextAlign.center,
                style:
                Style.nunRegular(
                    fontSize: Dimens.d14, color: themeController.isDarkMode.isTrue?ColorConstant.white:ColorConstant.black),
              ),),
            ),
          ),

          const Spacer(),

        ],),
        Dimens.d20.spaceHeight,
      ],),
      );
    },
  );
}
