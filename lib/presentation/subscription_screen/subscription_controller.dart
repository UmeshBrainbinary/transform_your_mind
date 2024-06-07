import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  RxList<Map<String, dynamic>> selectPlan = [
    {"plan": "₹9990.0 / Month", "des": "₹990.0 billed every month"},
    {
      "plan": "₹6500.0 / 6 Month’s",
      "des": "6 month’s at ₹783.33/month.Save 20%"
    },
    {"plan": "₹7500.0 / Year", "des": "12 month’s at ₹541.67/month.Save 45%"},
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

  void selectPlanAtIndex(int index) {

    update();
  }
}
