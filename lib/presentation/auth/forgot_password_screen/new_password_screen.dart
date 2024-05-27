import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/string_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/forgot_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class NewPasswordScreen extends StatelessWidget {
  NewPasswordScreen({super.key});

  ForgotController forgotController = Get.put(ForgotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backGround,
      appBar: CustomAppBar(
        title: StringConstant.newPassword,
      ),
      body: SafeArea(
          child: Stack(
        children: [
/*
              Positioned(
                top: Dimens.d70.h,
                right: 0,
                left:  null,
                child: Image.asset(ImageConstant.bgStar, height: Dimens.d274.h),
              ),*/
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
                              Text(
                                  textAlign: TextAlign.center,
                                  StringConstant.enterNewPassword,
                                  style: Style.montserratRegular(
                                      fontSize: Dimens.d14,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstant.color716B6B)),
                              Dimens.d50.spaceHeight,
                              CommonTextField(
                                labelText: StringConstant.newPassword,
                                hintText: StringConstant.enterNewPasswordHint,
                                controller: forgotController.newPController,
                                focusNode: FocusNode(),
                                prefixIcon: Image.asset(ImageConstant.email,
                                    scale: Dimens.d4),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Dimens.d23.spaceHeight,
                              CommonTextField(
                                labelText: StringConstant.confirmPassword,
                                hintText:
                                    StringConstant.enterConfirmPasswordHint,
                                controller: forgotController.confirmPController,
                                focusNode: FocusNode(),
                                prefixIcon: Image.asset(ImageConstant.email,
                                    scale: Dimens.d4),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Dimens.d120.spaceHeight,
                              CommonElevatedButton(
                                title: StringConstant.submit,
                                onTap: () {
                                  _showAlertDialog(context);
                                  /*Get.toNamed(AppRoutes.newPasswordScreen);*/
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //commonGradiantContainer(color: AppColors.backgroundWhite, h: 20)
                  ],
                );
              },
            ),
          ),
        ],
      )),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          actions: <Widget>[
            Dimens.d27.spaceHeight,
            Center(child: SvgPicture.asset(ImageConstant.passwordCheck,height: Dimens.d100, width: Dimens.d100,)),
            Dimens.d8.spaceHeight,

            Center(
              child: Text(StringConstant.passwordChanged,
                  textAlign: TextAlign.center,
                  style: Style.cormorantGaramondBold(
                      fontSize: Dimens.d22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ),
            Dimens.d7.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  StringConstant.yourPassword,
                  style: Style.montserratRegular(
                      fontSize: Dimens.d12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
            ),
            Dimens.d31.spaceHeight,
            Padding(
              padding:   EdgeInsets.symmetric(horizontal: Dimens.d70.h),
              child: CommonElevatedButton(title: StringConstant.ok, onTap: () {
                Get.back();
              },),
            )
          ],
        );
      },
    );
  }
}
