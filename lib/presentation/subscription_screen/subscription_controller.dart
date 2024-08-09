
import 'package:get/get.dart';

class SubscriptionController extends GetxController {

  RxList<Map<String, dynamic>> selectPlan = [
    {
      "plan": "1 Month",
      "des": "€6.99 / Per month",
      "free":"7-day free trial period"
    },
    {"plan": "1 Year", "des": "€49.99 / Per year",
      "free":""
    },
  ].obs;
  RxList plan = [].obs;




}
