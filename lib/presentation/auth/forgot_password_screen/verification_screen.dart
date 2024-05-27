import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/string_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/toast_message.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/forgot_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_helper.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class VerificationsScreen extends StatelessWidget {
   VerificationsScreen({super.key});
  final ForgotController forgotController = Get.put(ForgotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backGround,
      appBar: CustomAppBar(
        title: StringConstant.verification,
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
                                  Dimens.d25.spaceHeight,
                                  SizedBox(
                                    width: Dimens.d296,
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        StringConstant.enterVerification,
                                        style: Style.montserratRegular(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant.color716B6B)),
                                  ),
                                  Dimens.d61.spaceHeight,
                                  Pinput(
                                    length: 6, // Set the number of fields to 6
                                    controller: forgotController.otpController,
                                    keyboardType: TextInputType.number,
                                    defaultPinTheme: PinTheme(
                                      height: 43.h,margin: const EdgeInsets.symmetric(horizontal: Dimens.d3),
                                      width: 43.h,  textStyle: Style.montserratRegular(
                                        fontSize: Dimens.d23,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.color716B6B),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    focusedPinTheme: PinTheme(
                                      height: 43.h,
                                      width: 43.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.black), // Set border color to black when focused
                                      ),
                                      textStyle:Style.montserratRegular(
                                          fontSize: Dimens.d23,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstant.color716B6B)
                                    ),
                                  ),
                                  Dimens.d23.spaceHeight,

                                  SizedBox(
                                    height: Dimens.d24,
                                    width: Dimens.d296,
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        StringConstant.notReceiveCode,
                                        style: Style.montserratRegular(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstant.color716B6B)),
                                  ),
                                  Dimens.d83.spaceHeight,
                                  CommonElevatedButton(title: StringConstant.verify, onTap: () {

                                    if(forgotController.otpController.text.isNotEmpty){
                                      Get.toNamed(AppRoutes.newPasswordScreen);
                                    } else{
                                      print("OTP empty");
                                    }

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
