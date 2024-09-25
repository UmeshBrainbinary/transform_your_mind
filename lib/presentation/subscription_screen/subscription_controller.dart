
import 'package:get/get.dart';

class SubscriptionController extends GetxController {

  RxList<Map<String, dynamic>> selectPlan = [
/*    {"plan": "Free", "des": "With selected functions",
      "free":""
    },*/

    {
      "plan": "Premium / Monthly - 7 days free",
      "des": "7 days free, then CHF 5.90 / month",
      "free":""
    },
    {"plan": "Premium Plus / Year","des":"CHF 59.90 / year",
      "free":""
    },

  ].obs;
  RxList<Map<String, dynamic>> selectPlanG = [
   /* {"plan": "Gratis", "des": "Mit ausgewählten Funktionen",
      "free":""
    },*/

    {
      "plan": "/ Monatlich – 7 Tage testen",
      "des": "7 Tage gratis, dann CHF 5.90 / Monat",
      "free":""
    },
    {"plan": "/ Jahr","des":"CHF 59.90 / Jahr",
      "free":""
    },

  ].obs;
  RxList plan = [].obs;




}