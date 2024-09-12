
import 'package:get/get.dart';

class SubscriptionController extends GetxController {

  RxList<Map<String, dynamic>> selectPlan = [
    {"plan": "Free", "des": "",
      "free":""
    },

    {
      "plan": "1 Month",
      "des": "₣5.90 / Per month",
      "free":"7-day free trial period"
    },
    {"plan": "1 Year", "des": "₣59.90 / Per year",
      "free":""
    },

  ].obs;
  RxList plan = [].obs;




}