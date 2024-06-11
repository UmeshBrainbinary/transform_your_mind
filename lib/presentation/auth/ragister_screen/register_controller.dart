import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/register_model.dart';
import 'package:transform_your_mind/routes/app_routes.dart';

import '../../../core/utils/end_points.dart';

class RegisterController extends GetxController{

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

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

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.onInit();
  }

  RegisterModel registerModel = RegisterModel();

  onTapRegister(BuildContext context) async {
    loader.value = true;

    debugPrint("loader ${loader.value}");
    await registerApi(context);
 /*   registerModel = await registerApi(context);
    loader.value = false;
    
    debugPrint("Register Model $registerModel");*/

   //Get.toNamed(AppRoutes.selectYourFocusPage);
    update();
  }

  registerApi(BuildContext context) async {

    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${EndPoints.baseUrl}signup'));
    request.body = json.encode({
      "name":nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "profile": "d",
      "dob": "09/06/2015",
      "gender": 1
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      loader.value = false;
      PrefService.setValue(PrefKey.email, emailController.text);
      showSnackBarSuccess(context,"User registered successfully!");
      Get.toNamed(AppRoutes.verificationsScreen);
      debugPrint(await response.stream.bytesToString());
    }
    else {
      showSnackBarSuccess(context,"User with this email already exists.");
      loader.value = false;
      debugPrint(response.reasonPhrase);
    }

  }
}