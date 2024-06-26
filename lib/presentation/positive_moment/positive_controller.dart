import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/positive_model.dart';

class PositiveController extends GetxController {
  RxList positiveMomentList = [].obs;
  List? filteredBookmarks;

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

  deletePositiveMoment(id, BuildContext context) async {
    loader.value = true;

    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
          'DELETE', Uri.parse('${EndPoints.deletePositiveMoment}$id'));
      debugPrint('id ============= $id');
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        loader.value = false;
       showSnackBarSuccess(context, "positiveDeleted".tr);
        update(['moment']);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    update(['moment']);
  }

  filterMoment(weeks) async {
    positiveMomentList = [].obs;
    positiveModel = PositiveModel();
    loader.value = true;

    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getMoment}created_by=${PrefService.getString(PrefKey.userId)}?$weeks=true",
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
              "img": positiveModel.data?[i].image ?? '',
              "des": positiveModel.data?[i].description ?? '',
              'id': positiveModel.data?[i].id ?? "",
            });
          }
          filteredBookmarks = positiveMomentList;
        }
         update(["update"]);
      } else {
        loader.value = false;
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    loader.value = false;
    update(["update"]);

  }

  getPositiveMoments() async {
    positiveMomentList = [].obs;
    positiveModel = PositiveModel();
    loader.value = true;

    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getMoment}?created_by=${PrefService.getString(PrefKey.userId)}",
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
              "img": positiveModel.data?[i].image ?? '',
              "des": positiveModel.data?[i].description ?? '',
              'id': positiveModel.data?[i].id ?? "",
            });
          }
          filteredBookmarks = positiveMomentList;
        }

        update(['moment']);
        update(["update"]);

      } else {
        loader.value = false;

        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    update(['moment']);
    update(["update"]);

  }
}
