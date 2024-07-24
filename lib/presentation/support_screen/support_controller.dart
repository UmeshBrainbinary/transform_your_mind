import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/faq_model.dart';
class SupportController extends GetxController {
  RxList supportData = [].obs;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController comment = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode commentFocus = FocusNode();
  List<FaqData>? faqData = [];
  FaqModel faqModel = FaqModel();

  RxBool loader = false.obs;
  @override
  void onInit() {

    supportData.value = _SupportData.getSettingsData;
    super.onInit();
  }

  List<bool> faq = [];

  getFaqList() async {

    await getFaq();
    List.generate(
      faqData!.length,
      (index) => faq.add(false),
    );
    update(["update"]);
  }

  getFaq() async {
    loader.value = true;
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          EndPoints.getFaqApi,
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        loader.value = false;

        final responseBody = await response.stream.bytesToString();

        faqModel = faqModelFromJson(responseBody);
        faqData = faqModel.data;
      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  addSupport({BuildContext? context}) async {
    loader.value = true;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}add-support'));
    request.body = json.encode({
      "name": name.text.trim(),
      "email": email.text.trim(),
      "comment": comment.text.trim(),
      "created_by": PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      loader.value = false;
      showSnackBarSuccess(context!, "contactSupportMessage".tr);
      debugPrint(await response.stream.bytesToString());
    } else {
      loader.value = false;

      debugPrint(response.reasonPhrase);
    }
    loader.value = false;
    
  }
}

class _SupportData {
  final String prefixIcon;
  final String title;
  final String suffixIcon;
  final int index;

  _SupportData({
    required this.prefixIcon,
    required this.title,
    required this.suffixIcon,
    required this.index,
  });

  static get getSettingsData => [
        _SupportData(
          prefixIcon: ImageConstant.settingArrowRight,
          title: "FAQ",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 0,
        ),
        _SupportData(
          prefixIcon: ImageConstant.settingsSubscription,
          title: "contactSupport",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 1,
        ),
        _SupportData(
          prefixIcon: ImageConstant.settingsAccount,
          title: "troubleshootingGuides",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 2,
        ),
      ];
}
