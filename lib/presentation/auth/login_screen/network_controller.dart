import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';
import 'package:transform_your_mind/presentation/auth/no_internet_screen.dart';


class NetworkController extends GetxController {

  final RxBool _isConnected = false.obs;

  bool get isConnected => _isConnected.value;

  set isConnected(bool val) => _isConnected.value = val;

  @override
  void onInit() {
    super.onInit();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isConnected = false;
        Get.to(() => NoInternet(onTap: (){
          checkConnection();
        }));
      } else {
        isConnected = true;
        if (Get.isDialogOpen == true) {
          Get.back();
        }
      }
    });
  }

  void checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      isConnected = false;
      Get.to(() => NoInternet(onTap: (){
        checkConnection();
      }));
    } else {
      isConnected = true;
      Get.back();
      AudioContentController audioContentController = Get.find<AudioContentController>();
      audioContentController.onInit();
    }
  }
}




class ConnectivityService {
  // Singleton pattern
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _connectivityController = StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get connectivityStream => _connectivityController.stream;

  void initialize() {
    // Initial check
    _checkConnectivity();

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityController.sink.add(result);
    });
  }

  void _checkConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _connectivityController.sink.add(result);
  }

  void dispose() {
    _connectivityController.close();
  }
}
