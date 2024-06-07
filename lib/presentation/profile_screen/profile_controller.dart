import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';

class ProfileController extends GetxController {
  RxString? mail = "".obs;

  @override
  void onInit() {
    getUserDetail();
    super.onInit();
  }

  getUserDetail() {
    mail?.value = PrefService.getString(PrefKey.email).toString();
  }
}
