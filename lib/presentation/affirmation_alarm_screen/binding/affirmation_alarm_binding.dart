
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/affirmation_controller.dart';
import 'package:transform_your_mind/presentation/home_screen/home_controller.dart';
import 'package:transform_your_mind/presentation/journal_screen/journal_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class AffirmationAlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AffirmationController());
  }
}
