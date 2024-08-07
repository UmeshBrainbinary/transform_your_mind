import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/model_class/login_model.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_affirmation_focus_page.dart';
import 'package:transform_your_mind/presentation/welcome_screen/welcome_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> rememberMe = ValueNotifier(false);

  RxBool loader = false.obs;

  @override
  void onInit() {
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

  onTapLogin(BuildContext context, greeting) async {
    if (await isConnected()) {
      loader.value = true;
      await loginApi(context, greeting);
    } else {
      showSnackBarError(context, "noInternet".tr);
    }
  }

  LoginModel loginModel = LoginModel();
  CommonModel commonModel = CommonModel();

  loginApi(BuildContext context, greeting) async {
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
        showSnackBarSuccess(context, "Login successfully");
        await PrefService.setValue(PrefKey.isLoginOrRegister, true);
        await PrefService.setValue(PrefKey.isRemember, rememberMe.value);
        await PrefService.setValue(PrefKey.email, emailController.text);
        await PrefService.setValue(PrefKey.password, passwordController.text);
        loader.value = false;

        final responseBody = await response.stream.bytesToString();

        loginModel = loginModelFromJson(responseBody);

        debugPrint("loginModel $loginModel");
        debugPrint("token ${loginModel.meta!.token}");
        debugPrint("userId ${loginModel.data!.id}");

        PrefService.setValue(PrefKey.token, loginModel.meta!.token);
        PrefService.setValue(PrefKey.userId, loginModel.data!.id);
        PrefService.setValue(PrefKey.name,loginModel.data?.name??"");
        PrefService.setValue(PrefKey.userImage,loginModel.data?.userProfile??"");
        await updateUser(context);
        await getUSer(context, greeting);
      } else if (response.statusCode == 400) {
        loader.value = false;
        final responseBody = await response.stream.bytesToString();
        commonModel = commonModelFromJson(responseBody);

        showSnackBarError(context, "Invalid credential");
      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
  }

  GetUserModel getUserModel = GetUserModel();

  getUSer(BuildContext context, greeting) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getUser}${PrefService.getString(PrefKey.userId)}",
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getUserModel = getUserModelFromJson(responseBody);
        if ((getUserModel.data?.focuses ?? []).isEmpty) {
          Get.offAllNamed(AppRoutes.selectYourFocusPage);
        } else if ((getUserModel.data?.affirmations ?? []).isEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return  SelectYourAffirmationFocusPage(isFromMe: false,setting: false,);
        },));
        } else {
          getUserModel.data?.welcomeScreen  == false
              ? Get.offAll(const WelcomeHomeScreen())
              : Get.offAllNamed(AppRoutes.dashBoardScreen);
        }
        await PrefService.setValue(PrefKey.language,
            getUserModel.data!.language == "english" ? "en-US" : "de-DE");

        update();
        await PrefService.setValue(
            PrefKey.userImage, getUserModel.data?.userProfile ?? "");
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    update(["home"]);
  }

  updateUser(
    BuildContext context,
  ) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));
      request.fields.addAll({
        'language': PrefService.getString(PrefKey.language).isEmpty
            ? "english"
            : PrefService.getString(PrefKey.language) != "en-US"
                ? "german"
                : "english"
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        update();
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    update(["home"]);
  }
}
