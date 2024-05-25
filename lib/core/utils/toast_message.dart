import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showToast(String msg) {
  Get.snackbar(
    'Success',
    msg,
    colorText: Colors.white,
    backgroundColor: Colors.green,
    snackPosition: SnackPosition.BOTTOM,
  );
}

void errorToast(String msg) {
  Get.snackbar(
    'Error',
    msg,
    colorText: Colors.white,
    backgroundColor: Colors.redAccent.shade200,
    snackPosition: SnackPosition.BOTTOM,
  );
}
