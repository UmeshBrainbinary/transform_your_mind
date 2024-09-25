import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';

class DashBoardController extends GetxController{
  @override
  onInit() {
    Get.put(AudioContentController());
    super.onInit();
  }

  int selectedIndex = 0;

  void onItemTapped(int index) {
    if (index != 2) {
      selectedIndex = index;
    }
    update();
  }
}
