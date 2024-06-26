import 'package:get/get.dart';

class BreathController extends GetxController{
  final RxList<String> feel = ["veryRelaxed".tr, "relaxed".tr, "tense".tr, "veryTense".tr].obs;
  var selectedIndices = <int>{}.obs;

  void toggleSelection(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
    } else {
      selectedIndices.add(index);
    }
    update(["update"]);
  }
}