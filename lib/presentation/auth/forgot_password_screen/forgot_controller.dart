import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/forgot_password_model.dart';
import 'package:transform_your_mind/model_class/resend_model.dart';
import 'package:transform_your_mind/model_class/verify_model.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/verification_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';

class ForgotController extends GetxController {
  //______________________________ Strings _____________________________
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPController = TextEditingController();
  TextEditingController confirmPController = TextEditingController();
  RxBool loader = false.obs;

  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> securePass2 = ValueNotifier(true);
  VerifyModel verifyModel = VerifyModel();
  ForgotPassword forgotPassword = ForgotPassword();

  onTapOtpVerify(BuildContext context,token) async {
    loader.value = true;
    await otpVerify(context,token);
    loader.value = false;
  }

  onTapOtpVerifyChangePass(BuildContext context, String email, bool? forgot) async {
    await otpVerifyChangePass(context,email,forgot);
  }

  forgotPasswordButton(BuildContext context, ) async {
    loader.value = true;
    await forgotPasswordApi(context);
    loader.value = false;
  }
  String? tokenVerify = "";
ResendModel resendModel = ResendModel();
  resendApi(String? token, bool? forgot, String? email, BuildContext context) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('${EndPoints.baseUrl}resend-otp'));
    if(forgot==true){
      request.body = json.encode({
          "email": email,
      });
    }else{
      request.body = json.encode({
        //  "email": PrefService.getString(PrefKey.email),
        "isSignUp": true,
        "token":token
      });
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      resendModel = resendModelFromJson(responseBody);
      tokenVerify = resendModel.token;
      showSnackBarSuccess(context, "otpResent".tr);
    update();

    }
    else {
      debugPrint(response.reasonPhrase);
    }

  }

  forgotPasswordApi(BuildContext context) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.forgotPassword}'));
      request.body = json.encode({"email": emailController.text.trim() });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        loader.value = false;
        final responseBody = await response.stream.bytesToString();
        forgotPassword = forgotPasswordFromJson(responseBody);
        update();
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return VerificationsScreen(
              forgot: true,email:  emailController.text,
            );
          },
        ));
        showSnackBarSuccess(context, forgotPassword.message ?? "");
      } else {
        loader.value = false;
        // print(response.reasonPhrase);
        showSnackBarError(context, "Incorrect Email");
      }
    } catch (e) {
      loader.value = false;
      debugPrint(e.toString());
    }
  }

  otpVerify(BuildContext context, token) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.verifyOtp}'));
      request.body = json.encode({
       // "email": PrefService.getString(PrefKey.email),
        "otp": otpController.text,
        "isSignUp": true,
        "token":tokenVerify!.isNotEmpty?tokenVerify:token
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        loader.value = false;
        final responseBody = await response.stream.bytesToString();

        // Parse the string into JSON and then into CommonModel
        verifyModel = verifyModelFromJson(responseBody);
        update();
        PrefService.setValue(PrefKey.token, verifyModel.token);
        PrefService.setValue(PrefKey.userId, verifyModel.user!.id);
        PrefService.setValue(PrefKey.name,verifyModel.user?.name??"");
        PrefService.setValue(PrefKey.userImage,verifyModel.user?.userProfile??"");
        showSnackBarSuccess(context, verifyModel.message ?? "");

        Get.offAllNamed(AppRoutes.selectYourFocusPage);

        debugPrint(await response.stream.bytesToString());
      } else {
        loader.value = false;
        showSnackBarError(context, "Incorrect OTP");
      }
    } catch (e) {
      loader.value = false;

      debugPrint("All offer Api error : $e");
    }
  }


  otpVerifyChangePass(BuildContext context, String email, bool? forgot) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.verifyOtp}'));
      request.body = json.encode({
        "email": email,
        "otp": otpController.text,

      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        loader.value = false;
        final responseBody = await response.stream.bytesToString();

        // Parse the string into JSON and then into CommonModel
        verifyModel = verifyModelFromJson(responseBody);
        update();
        // PrefService.setValue(PrefKey.token, verifyModel.token);
        // PrefService.setValue(PrefKey.userId, verifyModel.user!.id);
        // showSnackBarSuccess(context, verifyModel.message ?? "");
        await PrefService.setValue(PrefKey.email, emailController.text);
        Get.toNamed(AppRoutes.changePassword);

        debugPrint(await response.stream.bytesToString());
      } else {
        loader.value = false;
        showSnackBarError(context, "Incorrect OTP");
      }
    } catch (e) {
      loader.value = false;

      debugPrint("All offer Api error : $e");
    }
  }
}
