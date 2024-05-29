
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/edit_profile_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
  }
}
