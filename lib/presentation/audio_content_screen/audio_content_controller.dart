import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';

class AudioContentController extends GetxController{

  RxList<AudioData> audioData = <AudioData>[].obs;


  @override
  void onInit() {
    super.onInit();


    getPodsData();
  }
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

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
        audioData.value = getPodsModel.data??[];
        debugPrint("filter Data $audioData");
        update(['update']);
      }
      else {
        debugPrint(response.reasonPhrase);
        update(['update']);
      }
    }catch(e){
      loader.value = false;
      debugPrint(e.toString());
    }
    update(['update']);
  }
}
