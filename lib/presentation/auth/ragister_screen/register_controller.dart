import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/register_model.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/verification_screen.dart';

class RegisterController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode dobFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);

  DateTime? selectedDob;
  bool _select = false;

  bool get select => _select;

  set select(bool value) {
    _select = value;
    update();
  }

  DateTime currentDate = DateTime.now();

  RxBool loader = false.obs;
  RxBool isDropGender = false.obs;
  String? image = '';
  String? urlImage;
  File? selectedImage;

  RxList genderList = ["male".tr, "female".tr, "other".tr].obs;

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.onInit();
  }


  onTapRegister(BuildContext context, ValueNotifier<XFile?> imageFile, ) async {
    loader.value = true;

    debugPrint("loader ${loader.value}");
    await registerApi(context, imageFile);

    update();
  }
  CommonModel commonModel = CommonModel();
  RegisterModel registerModel = RegisterModel();
  registerApi(BuildContext context, ValueNotifier<XFile?> path) async {
    var headers = {
      'Content-Type': 'application/json',

    };

    var request = http.Request('POST', Uri.parse("${EndPoints.baseUrl}${EndPoints.registerApi}"));
    request.body = json.encode({
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "dob": dobController.text,
      "gender": genderController.text == "Male"
          ? "1"
          : genderController.text == "Female"
          ? "2"
          : genderController.text == "Other"
          ? "3"
          : "0",
      "user_type": "2",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      loader.value = false;
      PrefService.setValue(PrefKey.email, emailController.text);
      showSnackBarSuccessForgot(context, "otpSend".tr);

      //showSnackBarSuccess(context, "otpSendEmail".tr);
      final responseBody = await response.stream.bytesToString();

      // Parse the string into JSON and then into CommonModel
      registerModel = registerModelFromJson(responseBody);
     Get.to(VerificationsScreen(
       forgot: false,imagePath: path,
       token: registerModel.token,
     ));

    } else {
      loader.value = false;

      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message.toString());

      debugPrint("message For CommonModel $commonModel");
      debugPrint(response.reasonPhrase);
    }
    loader.value = false;
  }
}
