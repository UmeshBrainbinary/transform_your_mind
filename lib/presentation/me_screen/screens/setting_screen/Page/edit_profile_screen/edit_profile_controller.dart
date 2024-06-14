import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/model_class/update_user_model.dart';

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
  bool _select = false;

  bool get select => _select;

  set select(bool value) {
    _select = value;
    update();
  }

  GetUserModel getUserModel = GetUserModel();
  UpdateUserModel updateUserModel = UpdateUserModel();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }
 String imageUrl = "";
  getData() async {
    await getUser();
    // await updateUser(context);
    nameController.text = getUserModel.data!.name!;
    emailController.text = getUserModel.data!.email!;
    dobController.text = DateFormat('dd/MM/yyyy').format(getUserModel.data!.dob!);
    genderController.text = getUserModel.data!.gender==1?"Male":getUserModel.data!.gender==2?"Female":"Other";
    urlImage = getUserModel.data!.userProfile!;
    update();
    update(["edit"]);
  }

  getUser() async {
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
       await  PrefService.setValue(PrefKey.name, getUserModel.data?.name??"");
       await  PrefService.setValue(PrefKey.userImage, getUserModel.data?.userProfile??"");
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
  }

  updateUser(BuildContext context) async {
    loader.value = true;
    update();
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));
      request.fields.addAll({
        'name': nameController.text.trim(),
         'dob':dobController.text,
        "gender": genderController.text == "Male"
            ? "1"
            : genderController.text == "Female"
            ? "2"
            : genderController.text == "Other"
            ? "3"
            : "0",
      });
      request.files.add(await http.MultipartFile.fromPath('user_profile', imageFile.value!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await PrefService.setValue(PrefKey.focuses, true);

        loader.value = false;
        update();

        showSnackBarSuccess(context, updateUserModel.message ?? "");
        Get.back();
      } else {
        loader.value = false;
        update();
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;
      update();
      debugPrint(e.toString());
    }
  }

  DateTime currentDate = DateTime.now();
  RxBool isDropGender = false.obs;
  String? image = '';
  String? urlImage;
  File? selectedImage;

  RxList genderList = ["male".tr, "female".tr, "other".tr].obs;
}
