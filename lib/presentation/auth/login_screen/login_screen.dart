import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/string_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

   final LoginController loginController = Get.put(LoginController());
   GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
                          child: Form(
                            key: _formKey,
                           child: ConstrainedBox(
                             constraints: BoxConstraints(
                                 minHeight: constraint.maxHeight),
                             child: IntrinsicHeight(
                               child: Column(
                                 mainAxisSize: MainAxisSize.max,
                                 children: [
                                   Dimens.d100.h.spaceHeight,
                                   CommonTextField(
                                       labelText: StringConstant.email,
                                       hintText: StringConstant.enterEmail,
                                       controller: loginController.emailController,
                                       focusNode: FocusNode(),
                                       prefixIcon: Image.asset(ImageConstant.email, scale: Dimens.d4),
                                       keyboardType: TextInputType.emailAddress,
                                       validator: (value) {
                                         if (value == null ||
                                             (!isValidEmail(value, isRequired: true))) {
                                           return StringConstant.theEmailFieldIsRequired;
                                         }
                                         return null;
                                       }
                                   ),
                                   Dimens.d24.h.spaceHeight,
                                   ValueListenableBuilder(
                                     valueListenable: loginController.securePass,
                                     builder: (context, value, child) {
                                       return CommonTextField(
                                         labelText: StringConstant.password,
                                         hintText: StringConstant.enterPassword,
                                         controller: loginController.passwordController,
                                         validator: (value) {
                                           if (value == null || (!isValidPassword(value, isRequired: true))) {
                                             return StringConstant.thePasswordFieldIsRequired;
                                           }
                                           return null;
                                         },
                                         focusNode: FocusNode(),
                                         prefixIcon: Image.asset(ImageConstant.lock, scale: Dimens.d4),
                                         suffixIcon: loginController.securePass.value
                                             ? GestureDetector(
                                             onTap: (){
                                               loginController.securePass.value = !loginController.securePass.value;
                                             },
                                             child: Image.asset(ImageConstant.eyeClose, scale: Dimens.d5))

                                             : GestureDetector(
                                             onTap: (){
                                               loginController.securePass.value = !loginController.securePass.value;
                                             },
                                             child:   Image.asset(ImageConstant.eyeOpen, scale: Dimens.d4)),
                                         isSecure: value,
                                         //suffixTap: () => loginController.securePass.value = !loginController.securePass.value,
                                         textInputAction: TextInputAction.done,
                                       );
                                     },
                                   ),
                                   Dimens.d20.h.spaceHeight,

                                   _getRememberMeForgotPasswordWidget,

                                   Dimens.d80.h.spaceHeight,

                                   Obx(
                                         () =>  (loginController.loader.value)
                                         ? const LoadingButton()
                                         : CommonElevatedButton(
                                       title: StringConstant.login,
                                       onTap: () async{

                                         FocusScope.of(context).unfocus();

                                         if (_formKey.currentState!.validate()) {

                                           //await controller.loginWithEmailAndPassword();

                                         }

                                       },
                                     ),
                                   ),


                                   Dimens.d30.h.spaceHeight,


                                   RichText(
                                     text: TextSpan(
                                       children: [
                                         TextSpan(
                                           text: "${StringConstant.doNotHaveAnAccount} ?",
                                           style: Style.montserratRegular(

                                           ),
                                         ),
                                         const WidgetSpan(
                                           child: Padding(
                                               padding:
                                               EdgeInsets.all(Dimens.d4)),
                                         ),
                                         TextSpan(
                                           text: StringConstant.register,
                                           style: Style.montserratSemiBold(
                                             color: ColorConstant.themeColor,
                                           ),
                                           recognizer: TapGestureRecognizer()
                                             ..onTap = () {
                                               /// go to register screen
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
            ],
          )
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
                     color: ColorConstant.white
                   ),
                   child: loginController.rememberMe.value  ? Icon(Icons.check, color: ColorConstant.themeColor, size: Dimens.d12) : SizedBox(),


                 ),
               );
             },
           ),
           Dimens.d8.spaceWidth,
           Text(
             StringConstant.rememberMe,
             style: Style.montserratRegular(color: ColorConstant.color545454, fontWeight: FontWeight.w100),
           ),
           Spacer(),
           Text(
             "${StringConstant.forgotPassword} ?",
             style: Style.montserratMedium(color: ColorConstant.themeColor),
           ),
         ],
       ),
     ),
   );

}
