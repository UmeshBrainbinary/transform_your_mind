

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
      return AlertDialog(
        //backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11.0), // Set border radius
        ),
        actions: <Widget> [
          Dimens.d10.spaceHeight,

          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgPicture.asset(ImageConstant.close))),
          Dimens.d44.spaceHeight,
          Center(child: SvgPicture.asset(ImageConstant.logOutCheck)),
          Dimens.d30.spaceHeight,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              message,textAlign: TextAlign.center,
              style: Style.montserratRegular(
                height: Dimens.d1_8,
              ),
            ),
          ),
          Dimens.d24.spaceHeight,
          Row(children: [
            const Spacer(),
            CommonElevatedButton(
              textStyle:
              Style.montserratRegular(
                  fontSize: Dimens.d14, color: ColorConstant.white),
              height: 33,
              title: secondaryBtnTitle!,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: Dimens.d32,
              ),
              onTap:
              secondaryBtnAction ?? () => Navigator.pop(context),
            ),
            const Spacer(),
           GestureDetector(onTap: () {
             Get.back();
           },
             child: Container(height: 33,
               padding: const EdgeInsets.symmetric(horizontal: 36),
               decoration: BoxDecoration(color:themeController!.isDarkMode.isTrue?ColorConstant.textfieldFillColor: ColorConstant.white,
               border: Border.all(color: themeController.isDarkMode.isTrue?ColorConstant.themeColor:ColorConstant.black,width: 0.5),
               borderRadius: BorderRadius.circular(60)),
               child: Center(child:
               Text(
                 "no".tr,
                 textAlign: TextAlign.center,
                 style:
                     Style.montserratRegular(
                         fontSize: Dimens.d14, color: themeController.isDarkMode.isTrue?ColorConstant.white:ColorConstant.black),
               ),),
             ),
           ),

            const Spacer(),

          ],)

        ],
      );
    },
  );
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        //backgroundColor: ColorConstant.transparent,
        alignment: Alignment.center,
        insetPadding: Dimens.d20.paddingAll,
        child: Container(
          padding: Dimens.d20.paddingAll,
          decoration: BoxDecoration(
            //color: ColorConstant.white,
            borderRadius: Dimens.d5.radiusAll,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(ImageConstant.close))),
              Dimens.d44.spaceHeight,
              Center(child: SvgPicture.asset(ImageConstant.logOutCheck)),
              Dimens.d30.spaceHeight,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  message,
                  style: Style.montserratRegular(
                    height: Dimens.d1_8,
                  ),
                ),
              ),
              Dimens.d24.spaceHeight,
              if (!showSingleButton)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    CommonElevatedButton(
                      title: primaryBtnTitle ?? "Ok".tr,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Dimens.d32,
                      ),
                      onTap: primaryBtnAction ?? () => Navigator.pop(context),
                    ),
                    if (secondaryBtnTitle?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(left: Dimens.d16),
                        child: CommonElevatedButton(
                          title: secondaryBtnTitle!,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Dimens.d32,
                          ),
                          onTap: secondaryBtnAction ??
                              () => Navigator.pop(context),
                        ),
                      ),
                  ],
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (secondaryBtnTitle?.isNotEmpty ?? false)
                      CommonElevatedButton(
                        title: secondaryBtnTitle!,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Dimens.d32,
                        ),
                        onTap:
                            secondaryBtnAction ?? () => Navigator.pop(context),
                      ),
                  ],
                )
            ],
          ),
        ),
      );
    },
  );
}
