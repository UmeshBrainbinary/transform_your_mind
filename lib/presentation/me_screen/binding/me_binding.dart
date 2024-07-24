
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/me_screen/me_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class MeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MeController());
  }
}
