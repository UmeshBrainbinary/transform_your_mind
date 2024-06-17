
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class AudioContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AudioContentController());
  }
}
