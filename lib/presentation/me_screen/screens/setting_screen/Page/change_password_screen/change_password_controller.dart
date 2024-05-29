import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {


  TextEditingController currentPController = TextEditingController();
  TextEditingController newPController = TextEditingController();
  TextEditingController confirmPController = TextEditingController();

  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> securePass2 = ValueNotifier(true);
  ValueNotifier<bool> securePass3 = ValueNotifier(true);

}