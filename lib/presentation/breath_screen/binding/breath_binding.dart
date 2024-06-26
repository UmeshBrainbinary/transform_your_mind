
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/breath_screen/breath_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class BreathBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BreathController());
  }
}
