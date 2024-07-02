import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/motivational_model.dart';

class MotivationalController extends GetxController {
  List motivationalList = [];
 RxBool loader = false.obs;
  @override
  void onInit() {

    getMotivational();
    super.onInit();
  }

  MotivationalModel motivationalModel = MotivationalModel();

  getMotivational() async {
    loader.value = true;
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request =
        http.Request('GET', Uri.parse('${EndPoints.baseUrl}get-message'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loader.value = false;

      final responseBody = await response.stream.bytesToString();
      motivationalModel = motivationalModelFromJson(responseBody);
      for (int i = 0; i < motivationalModel.data!.length; i++) {
        motivationalList.add({
          "title": motivationalModel.data![i].message,
          "img": motivationalModel.data![i].motivationalImage
        });
      }
      update(["motivational"]);
    } else {
      loader.value = false;

      debugPrint(response.reasonPhrase);
    }
    loader.value = false;

  }
}
