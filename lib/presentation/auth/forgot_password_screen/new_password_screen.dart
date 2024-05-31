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
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/forgot_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class NewPasswordScreen extends StatelessWidget {
  NewPasswordScreen({super.key});

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ForgotController forgotController = Get.put(ForgotController());

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ?  ColorConstant.black : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "newPassword".tr,
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
                      child: Form(
                        key: _formKey,
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
                                    "enterNewPassword".tr,
                                    style: Style.montserratRegular(
                                        fontSize: Dimens.d14,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.color716B6B)),
                                Dimens.d50.spaceHeight,

                                ValueListenableBuilder(
                                  valueListenable: forgotController.securePass,
                                  builder: (context, value, child) {
                                    return CommonTextField(
                                      labelText: "newPassword".tr,
                                      hintText: "enterNewPasswordHint".tr,
                                      controller: forgotController.newPController,
                                      validator: (value) {
                                        if (value == "") {
                                          return "thePasswordFieldIsRequired".tr;
                                        } else if(!isValidPassword(value, isRequired: true)){
                                          return "pleaseEnterValidPassword".tr;
                                        }
                                        return null;
                                      },
                                      focusNode: FocusNode(),
                                      prefixIcon: Image.asset(ImageConstant.lock, scale: Dimens.d4),
                                      suffixIcon: GestureDetector(
                                          onTap: (){
                                            forgotController.securePass.value = !forgotController.securePass.value;
                                          },
                                          child: Transform.scale(
                                            scale: 0.38,
                                            child: Image.asset(
                                              forgotController.securePass.value
                                                  ? ImageConstant.eyeClose
                                                  : ImageConstant.eyeOpen,
                                              fit: BoxFit.contain,
                                              height: 5,
                                              width: 5,
                                            ),
                                          )
                                      ),
                                      isSecure: value,
                                      textInputAction: TextInputAction.done,
                                    );
                                  },
                                ),
                                Dimens.d23.spaceHeight,
                                ValueListenableBuilder(
                                  valueListenable: forgotController.securePass2,
                                  builder: (context, value, child) {
                                    return CommonTextField(
                                      labelText: "confirmPassword".tr,
                                      hintText: "enterConfirmPasswordHint".tr,
                                      controller: forgotController.confirmPController,
                                      validator: (value) {
                                        if (value == "") {
                                          return "thePasswordFieldIsRequired".tr;
                                        } else if(value != forgotController.newPController.text){
                                           return "passwordsDoNotMatch".tr;
                                        } else if(!isValidPassword(value, isRequired: true)){
                                          return "pleaseEnterValidPassword".tr;
                                        }
                                        return null;
                                      },
                                      focusNode: FocusNode(),
                                      prefixIcon: Image.asset(ImageConstant.lock, scale: Dimens.d4),
                                      suffixIcon: GestureDetector(
                                          onTap: (){
                                            forgotController.securePass2.value = !forgotController.securePass2.value;
                                          },
                                          child: Transform.scale(
                                            scale: 0.38,
                                            child: Image.asset(
                                              forgotController.securePass2.value
                                                  ? ImageConstant.eyeClose
                                                  : ImageConstant.eyeOpen,
                                              fit: BoxFit.contain,
                                              height: 5,
                                              width: 5,
                                            ),
                                          )
                                      ),
                                      isSecure: value,
                                      textInputAction: TextInputAction.done,
                                    );
                                  },
                                ),
                                Dimens.d120.spaceHeight,
                                CommonElevatedButton(
                                  title: "submit".tr,
                                  onTap: () {


                                    FocusScope.of(context).unfocus();

                                    if (_formKey.currentState!.validate()) {
                                     _showAlertDialog(context);
                                    }


                                  },
                                )
                              ],
                            ),
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
          //backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          actions: <Widget>[
            Dimens.d27.spaceHeight,
            Center(child: SvgPicture.asset(ImageConstant.passwordCheck,height: Dimens.d100, width: Dimens.d100,)),
            Dimens.d8.spaceHeight,

            Center(
              child: Text("passwordChanged".tr,
                  textAlign: TextAlign.center,
                  style: Style.cormorantGaramondBold(
                      fontSize: Dimens.d22,
                      fontWeight: FontWeight.w700,
                     )),
            ),
            Dimens.d7.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                 "yourPassword".tr,
                  style: Style.montserratRegular(
                      fontSize: Dimens.d12,
                      fontWeight: FontWeight.w400,
                     )),
            ),
            Dimens.d31.spaceHeight,
            Padding(
              padding:   EdgeInsets.symmetric(horizontal: Dimens.d70.h),
              child: CommonElevatedButton(title: "ok".tr, onTap: () {
                Get.back();
              },),
            )
          ],
        );
      },
    );
  }
}
