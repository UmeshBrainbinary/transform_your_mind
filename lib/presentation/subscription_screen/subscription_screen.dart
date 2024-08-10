import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
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

final bool _kAutoConsume = Platform.isIOS || true;

const String _kConsumableId = 'consumable';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = 'transform_monthly';
const String _kGoldSubscriptionId = 'transform_yearly';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

class SubscriptionScreen extends StatefulWidget {
  bool? skip;

  SubscriptionScreen({super.key, this.skip});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionController subscriptionController = Get.put(SubscriptionController());
  ThemeController themeController = Get.find<ThemeController>();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  @override
  void initState() {
    super.initState();
    List.generate(2, (index) {
      subscriptionController.plan.add(false);
    },);
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        },
        onDone: () {},
        onError: (Object error) {
          // handle error here.
        });
    initStoreInfo();
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          debugPrint("purchase details =========+++++$purchaseDetails");
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    print("when user get purchase status ${purchaseDetails.status}");
    print("when user get purchase error ${purchaseDetails.error}");
    print(
        "when user get purchase pendingCompletePurchase ${purchaseDetails.pendingCompletePurchase}");
    print("when user get purchase productID ${purchaseDetails.productID}");
    print("when user get purchase purchaseID ${purchaseDetails.purchaseID}");
    print(
        "when user get purchase transactionDate ${purchaseDetails.transactionDate}");
    print(
        "when user get purchase verificationData ${purchaseDetails.verificationData}");
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    debugPrint("deliverProduct =========+++++   $purchaseDetails");

    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    print("after verify purchase details ======++++ $purchaseDetails");
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    print("$isAvailable");

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }else{
      final InAppPurchaseAndroidPlatformAddition androidAddition =
      _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      print(androidAddition);
      // Configure Android-specific settings if needed

    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());


    print("plans checking ${ subscriptionController.plan}");
    setState(() {
      _queryProductError = productDetailResponse.error?.message;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
    });


    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
    print("consumable list $consumables");
    if (productDetailResponse.productDetails[0].id == "transform_yearly") {
      setState(() {
        subscriptionController.plan[1] = true.obs;
      });
    } else if (productDetailResponse.productDetails[0].id ==
        "transform_monthly") {
      setState(() {
        subscriptionController.plan[0] = true.obs;
      });
    }
  }
  Future<void> checkData() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    print("$isAvailable");

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());


    print("plans checking ${ subscriptionController.plan}");
    setState(() {
      _queryProductError = productDetailResponse.error?.message;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
    });


    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
    print("consumable list $consumables");
    print("productDetailResponse details To save in api $productDetailResponse");
    if (productDetailResponse.productDetails[0].id == "transform_yearly") {
      setState(() {
        subscriptionController.plan[1] = true.obs;
      });
    } else if (productDetailResponse.productDetails[0].id ==
        "transform_monthly") {
      setState(() {
        subscriptionController.plan[0] = true.obs;
      });
    }
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
              child: GestureDetector(onTap: () {
                _subscription.cancel();
              },
                child: Text(
                  "chooseSub".tr,
                  textAlign: TextAlign.center,
                  style: Style.nunRegular(
                    fontSize: Dimens.d14,
                  ),
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
                if (subscriptionController.plan[0] == true) {
                  _purchasePlan("1 Month");
                } else if (subscriptionController.plan[1] == true) {
                  _purchasePlan("1 Year");
                }
                debugPrint("${subscriptionController.plan}");
              },
            ),
          ),
          Dimens.d30.spaceHeight,
        ],
      ),
    );
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

  Future<void> _purchasePlan(String plan) async {
    try {
      // Identify the product based on the selected plan
      String productId;
      if (plan == "1 Month") {
        productId = _kSilverSubscriptionId; // Use your actual product ID
      } else if (plan == "1 Year") {
        productId = _kGoldSubscriptionId; // Use your actual product ID
      } else {
        throw Exception("Invalid plan selected");
      }

      // Get the product details
      ProductDetails? selectedProduct = _products.firstWhereOrNull(
        (product) => product.id == productId,
      );

      if (selectedProduct == null) {
        print("selected plan ------ +++++ $selectedProduct");
        // Handle the case where the product is not found
        print("Product not found");
        return;
      }

      // Make the purchase
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: selectedProduct,
        applicationUserName: null,
      );

      bool success =
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

      if (!success) {
        // Handle unsuccessful purchase attempt
        print("$purchaseParam");

      } else {
        print("Purchase unsuccessful");

        showSnackBarSuccess(context, "Subscription set successful");
        checkData();
      }
    } catch (e) {
      // Handle any errors
      print("Error purchasing plan: $e");
    }
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

class ConsumableStore {
  static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future<void>.value();

  /// Adds a consumable with ID `id` to the store.
  ///
  /// The consumable is only added after the returned Future is complete.
  static Future<void> save(String id) {
    _writes = _writes.then((void _) => _doSave(id));
    return _writes;
  }

  /// Consumes a consumable with ID `id` from the store.
  ///
  /// The consumable was only consumed after the returned Future is complete.
  static Future<void> consume(String id) {
    _writes = _writes.then((void _) => _doConsume(id));
    return _writes;
  }

  /// Returns the list of consumables from the store.
  static Future<List<String>> load() async {
    return (await SharedPreferences.getInstance()).getStringList(_kPrefKey) ??
        <String>[];
  }

  static Future<void> _doSave(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKey, cached);
  }
}