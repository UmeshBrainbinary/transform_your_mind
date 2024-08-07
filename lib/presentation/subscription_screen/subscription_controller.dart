
import 'package:get/get.dart';

class SubscriptionController extends GetxController {

  RxList<Map<String, dynamic>> selectPlan = [
    {"plan": "Free", "des": "",
      "free":""
    },
    {
      "plan": "Premium",
      "des": "₹9.99 / Per month ₹99.90 / Per year",
      "free":"7-day free trial period"
    },
    {"plan": "Pro", "des": "₹14.99 / Per month ₹149.90 / Per year",
      "free":""
    },
  ].obs;
  RxList plan = [].obs;

  @override
  void onInit() {

    List.generate(
      3,
      (index) => plan.add(false),
    );
    super.onInit();
  }



}
