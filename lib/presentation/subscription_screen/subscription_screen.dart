import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_controller.dart';
import 'package:transform_your_mind/presentation/welcome_screen/welcome_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class SubscriptionScreen extends StatefulWidget {
  bool? skip;

  SubscriptionScreen({super.key, this.skip});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionController subscriptionController = Get.put(SubscriptionController());
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final List<String> _productIds = ['1 Month', '1 Yearly'];
  ThemeController themeController = Get.find<ThemeController>();
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    _initializeInAppPurchase();
    _subscription = _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }


  Future<void> _initializeInAppPurchase() async {
    final bool available = await _inAppPurchase.isAvailable();
    ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productIds.toSet());
    if (response.notFoundIDs.isNotEmpty) {
      setState(() {

      });
    } else {
      setState(() {
        _products = response.productDetails;
      });
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
      } else if (purchaseDetails.status == PurchaseStatus.error) {
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset(
              ImageConstant.close,
              color: themeController.isDarkMode.isTrue ? ColorConstant.colorA49F9F : ColorConstant.hintText,
            ),
          ),
        ),
        title: "subscriptions".tr,
        showBack: false,
        action: widget.skip!
            ? Row(
          children: [
            GestureDetector(
              onTap: () async {
                await PrefService.setValue(PrefKey.subscription, true);
                await PrefService.setValue(PrefKey.firstTimeRegister, true);
                await PrefService.setValue(PrefKey.addGratitude, true);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const WelcomeHomeScreen();
                  },
                ));
              },
              child: Text(
                "skip".tr,
                style: Style.nunRegular(
                  color: themeController.isDarkMode.value ? ColorConstant.white : ColorConstant.black,
                ),
              ),
            ),
            Dimens.d20.spaceWidth,
          ],
        )
            : const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Dimens.d22.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d50),
              child: Text(
                "chooseSub".tr,
                textAlign: TextAlign.center,
                style: Style.nunRegular(
                  fontSize: Dimens.d14,
                ),
              ),
            ),
            Dimens.d20.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d45),
              child: Text(
                "subscribeNow".tr,
                textAlign: TextAlign.center,
                style: Style.nunMedium(
                  color: themeController.isDarkMode.isTrue ? ColorConstant.color73969FF : ColorConstant.themeColor,
                  fontSize: Dimens.d13,
                ),
              ),
            ),
            Dimens.d20.spaceHeight,
            selectPlan()
          ],
        ),
      ),
    );
  }

  Widget selectPlan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "selectPlan".tr,
            textAlign: TextAlign.center,
            style: Style.nunitoBold(
              fontSize: Dimens.d16,
            ),
          ),
          Dimens.d20.spaceHeight,
          Obx(
                () => ListView.builder(
              itemCount: subscriptionController.selectPlan.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var data = subscriptionController.selectPlan[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < subscriptionController.plan.length; i++) {
                        subscriptionController.plan[i] = i == index;
                      }
                    });
                    _initiatePurchase(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: subscriptionController.plan[index] == true
                          ? ColorConstant.color7C9EA7.withOpacity(0.20)
                          : themeController.isDarkMode.isTrue
                          ? ColorConstant.textfieldFillColor
                          : ColorConstant.white.withOpacity(0.9),
                      border: Border.all(
                        color: subscriptionController.plan[index] == true
                            ? themeController.isDarkMode.isTrue
                            ? ColorConstant.themeColor
                            : ColorConstant.themeColor
                            : themeController.isDarkMode.isTrue
                            ? ColorConstant.colorE3E1E1.withOpacity(0.2)
                            : ColorConstant.colorE3E1E1,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            subscriptionController.plan[index] == true
                                ? SvgPicture.asset(
                              ImageConstant.subscriptionCheck,
                              height: Dimens.d24,
                              width: Dimens.d24,
                            )
                                : Container(
                              height: Dimens.d24,
                              width: Dimens.d24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: themeController.isDarkMode.isTrue
                                      ? ColorConstant.white
                                      : ColorConstant.colorE3E1E1,
                                ),
                              ),
                            ),
                            Dimens.d10.spaceWidth,
                            Text(
                              data["plan"],
                              style: Style.montserratBold(fontSize: 14),
                            ),
                          ],
                        ),
                        Dimens.d5.spaceHeight,
                        data["plan"] == "Free"
                            ? const SizedBox()
                            : Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["des"],
                                style: Style.nunRegular(
                                  fontSize: 13,
                                  color: ColorConstant.color797777,
                                ),
                              ),
                              index == 1
                                  ? Text(
                                data["free"],
                                style: Style.nunRegular(
                                  fontSize: 13,
                                  color: ColorConstant.themeColor,
                                ),
                              )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Dimens.d40.spaceHeight,
          Text(
            "additionalInformation".tr,
            style: Style.nunitoBold(fontSize: 18),
          ),
          Dimens.d20.spaceHeight,
          information("7dayFreeTrial".tr, "forNew".tr),
          Dimens.d10.spaceHeight,
          information("FamilyPlan".tr, "allowsUp".tr),
          Dimens.d10.spaceHeight,
          information("studentDiscount".tr, "20Pre".tr),
          Dimens.d30.spaceHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: CommonElevatedButton(
              title: "purchase".tr,
              onTap: () async {
                _initiatePurchase(0);

              },
            ),
          ),
          Dimens.d30.spaceHeight,
        ],
      ),
    );
  }

  void _initiatePurchase(int index) {
    final productId = _productIds[index]; // Use the correct index or product ID mapping
    final productDetails = _products.firstWhere((product) => product.id == productId, orElse: () => null as ProductDetails);

    if (productDetails != null) {
      final purchaseParam = PurchaseParam(productDetails: productDetails);
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      // Handle the case where the productDetails is null
      print("Product not found");
    }
  }

  Widget information(title, des) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title: ",
            style: Style.nunitoBold(
              fontSize: 11,
              color: themeController.isDarkMode.isTrue ? ColorConstant.white : ColorConstant.black,
            ),
          ),
          TextSpan(
            text: des,
            style: Style.nunMedium(
              fontSize: 11,
              color: themeController.isDarkMode.isTrue ? ColorConstant.white : ColorConstant.black,
            ),
          ),
        ],
      ),
    );
  }
}
