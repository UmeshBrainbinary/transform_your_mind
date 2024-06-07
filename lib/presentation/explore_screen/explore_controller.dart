import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';

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
  }

  filterList(String query, List dataList) {
    return dataList
        .where((dataList) =>
            dataList['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}