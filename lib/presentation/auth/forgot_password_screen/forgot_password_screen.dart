import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/string_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/forgot_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotController forgotController = Get.put(ForgotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backGround,
      appBar: CustomAppBar(
        title: StringConstant.forgotP,
      ),
      body: SafeArea(
          child: Stack(
        children: [
      /*    Positioned(
            top: Dimens.d70.h,
            right: 0,
            left: null,
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
                              Dimens.d34.spaceHeight,
                              SizedBox(
                                width: Dimens.d296,
                                child: Text(
                                    textAlign: TextAlign.center,
                                    StringConstant.forgotInstructions,
                                    style: Style.montserratRegular(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.color716B6B)),
                              ),
                              Dimens.d41.spaceHeight,
                              CommonTextField(
                                labelText: StringConstant.email,
                                hintText: StringConstant.enterEmail,
                                controller: forgotController.emailController,
                                focusNode: FocusNode(),
                                prefixIcon: Image.asset(ImageConstant.email,
                                    scale: Dimens.d4),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Dimens.d100.spaceHeight,
                              CommonElevatedButton(title: StringConstant.send, onTap: () {
                                Get.toNamed(
                                  AppRoutes.verificationsScreen,
                                );
                              },)
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
        ],
      )),
    );
  }
}
