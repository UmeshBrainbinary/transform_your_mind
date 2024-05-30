
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/notification_setting_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.

class NotificationSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationSettingController());
  }
}
