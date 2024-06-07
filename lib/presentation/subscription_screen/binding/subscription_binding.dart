
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/splash_screen/splash_controller.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_controller.dart';

/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionController());
  }
}
