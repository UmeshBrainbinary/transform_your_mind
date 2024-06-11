import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:http/http.dart'as http;
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/reset_password_model.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';

class ChangePasswordController extends GetxController {


  TextEditingController currentPController = TextEditingController();
  TextEditingController newPController = TextEditingController();
  TextEditingController confirmPController = TextEditingController();

  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> securePass2 = ValueNotifier(true);
  ValueNotifier<bool> securePass3 = ValueNotifier(true);

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.onInit();
  }
  RxBool loader = false.obs;
  ResetPassword resetPassword =ResetPassword();


  resetPasswordApi(BuildContext context) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.resetPassword}'));
      request.body = json.encode({
        "email": PrefService.getString(PrefKey.email).toString(),
        "newPassword": newPController.text.trim(),
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        loader.value = false;
        final responseBody = await response.stream.bytesToString();
        resetPassword = resetPasswordFromJson(responseBody);
        update();
        Get.offAll(LoginScreen());
        showSnackBarSuccess(context, resetPassword.message ?? "");
      } else {
        loader.value = false;
        // print(response.reasonPhrase);
        showSnackBarError(context, "Incorrect password");
      }
    } catch (e) {
      loader.value = false;
      debugPrint(e.toString());
    }
  }

}