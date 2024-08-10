
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/me_screen/me_controller.dart';
import 'package:transform_your_mind/presentation/self_hypnotic/self_hypnotic_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class SelfHypnoticBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelfHypnoticController());
  }
}
