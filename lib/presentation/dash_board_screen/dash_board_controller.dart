import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController{

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // set the desired status bar color
      statusBarIconBrightness: Brightness.dark, // set the status bar icon color to light or dark
    ));
    super.onInit();
  }

}
