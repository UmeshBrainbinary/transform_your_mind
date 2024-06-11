import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/toast_message.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/forgot_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class VerificationsScreen extends StatelessWidget {
  bool? forgot;

  VerificationsScreen({super.key, this.forgot});

  final ForgotController forgotController = Get.put(ForgotController());

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.black
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "verification".tr,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraint.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Dimens.d25.spaceHeight,
                              SizedBox(
                                width: Dimens.d296,
                                child: Text(
                                    textAlign: TextAlign.center,
                                    "enterVerification".tr,
                                    style: Style.montserratRegular(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.color716B6B)),
                              ),
                              Dimens.d61.spaceHeight,
                              Pinput(
                                length: 6,
                                // Set the number of fields to 6
                                controller: forgotController.otpController,
                                keyboardType: TextInputType.number,
                                defaultPinTheme: PinTheme(
                                  height: 43.h,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: Dimens.d3),
                                  width: 43.h,
                                  textStyle: Style.montserratRegular(
                                      fontSize: Dimens.d23,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstant.color716B6B),
                                  decoration: BoxDecoration(
                                    color: themeController.isDarkMode.value
                                        ? ColorConstant.textfieldFillColor
                                        : ColorConstant.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                focusedPinTheme: PinTheme(
                                  height: 43.h,
                                  width: 43.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors
                                            .black), // Set border color to black when focused
                                  ),
                                  textStyle: Style.montserratRegular(
                                      fontSize: Dimens.d23,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstant.color716B6B),
                                ),
                              ),
                              Dimens.d23.spaceHeight,
                              SizedBox(
                                height: Dimens.d24,
                                width: Dimens.d296,
                                child: Text(
                                    textAlign: TextAlign.center,
                                    "notReceiveCode".tr,
                                    style: Style.montserratRegular(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.color716B6B)),
                              ),
                              Dimens.d83.spaceHeight,
                              CommonElevatedButton(
                                title: "verify".tr,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (forgotController
                                      .otpController.text.isNotEmpty) {
                                    if (forgot == true) {
                                      forgotController.onTapOtpVerifyChangePass(context);
                                    } else {
                                      forgotController.onTapOtpVerify(context);
                                    }
                                  } else {
                                    errorToast(
                                        "pleaseEnterVerificationCode".tr);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Obx(
            () => forgotController.loader.isTrue
                ? commonLoader()
                : const SizedBox(),
          )
        ],
      )),
    );
  }
}
