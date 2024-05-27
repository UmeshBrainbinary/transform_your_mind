import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController{

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> rememberMe = ValueNotifier(false);
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);

  DateTime? selectedDob;

  RxBool loader = false.obs;
  RxBool isDropGender = false.obs;
  String? image = '';
  String? urlImage;
  File? selectedImage;

}