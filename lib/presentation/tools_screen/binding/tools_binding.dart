
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/tools_screen/tools_controller.dart';


/// A binding class for the SplashScreen.
///
/// This class ensures that the SplashController is created when the
/// SplashScreen is first loaded.
class ToolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ToolsController());
  }
}
