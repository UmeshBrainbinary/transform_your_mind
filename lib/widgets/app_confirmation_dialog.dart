

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

Future<void> showAppConfirmationDialog({
  required BuildContext context,
  required String message,
  String? primaryBtnTitle,
  VoidCallback? primaryBtnAction,
  String? secondaryBtnTitle,
  VoidCallback? secondaryBtnAction,
  bool showSingleButton = false,
}) {
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
            borderRadius: Dimens.d16.radiusAll,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: Style.montserratRegular(
                  height: Dimens.d1_8,
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
