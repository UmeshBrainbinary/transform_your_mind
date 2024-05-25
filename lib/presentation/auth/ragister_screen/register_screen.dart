import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/string_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class RegisterScreen extends StatelessWidget {
   RegisterScreen({super.key});

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorConstant.backGround,
      appBar: CustomAppBar(
        title: StringConstant.login,
      ),
      body: SafeArea(
          child: Stack(
            children: [

              Positioned(
                top: Dimens.d70.h,
                right: null,
                left:  0,
                child: Transform.scale(

                  child: Image.asset(ImageConstant.bgStar, height: Dimens.d274.h),
                ),
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
                                        controller: registerController.emailController,
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
                                      valueListenable: registerController.securePass,
                                      builder: (context, value, child) {
                                        return CommonTextField(
                                          labelText: StringConstant.password,
                                          hintText: StringConstant.enterPassword,
                                          controller: registerController.passwordController,
                                          validator: (value) {
                                            if (value == null || (!isValidPassword(value, isRequired: true))) {
                                              return StringConstant.thePasswordFieldIsRequired;
                                            }
                                            return null;
                                          },
                                          focusNode: FocusNode(),
                                          prefixIcon: Image.asset(ImageConstant.lock, scale: Dimens.d4),
                                          suffixIcon: registerController.securePass.value
                                              ? GestureDetector(
                                              onTap: (){
                                                registerController.securePass.value = !registerController.securePass.value;
                                              },
                                              child: Image.asset(ImageConstant.eyeClose, scale: Dimens.d5))

                                              : GestureDetector(
                                              onTap: (){
                                                registerController.securePass.value = !registerController.securePass.value;
                                              },
                                              child:   Image.asset(ImageConstant.eyeOpen, scale: Dimens.d4)),
                                          isSecure: value,
                                          //suffixTap: () => loginController.securePass.value = !loginController.securePass.value,
                                          textInputAction: TextInputAction.done,
                                        );
                                      },
                                    ),

                                    Dimens.d80.h.spaceHeight,
                                    Obx(
                                          () =>  (registerController.loader.value)
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
            ],
          )
      ),
    );
  }
}
