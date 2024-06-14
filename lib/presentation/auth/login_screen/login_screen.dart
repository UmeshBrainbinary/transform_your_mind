import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/progress_dialog_utils.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

   final LoginController loginController = Get.put(LoginController());
   GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   ThemeController themeController = Get.find<ThemeController>();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeController.isDarkMode.value
            ? ColorConstant.black
            : ColorConstant.backGround,
        appBar: CustomAppBar(
          showBack: false,
          title: "login".tr,
        ),
        body: Stack(
          children: [
            !themeController.isDarkMode.value
                ? Positioned(
                    top: Dimens.d70.h,
                    right: 0,
                    left: null,
                    child: Image.asset(ImageConstant.bgStar,
                        height: Dimens.d274.h),
                  )
                : const SizedBox(),
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
                                  Dimens.d100.h.spaceHeight,
                                  CommonTextField(
                                      labelText: "email".tr,
                                      hintText: "enterEmail".tr,
                                      controller:
                                          loginController.emailController,
                                      focusNode: FocusNode(),
                                      prefixIcon: Image.asset(
                                          ImageConstant.email,
                                          scale: Dimens.d4),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == "") {
                                          return "theEmailFieldIsRequired".tr;
                                        } else if (!isValidEmail(value,
                                            isRequired: true)) {
                                          return "pleaseEnterValidEmail".tr;
                                        }
                                        return null;
                                      }),
                                  Dimens.d24.h.spaceHeight,
                                  ValueListenableBuilder(
                                    valueListenable: loginController.securePass,
                                    builder: (context, value, child) {
                                      return CommonTextField(
                                        labelText: "password".tr,
                                        hintText: "enterPassword".tr,
                                        controller:
                                            loginController.passwordController,
                                        onChanged: (value) {
                                          _formKey.currentState!.validate();
                                        },
                                        validator: (value) {
                                          if (value == "") {
                                            return "thePasswordFieldIsRequired"
                                                .tr;
                                          } else if (!isValidPassword(value,
                                              isRequired: true)) {
                                            return "pleaseEnterValidPassword"
                                                .tr;
                                          }
                                          return null;
                                        },
                                        focusNode: FocusNode(),
                                        prefixIcon: Image.asset(
                                            ImageConstant.lock,
                                            scale: Dimens.d4),
                                        suffixIcon: GestureDetector(
                                            onTap: () {
                                              loginController.securePass.value =
                                                  !loginController
                                                      .securePass.value;
                                            },
                                            child: Transform.scale(
                                              scale: 0.38,
                                              child: Image.asset(
                                                loginController.securePass.value
                                                    ? ImageConstant.eyeClose
                                                    : ImageConstant.eyeOpen,
                                                fit: BoxFit.contain,
                                                height: 5,
                                                width: 5,
                                              ),
                                            )),
                                        isSecure: value,
                                        //suffixTap: () => loginController.securePass.value = !loginController.securePass.value,
                                        textInputAction: TextInputAction.done,
                                      );
                                    },
                                  ),
                                  Dimens.d20.h.spaceHeight,
                                  _getRememberMeForgotPasswordWidget,
                                  Dimens.d80.h.spaceHeight,
                                  CommonElevatedButton(
                                    title: "login".tr,
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();

                                      if (_formKey.currentState!
                                          .validate()) {
                                        loginController
                                            .onTapLogin(context);
                                      }
                                    },
                                  ),
                                  Dimens.d30.h.spaceHeight,
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${"doNotHaveAnAccount".tr} ?",
                                          style: Style.montserratRegular(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? ColorConstant.white
                                                  : ColorConstant.black),
                                        ),
                                        const WidgetSpan(
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.all(Dimens.d4)),
                                        ),
                                        TextSpan(
                                          text: "register".tr,
                                          style: Style.montserratSemiBold(
                                            color: ColorConstant.themeColor,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.toNamed(
                                                AppRoutes.registerScreen,
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
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
            Obx(
              () => loginController.loader.isTrue
                  ? const CommonLoader()
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }

   Widget get _getRememberMeForgotPasswordWidget => GestureDetector(
     onTap: () => loginController.rememberMe.value = !loginController.rememberMe.value,
     child: Padding(
       padding: const EdgeInsets.symmetric(vertical: Dimens.d8),
       child: Row(
         children: [
           ValueListenableBuilder(
             valueListenable: loginController.rememberMe,
             builder: (context, value, child) {
               return GestureDetector(
                 onTap: (){
                   loginController.rememberMe.value = !loginController.rememberMe.value;
                 },
                 child: Container(
                   height: Dimens.d20,
                   width: Dimens.d20,
                   alignment: Alignment.center,
                   decoration: BoxDecoration(
                     border: Border.all(
                         color: loginController.rememberMe.value
                             ? ColorConstant.themeColor
                             : ColorConstant.color545454,
                         width: Dimens.d1),
                     borderRadius:
                     const BorderRadius.all(Radius.circular(Dimens.d3)),
                     color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.white
                   ),
                   child: loginController.rememberMe.value  ? const Icon(Icons.check, color: ColorConstant.themeColor, size: Dimens.d12) : const SizedBox(),


                 ),
               );
             },
           ),
           Dimens.d8.spaceWidth,
           Text(
             "rememberMe".tr,
             style: Style.montserratRegular(color: ColorConstant.color545454, fontWeight: FontWeight.w100),
           ),
           const Spacer(),
           InkWell(
             onTap: (){
               Get.toNamed(
                 AppRoutes.forgotScreen,
               );
             },
             child: Text(
               "${"forgotPassword".tr} ?",
               style: Style.montserratMedium(color: ColorConstant.themeColor),
             ),
           ),
         ],
       ),
     ),
   );



}
