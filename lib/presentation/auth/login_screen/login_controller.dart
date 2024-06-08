import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';

class LoginController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> rememberMe = ValueNotifier(false);

  RxBool loader = false.obs;

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    if(PrefService.getBool(PrefKey.isRemember) == true){
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



}