
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_controller.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class PositiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PositiveController());
  }
}
