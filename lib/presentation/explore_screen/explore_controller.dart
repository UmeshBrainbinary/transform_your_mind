import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';

class ExploreController extends GetxController{
  final RxList exploreList = [
    {
      "image": ImageConstant.static1,
      "title": "Your Way Out Of Addiction - Ep 4 H..."
    },
    {
      "image": ImageConstant.static2,
      "title": "EARTH ep 1 -Meditations for He..."
    },
    {
      "image": ImageConstant.static3,
      "title": "On The Move Meditation."
    },
    {
      "image": ImageConstant.static4,
      "title": "Sitting By The Fire"
    },
    {
      "image": ImageConstant.static5,
      "title": "Your Way Out Of Addiction - Ep 4 H..."
    },
    {
      "image": ImageConstant.static1,
      "title": "EARTH ep 1 -Meditations for He..."
    },
  ].obs;
  List? filteredList = [].obs;

  @override
  void onInit() {
    filteredList = exploreList;
    super.onInit();
    getPodsData();
  }

  filterList(String query, List dataList) {
    return dataList
        .where((dataList) =>
            dataList['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  getPodsData() async {
    loader.value = true;
    await getPodApi();
    loader.value = false;
    update(['update']);
  }
  RxBool loader = false.obs;
  GetPodsModel getPodsModel = GetPodsModel();

  getPodApi() async {
    try{
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request('GET', Uri.parse(EndPoints.getPod));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getPodsModel = getPodsModelFromJson(responseBody);
        update(['update']);
      }
      else {
        print(response.reasonPhrase);
        update(['update']);
      }
    }catch(e){
      loader.value = false;
      debugPrint(e.toString());
    }
    update(['update']);
  }
}