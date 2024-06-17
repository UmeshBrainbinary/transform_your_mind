import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/model_class/positive_model.dart';

class PositiveController extends GetxController {
  RxList positiveMomentList = [
    /*  {"title": "Meditation", "img": "assets/images/positive_moment.png"},
    {"title": "Self-esteem", "img": "assets/images/positive_moment.png"},
    {"title": "Health", "img": "assets/images/positive_moment.png"},
    {"title": "Success", "img": "assets/images/positive_moment.png"},
    {"title": "Personal Growth", "img": "assets/images/positive_moment.png"},
    {"title": "Happiness", "img": "assets/images/positive_moment.png"},
    {"title": "Personal Growth", "img": "assets/images/positive_moment.png"},*/
  ].obs;

  @override
  void onInit() {
    getPositiveMoments();
    super.onInit();
  }

  var isMenuVisible = false.obs;
  var menuPosition = const RelativeRect.fromLTRB(0, 0, 0, 0).obs;

  void showMenu(RelativeRect position) {
    menuPosition.value = position;
    isMenuVisible.value = true;
  }

  void hideMenu() {
    isMenuVisible.value = false;
  }

  var conTap = "".obs;

  void onTapCon(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon1(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon2(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon3(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon4(String value) {
    conTap.value = value;
    update();
  }

  Rx<bool> loader = false.obs;
  PositiveModel positiveModel = PositiveModel();

  getPositiveMoments() async {
    loader.value = true;

    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          EndPoints.getMoment,
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        loader.value = false;

        positiveModel = positiveModelFromJson(responseBody);
        if (positiveModel.data != null) {
          for (int i = 0; i < positiveModel.data!.length; i++) {
            positiveMomentList.add({
              "title": positiveModel.data?[i].title ?? '',
              "img": positiveModel.data?[i].image ?? ''
            });
          }
        }

        update();
      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
  }
}
