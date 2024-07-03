import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/forgot_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   ForgotController forgotController = Get.put(ForgotController());

  ThemeController themeController = Get.find<ThemeController>();
   @override
  void initState() {
   forgotController.emailController.clear();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? ColorConstant.darkBackground
              : ColorConstant.backGround,
          appBar: CustomAppBar(
            title: "forgotP".tr,
          ),
          body: Padding(
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
                              Dimens.d34.spaceHeight,
                              SizedBox(
                                width: Dimens.d296,
                                child: Text(
                                    textAlign: TextAlign.center,
                                    "forgotInstructions".tr,
                                    style: Style.montserratRegular(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.color716B6B)),
                              ),
                              Dimens.d41.spaceHeight,
                              CommonTextField(
                                  labelText: "email".tr,
                                  hintText: "enterEmail".tr,
                                  controller: forgotController.emailController,
                                  focusNode: forgotController.emailFocus,
                                  prefixIcon: Image.asset(ImageConstant.email,
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
                              Dimens.d100.spaceHeight,
                              CommonElevatedButton(
                                title: "send".tr,
                                onTap: () async {
                                  forgotController.emailFocus.unfocus();
                                //  showSnackBarSuccessForgot(context, "otpSend".tr);

                                  if (_formKey.currentState!.validate()) {
                                       await  forgotController
                                            .forgotPasswordButton(context);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                );
              },
            ),
          ),
        ),
        Obx(
              () => forgotController.loader.isTrue
              ? commonLoader()
              : const SizedBox(),
        )
      ],
    );
  }
}
