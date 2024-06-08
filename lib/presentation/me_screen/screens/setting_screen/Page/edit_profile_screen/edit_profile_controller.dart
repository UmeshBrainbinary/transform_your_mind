import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {





  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  FocusNode name = FocusNode();
  FocusNode email = FocusNode();
  FocusNode dob = FocusNode();
  FocusNode gender = FocusNode();
  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);

  DateTime? selectedDob;

  RxBool loader = false.obs;
  RxBool isDropGender = false.obs;
  String? image = '';
  String? urlImage;
  File? selectedImage;


  RxList genderList = [
    "male".tr,
    "female".tr,
    "other".tr
  ].obs;

}