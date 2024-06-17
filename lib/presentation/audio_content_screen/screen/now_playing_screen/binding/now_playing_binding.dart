
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';



/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class NowPlayingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NowPlayingController());
  }
}
