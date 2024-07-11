import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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

  onTapOtpVerify(BuildContext context, token, ValueNotifier<XFile?>? imagePath) async {
    loader.value = true;
    await otpVerify(context, token, imagePath!);
    loader.value = false;
  }

  onTapOtpVerifyChangePass(BuildContext context, String email, bool? forgot) async {
    loader.value= true;
    await otpVerifyChangePass(context,email,forgot);
    loader.value=false;

  }

  forgotPasswordButton(BuildContext context, ) async {
    loader.value = true;
    await forgotPasswordApi(context);
    loader.value = false;
  }
  String? tokenVerify = "";
ResendModel resendModel = ResendModel();
  resendApi(String? token, bool? forgot, String? email, BuildContext context) async {
    loader.value = true;
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
        "isSignUp": true,
        "token":token
      });
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loader.value = false;

      final responseBody = await response.stream.bytesToString();
      resendModel = resendModelFromJson(responseBody);
      tokenVerify = resendModel.token;
      showSnackBarSuccess(context, "otpResent".tr);
    update();

    }
    else {
      loader.value = false;

      debugPrint(response.reasonPhrase);
    }
    loader.value = false;

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

       Get.to(VerificationsScreen(
         forgot: true,email:  emailController.text,
       ));

        showSnackBarSuccessForgot(context, "otpSend".tr);
      } else {
        loader.value = false;
        // print(response.reasonPhrase);
        showSnackBarError(context, "incorrectEmail".tr);
      }
    } catch (e) {
      loader.value = false;
      debugPrint(e.toString());
    }
  }
  CommonModel commonModel = CommonModel();

  otpVerify(BuildContext context, token,ValueNotifier<XFile?> imagePath) async {
    try {
     var headers = {'Content-Type': 'application/json'};
      var request = http.MultipartRequest('POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.verifyOtp}'));
      if (imagePath.value!=null) {
        request.files.add(
            await http.MultipartFile.fromPath('user_profile',imagePath.value!.path));
        request.fields.addAll({
          "otp": otpController.text,
          "isSignUp": "true",
          "token": tokenVerify!.isNotEmpty ? tokenVerify : token
        });

      } else {
        request.fields.addAll({
          "otp": otpController.text,
          "isSignUp": "true",
          "token": tokenVerify!.isNotEmpty ? tokenVerify : token
        });

      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        loader.value = false;
        final responseBody = await response.stream.bytesToString();

        // Parse the string into JSON and then into CommonModel
        verifyModel = verifyModelFromJson(responseBody);
        update();
        PrefService.setValue(PrefKey.token, verifyModel.token);
        PrefService.setValue(PrefKey.isLoginOrRegister, true);
        PrefService.setValue(PrefKey.firstTimeUserAffirmation, false);
        PrefService.setValue(PrefKey.firstTimeUserGratitude, false);
        PrefService.setValue(PrefKey.userId, verifyModel.user!.id);
        PrefService.setValue(PrefKey.name,verifyModel.user?.name??"");
        PrefService.setValue(PrefKey.userImage,verifyModel.user?.userProfile??"");
        showSnackBarSuccess(context, verifyModel.message ?? "");

        Get.offAllNamed(AppRoutes.welcomeScreen);

        debugPrint(await response.stream.bytesToString());
      } else {
        final responseBody = await response.stream.bytesToString();
        commonModel = commonModelFromJson(responseBody);
        loader.value = false;
        showSnackBarError(context,commonModel.message??"");
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
        await PrefService.setValue(PrefKey.email,email);
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
