import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/login_model.dart';
import 'package:transform_your_mind/routes/app_routes.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> rememberMe = ValueNotifier(false);

  RxBool loader = false.obs;

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    if (PrefService.getBool(PrefKey.isRemember) == true) {
      emailController.text = PrefService.getString(PrefKey.email);
      passwordController.text = PrefService.getString(PrefKey.password);
      rememberMe.value = true;
    }

    super.onInit();
  }

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    rememberMe.value = false;
    super.dispose();
  }

  onTapLogin(BuildContext context) async {
    loader.value = true;
    await loginApi(context);
  }

  LoginModel loginModel = LoginModel();
  CommonModel commonModel = CommonModel();

  loginApi(BuildContext context) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.login}'));
      request.body = json.encode({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim()
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await PrefService.setValue(PrefKey.isLoginOrRegister, true);
        await PrefService.setValue(PrefKey.isRemember, rememberMe.value);
        await PrefService.setValue(PrefKey.email, emailController.text);
        await PrefService.setValue(PrefKey.password, passwordController.text);
        loader.value = false;

        Get.toNamed(AppRoutes.dashBoardScreen);
        final responseBody = await response.stream.bytesToString();

        loginModel = loginModelFromJson(responseBody);
        update();
        debugPrint("loginModel $loginModel");
        PrefService.setValue(PrefKey.token, loginModel.meta!.token);
        PrefService.setValue(PrefKey.userId, loginModel.data!.id);
        showSnackBarSuccess(context, "login Successfully");
      } else if (response.statusCode == 400) {
        loader.value = false;
        final responseBody = await response.stream.bytesToString();
        commonModel = commonModelFromJson(responseBody);

        showSnackBarSuccess(context, commonModel.message ?? "Invalid Email");
      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
  }
}
