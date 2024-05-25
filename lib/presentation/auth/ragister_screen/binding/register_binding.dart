
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}
