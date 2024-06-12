import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class PositiveController extends GetxController {
  RxList positiveMomentList = [
    {"title": "Meditation", "img": "assets/images/positive_moment.png"},
    {"title": "Self-esteem", "img": "assets/images/positive_moment.png"},
    {"title": "Health", "img": "assets/images/positive_moment.png"},
    {"title": "Success", "img": "assets/images/positive_moment.png"},
    {"title": "Personal Growth", "img": "assets/images/positive_moment.png"},
    {"title": "Happiness", "img": "assets/images/positive_moment.png"},
    {"title": "Personal Growth", "img": "assets/images/positive_moment.png"},
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  var isMenuVisible = false.obs;

  void showMenu() {
    isMenuVisible.value = true;
  }

  void hideMenu() {
    isMenuVisible.value = false;
  }

  var conTap = "".obs;

  void onTapCon(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon1(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon2(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon3(String value) {
    conTap.value = value;
    update();
  }

  void onTapCon4(String value) {
    conTap.value = value;
    update();
  }
}


