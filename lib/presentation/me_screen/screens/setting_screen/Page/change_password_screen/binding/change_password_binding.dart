
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/change_password_screen/change_password_controller.dart';



/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePasswordController());
  }
}
