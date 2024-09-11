import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
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

class VerificationsScreen extends StatefulWidget {
  final bool? forgot;
  final String? token;
  final String? email;
  final ValueNotifier<XFile?>? imagePath;

  const VerificationsScreen(
      {super.key, this.forgot, this.token, this.email, this.imagePath});

  @override
  State<VerificationsScreen> createState() => _VerificationsScreenState();
}

class _VerificationsScreenState extends State<VerificationsScreen> {
  final ForgotController forgotController = Get.put(ForgotController());

  ThemeController themeController = Get.find<ThemeController>();

  int _start = 60;
  Timer? _timer;

  @override
  void initState() {
    forgotController.otpController.clear();
    startTimer();
    super.initState();
  }

  Future<void> resendOtp(BuildContext context) async {
    setState(() {
      _start = 60;
    });
    startTimer();
    if (await isConnected()) {
      forgotController.resendApi(
          widget.token, widget.forgot, widget.email, context);
    } else {
      showSnackBarError(context, "noInternet".tr);
    }

    // Add your OTP resend logic here

  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (timer) {
        if (_start == 0) {
          timer.cancel();
          // Handle timeout here
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  String formatTime(int seconds) {
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '00:$secs';
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   //statusBarSet(themeController);
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "verification".tr,
      ),
      body: Stack(
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
                                    style: Style.nunLight(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:ColorConstant.color716B6B)),
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
                                  textStyle: Style.nunRegular(
                                      fontSize: Dimens.d23,
                                      fontWeight: FontWeight.w400,
                                      color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:ColorConstant.color716B6B),
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
                                        color: ColorConstant
                                            .themeColor), // Set border color to black when focused
                                  ),
                                  textStyle: Style.nunRegular(
                                      fontSize: Dimens.d23,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstant.color716B6B),
                                ),
                              ),
                              Dimens.d23.spaceHeight,
                              SizedBox(
                                width: Dimens.d296,
                                child: RichText(
                textAlign:TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text:  "notReceiveCode".tr,
                                          style: Style.nunRegular(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                              themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:ColorConstant.color716B6B)),
                                      const TextSpan(text: " "),
                                      TextSpan(text:  "resend".tr,
                                          style: Style.nunRegular(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: _start != 0
                                                  ? themeController
                                                  .isDarkMode.isTrue
                                                  ? Colors.grey
                                                  : Colors.black
                                                  .withOpacity(0.2)
                                                  : ColorConstant
                                                  .themeColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            if (_start == 0) {
                                              resendOtp(context);
                                            }
                                          },

                                      ),

                                    ]
                                  ),
                                ),
                              ),
                              Dimens.d30.spaceHeight,
                              _start == 0?const SizedBox(): Text('${"timeLeft".tr}: ${formatTime(_start)}',
                                  textAlign: TextAlign.center,
                                  style: Style.nunRegular(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstant.themeColor)),
                              Dimens.d30.spaceHeight,
                              CommonElevatedButton(
                                title: "verify".tr,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (forgotController
                                      .otpController.text.isNotEmpty) {
                                    if (widget.forgot == true) {
                                      forgotController
                                          .onTapOtpVerifyChangePass(context,
                                              widget.email!, widget.forgot);
                                    } else {
                                      forgotController.onTapOtpVerify(context,
                                          widget.token!, widget.imagePath);
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
      ),
    );
  }
}
