import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/faq_model.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/model_class/guide_model.dart';
import 'package:transform_your_mind/model_class/privacy_model.dart';

class ProfileController extends GetxController {
  RxString? mail = "".obs;
  RxString? image = "".obs;
  RxString? name = "".obs;

  @override
  void onInit() {
    getUserDetail();
    getUser();

    super.onInit();
  }

  GetUserModel getUserModel = GetUserModel();
  FaqModel faqModel = FaqModel();
  GuideModel guideModel = GuideModel();
  PrivacyModel privacyModel = PrivacyModel();
  List<FaqData>? faqData = [];

  getUserDetail() {
    mail?.value = PrefService.getString(PrefKey.email).toString();
    image?.value = PrefService.getString(PrefKey.userImage).toString();
    name?.value = PrefService.getString(PrefKey.name).toString();
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
        await PrefService.setValue(PrefKey.name, getUserModel.data?.name ?? "");
        await PrefService.setValue(
            PrefKey.userImage, getUserModel.data?.userProfile ?? "");
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getFaq() async {
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
        final responseBody = await response.stream.bytesToString();

        faqModel = faqModelFromJson(responseBody);
        faqData = faqModel.data;
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getGuide() async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          EndPoints.getGuideApi,
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        guideModel = guideModelFromJson(responseBody);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getPrivacy() async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          EndPoints.getGuideApi,
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        privacyModel = privacyModelFromJson(responseBody);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
