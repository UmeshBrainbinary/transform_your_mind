import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> rememberMe = ValueNotifier(false);

  RxBool loader = false.obs;

}