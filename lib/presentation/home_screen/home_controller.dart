import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/affirmation_model.dart';
import 'package:transform_your_mind/model_class/bookmarked_model.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';

class HomeController extends GetxController {
  //_______________________________________  Variables __________________________

  RxList<AudioData> audioData = <AudioData>[].obs;
  GetPodsModel getPodsModel = GetPodsModel();
  RxBool loader = false.obs;
  List<String> bookmarkedList = [];
  List<AffirmationData>? affirmationList = [];
  DateTime todayDate = DateTime.now();
  List<bool> affirmationCheckList = [];

  //_______________________________________  Model Class __________________________
  GetUserModel getUserModel = GetUserModel();
  BookmarkedModel bookmarkedModel = BookmarkedModel();
  AffirmationModel affirmationModel = AffirmationModel();

  //_______________________________________  init Methods  __________________________

  @override
  void onInit() {
    getUsersApi();
    super.onInit();
  }

  getUsersApi() async {
    await getUSer();
    await getPodApi();
    await getBookMarkedList();
  }

  //_______________________________________  Api Call Functions  __________________________

  getPodApi() async {
    loader.value = true;
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.Request(
          'GET',
          Uri.parse(
              '${EndPoints.getPod}?isRecommended=true&created_by=6667e00b474a3621861060c0'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        loader.value = false;

        final responseBody = await response.stream.bytesToString();

        getPodsModel = getPodsModelFromJson(responseBody);
        audioData.value = getPodsModel.data ?? [];
        debugPrint("filter Data $audioData");
        update(["home"]);
      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);
        update(["home"]);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    loader.value = false;

    update();
  }

  getUSer() async {
    bookmarkedList = [];
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
        for (int i = 0; i < getUserModel.data!.bookmarkedPods!.length; i++) {
          bookmarkedList.add(getUserModel.data!.bookmarkedPods![i].toString());
        }
        update(["home"]);
        debugPrint("Bookmark List $bookmarkedList");
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    update(["home"]);
  }

  getBookMarkedList() async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.multipleBookmarksPods}$bookmarkedList",
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        bookmarkedModel = bookmarkedModelFromJson(responseBody);
        update(["home"]);

        debugPrint("Bookmark List $bookmarkedModel");
      } else {
        update(["home"]);

        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    update(["home"]);
  }

  getAffirmation() async {
    affirmationCheckList = [];
    affirmationList = [];
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.getYourAffirmation}${PrefService.getString(PrefKey.userId)}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      affirmationModel = affirmationModelFromJson(responseBody);
      if (affirmationModel.data != null) {
        for (int i = 0; i < affirmationModel.data!.length; i++) {
          if (affirmationModel.data![i].createdAt!.year == todayDate.year &&
              affirmationModel.data![i].createdAt!.month == todayDate.month &&
              affirmationModel.data![i].createdAt!.day == todayDate.day) {
            affirmationList!.add(affirmationModel.data![i]);
          }
        }
      }
      List.generate(
        affirmationList!.length,
        (index) => affirmationCheckList.add(false),
      );
      update();
      debugPrint("affirmation List (--------- )  $affirmationList");
    } else {
      affirmationModel = AffirmationModel();

      debugPrint(response.reasonPhrase);
    }
  }

  deleteAffirmation(id) async {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('DELETE',
        Uri.parse('${EndPoints.baseUrl}${EndPoints.deleteAffirmation}$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    } else {
      debugPrint(response.reasonPhrase);
    }
  }
}
