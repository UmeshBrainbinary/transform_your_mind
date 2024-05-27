import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController{
 //______________________________ Strings _____________________________
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPController = TextEditingController();
  TextEditingController confirmPController = TextEditingController();

  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> securePass2 = ValueNotifier(true);

}