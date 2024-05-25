import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/string_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

   final LoginController loginController = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "Login",
      ),
      body: SafeArea(
          child: Stack(
            children: [

            Positioned(
              top: Dimens.d70.h,
              right: 0,
              left:  null,
              child: Image.asset(ImageConstant.bgStar, height: Dimens.d274.h),
            ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraint.maxHeight),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Dimens.d10.h.spaceHeight,
                                  CommonTextField(
                                    labelText: StringConstant.email,
                                    hintText: StringConstant.enterEmail,
                                    controller: loginController.emailController,
                                    focusNode: FocusNode(),

                                    prefixIcon: Image.asset(ImageConstant.email, scale: Dimens.d4),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  Dimens.d16.h.spaceHeight,
                                  ValueListenableBuilder(
                                    valueListenable: loginController.securePass,
                                    builder: (context, value, child) {
                                      return CommonTextField(
                                        labelText: StringConstant.password,
                                        hintText: StringConstant.enterPassword,
                                        controller: loginController.passwordController,
                                        focusNode: FocusNode(),
                                        prefixIcon: Image.asset(ImageConstant.lock, scale: Dimens.d4),
                                         suffixIcon: value ? Image.asset(ImageConstant.eyeOpen, scale: Dimens.d4) : Image.asset(ImageConstant.eyeClose, scale: Dimens.d4) ,
                                         isSecure: value,
                                         suffixTap: () => loginController.securePass.value = !loginController.securePass.value,
                                        textInputAction: TextInputAction.done,
                                      );
                                    },
                                  ),
                                  Dimens.d8.h.spaceHeight,

                                  _getRememberMeWidget,
                                  Dimens.d8.h.spaceHeight,
                                  // Row(
                                  //   children: [
                                  //     const Spacer(),
                                  //     Padding(
                                  //       padding: Dimens.d8.paddingVertical,
                                  //       child: RichText(
                                  //         text: TextSpan(
                                  //           text: i10n.forgotPasswordQue,
                                  //           style: Style.mockinacRegular(
                                  //             fontSize: Dimens.d14,
                                  //             color:
                                  //             themeManager.colorThemed7,
                                  //           ),
                                  //           recognizer: TapGestureRecognizer()
                                  //             ..onTap = () =>
                                  //                 Navigator.pushNamed(
                                  //                     context,
                                  //                     ForgotPasswordPage
                                  //                         .forgotPassword),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // Dimens.d24.h.spaceHeight,
                                  //
                                  // BlocBuilder<LoginBloc, LoginState>(
                                  //   bloc: loginBloc,
                                  //   builder: (context, state) {
                                  //     return (_isLoading)
                                  //         ? const LoadingButton()
                                  //         : CommonElevatedButton(
                                  //       title: i10n.login,
                                  //       onTap: _doLogin,
                                  //     );
                                  //   },
                                  // ),
                                  // Dimens.d30.h.spaceHeight,
                                  // Row(
                                  //   children: [
                                  //     const Expanded(child: DividerWidget()),
                                  //     Padding(
                                  //       padding:
                                  //       const EdgeInsets.all(Dimens.d8),
                                  //       child: Text(
                                  //         i10n.or,
                                  //         style: Style.mockinacRegular(
                                  //           color: themeManager.colorThemed7,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     const Expanded(child: DividerWidget()),
                                  //   ],
                                  // ),
                                  // Dimens.d30.h.spaceHeight,
                                  // Row(
                                  //   mainAxisAlignment:
                                  //   MainAxisAlignment.center,
                                  //   children: [
                                  //     if (Platform.isIOS &&
                                  //         _isiOSSignInAvailable)
                                  //       LoginWithIconButton(
                                  //         icon: AppAssets.icApple,
                                  //         onTap: () {
                                  //           _appleSigIn();
                                  //         },
                                  //       ),
                                  //     Dimens.d16.spaceWidth,
                                  //     LoginWithIconButton(
                                  //       icon: AppAssets.icGoogle,
                                  //       onTap: () {
                                  //         _googleSignInOut();
                                  //       },
                                  //     ),
                                  //     Dimens.d16.spaceWidth,
                                  //     LoginWithIconButton(
                                  //       icon: AppAssets.icFacebook,
                                  //       onTap: () {
                                  //         _faceBookSignIn();
                                  //       },
                                  //     ),
                                  //   ],
                                  // ),
                                  // Dimens.d24.h.spaceHeight,
                                  // const Spacer(),
                                  // RichText(
                                  //   text: TextSpan(
                                  //     children: [
                                  //       TextSpan(
                                  //         text: i10n.newToTheApp,
                                  //         style: Style.mockinacLight(
                                  //           color: themeManager.colorThemed7,
                                  //         ),
                                  //       ),
                                  //       const WidgetSpan(
                                  //         child: Padding(
                                  //             padding:
                                  //             EdgeInsets.all(Dimens.d4)),
                                  //       ),
                                  //       TextSpan(
                                  //         text: i10n.register,
                                  //         style: Style.mockinacLight(
                                  //           color: themeManager.colorThemed5,
                                  //         ),
                                  //         recognizer: TapGestureRecognizer()
                                  //           ..onTap = () {
                                  //             Navigator.pushReplacementNamed(
                                  //                 context,
                                  //                 RegisterPage.register);
                                  //           },
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),

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
          )
      ),
    );
  }

   Widget get _getRememberMeWidget => GestureDetector(
     onTap: () => loginController.rememberMe.value = !loginController.rememberMe.value,
     child: Padding(
       padding: const EdgeInsets.symmetric(vertical: Dimens.d8),
       child: Row(
         children: [
           ValueListenableBuilder(
             valueListenable: loginController.rememberMe,
             builder: (context, value, child) {
               return Container(
                 height: Dimens.d20,
                 width: Dimens.d20,
                 decoration: BoxDecoration(
                   border: Border.all(
                       color: loginController.rememberMe.value
                           ? ColorConstant.themeColor
                           : ColorConstant.color545454,
                       width: Dimens.d1),
                   borderRadius:
                   const BorderRadius.all(Radius.circular(Dimens.d6)),
                 ),
                 child: Checkbox(
                   value: value,
                   checkColor: ColorConstant.themeColor,
                   activeColor: ColorConstant.themeColor.withOpacity(Dimens.d0_05),
                   onChanged: (value) {
                     loginController.rememberMe.value = !loginController.rememberMe.value;
                   },
                   shape: const RoundedRectangleBorder(
                     borderRadius:
                     BorderRadius.all(Radius.circular(Dimens.d6)),
                   ),
                 ),
               );
             },
           ),
           Dimens.d8.spaceWidth,
           Text(
             StringConstant.rememberMe,
             style: Style.montserratRegular(color: ColorConstant.color545454),
           )
         ],
       ),
     ),
   );

}
