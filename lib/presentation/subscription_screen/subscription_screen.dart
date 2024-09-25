import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/main.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_motivational.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_stress.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feeling_today_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feelings_evening.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/motivational_questions.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/sleep_questions.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/stress_questions.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  bool loader = false;
  DateTime now = DateTime.now();
  DateTime? futureDate;
  bool valueChecked = false;
  String greeting = "";
  String currentLanguage = PrefService.getString(PrefKey.language);

  @override
  void initState() {
    super.initState();
    if (PrefService.getString(PrefKey.language) == "") {
      setState(() {
        currentLanguage = "en-US";
      });
    }
    _setGreetingBasedOnTime();
    getUserData();

    print('Current Date: $now');
    print('Future Date: $futureDate');
  }
  void _setGreetingBasedOnTime() {
    greeting = _getGreetingBasedOnTime();
    setState(() {});
  }

  String _getGreetingBasedOnTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'goodMorning';
    } else if (hour >= 12 && hour < 17) {
      return 'goodAfternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'goodEvening';
    } else {
      return 'goodNight';
    }
  }
  getUserData() async {
    await getUSer();
    subscriptionController.plan.clear();
    List.generate(2, (index) {
      subscriptionController.plan.add(false);
    },);
    if(getUserModel.data!.isSubscribed==true){
      if (getUserModel.data!.subscriptionId == "transform_yearly") {
        setState(() {
          subscriptionController.plan[1] = true.obs;
        });
      } else if (getUserModel.data!.subscriptionId ==
          "transform_monthly") {
        setState(() {
          subscriptionController.plan[0] = true.obs;
        });
      }
      else
      {
        setState(() {
          subscriptionController.plan[0] = true.obs;
        });
      }
    }
    else
    {
      setState(() {

      });
    }

    for (int i = 0; i < subscriptionController.plan.length; i++) {
      if (subscriptionController.plan[0] == true || subscriptionController.plan[1] == true) {
        setState(() {
          valueChecked = true;
        });
      }
    }
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
            (List<PurchaseDetails> purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        },
        onDone: () async {
          await _subscription.cancel();
        },
        onError: (Object error) {
          // handle error here.
        });
    initStoreInfo();
    setState(() {
      futureDate =
          now.add(const Duration(days: 365 + 7)); // Adding 1 year and 1 week
    });
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    setState(() {
    });
  }

  void showPendingUI() {
    setState(() {
    });
  }

  void handleError(IAPError error) {
    setState(() {
    });
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.canceled) {
        // Subscription canceled
        print("Subscription has been canceled");
        setState(() {
          subscriptionController.plan.clear();
        });
        await updateUser(context);
        await getUSer();
      } else if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle errors
        showSnackBarError(context, purchaseDetails.error!.message);
        handleError(purchaseDetails.error!);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Successfully purchased or restored
        final bool valid = await _verifyPurchase(purchaseDetails);

        if (valid) {
          if (!valueChecked) {
            try {
              setState(() {
                loader = true;
              });
              var headers = {
                'Authorization':
                    'Bearer ${PrefService.getString(PrefKey.token)}'
              };

              var request = http.MultipartRequest(
                  'POST',
                  Uri.parse(
                      '${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));

              request.fields.addAll({
                'isSubscribed': "true",
                'subscriptionId':
                    subscriptionController.plan[1].toString() == "true"
                        ? "transform_yearly"
                        : subscriptionController.plan[0] == true
                            ? "transform_monthly"
                            : "Free",
                'subscriptionTitle':
                    subscriptionController.plan[1].toString() == "true"
                        ? "Premium Yearly"
                        : subscriptionController.plan[0] == true
                            ? "Premium Monthly"
                            : "Free",
                'subscriptionDescription': "",
                'price': "₣${subscriptionController.plan[1]}" == "true"
                    ? "49.99"
                    : subscriptionController.plan[0] == true
                        ? "6.99"
                        : "Free",
                'rawPrice': "",
                'currencyCode': "",
                'subscriptionDate': DateTime.now().toString(),
                'expiryDate': "",
              });

              request.headers.addAll(headers);

              http.StreamedResponse response = await request.send();

              if (response.statusCode == 200) {
                setState(() {
                  loader = false;
                });
                await getUSer();
                _showAlertDialog(context);
              } else {
                setState(() {
                  loader = false;
                });
                debugPrint(response.reasonPhrase);
              }
            } catch (e) {
              setState(() {
                loader = false;
              });
              debugPrint(e.toString());
            }
          }
          setState(() {
            loader = false;
          });
          // Call API after successful verification
          debugPrint("purchase details =========+++++$purchaseDetails");

          // Deliver the product
          unawaited(deliverProduct(purchaseDetails));
        } else {
          _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }

      // Handle Android-specific consumption for consumable items
      if (Platform.isAndroid) {
        if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
          final InAppPurchaseAndroidPlatformAddition androidAddition =
              _inAppPurchase
                  .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchaseDetails);
        }
      }

      // Complete pending purchases
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    debugPrint("when user get purchase status ${purchaseDetails.status}");
    debugPrint("when user get purchase error ${purchaseDetails.error}");
    debugPrint(
        "when user get purchase pendingCompletePurchase ${purchaseDetails.pendingCompletePurchase}");
    debugPrint("when user get purchase productID ${purchaseDetails.productID}");
    debugPrint(
        "when user get purchase purchaseID ${purchaseDetails.purchaseID}");
    debugPrint(
        "when user get purchase transactionDate ${purchaseDetails.transactionDate}");
    debugPrint(
        "when user get purchase verificationData ${purchaseDetails.verificationData}");
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    debugPrint("deliverProduct =========+++++   $purchaseDetails");

    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      setState(() {
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
      });
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    debugPrint("after verify purchase details ======++++ $purchaseDetails");
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
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
      _products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
    });


    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _products = productDetailResponse.productDetails;
    });
    print("consumable list $consumables");
    if(getUserModel.data!.isSubscribed==true){
      if (getUserModel.data!.subscriptionId == "transform_yearly") {
        setState(() {
          subscriptionController.plan[1] = true.obs;
        });
      } else if (getUserModel.data!.subscriptionId ==
          "transform_monthly") {
        setState(() {
          subscriptionController.plan[0] = true.obs;
        });
      }
      else
      {
        setState(() {
          subscriptionController.plan[0] = true.obs;
        });
      }
    }

    for (int i = 0; i < subscriptionController.plan.length; i++) {
      if (subscriptionController.plan[0] == true || subscriptionController.plan[1] == true) {
        setState(() {
          valueChecked = true;
        });
      }
    }
  }
  Future<void> checkData() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
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
      _products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
    });


    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _products = productDetailResponse.productDetails;
    });
    print("consumable list $consumables");
    print("productDetailResponse details To save in api $productDetailResponse");
    if(getUserModel.data!.isSubscribed==true){
      if (getUserModel.data!.subscriptionId == "transform_yearly") {
        setState(() {
          subscriptionController.plan[1] = true.obs;
        });
      } else if (getUserModel.data!.subscriptionId ==
          "transform_monthly") {
        setState(() {
          subscriptionController.plan[0] = true.obs;
        });
      }
      else
      {
        setState(() {
          subscriptionController.plan[0] = true.obs;
        });
      }
    }

  }

  GetUserModel getUserModel = GetUserModel();

  getUSer() async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getUser}${PrefService.getString(PrefKey.userId)}",
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getUserModel = getUserModelFromJson(responseBody);
        isSubscribed = getUserModel.data?.isSubscribed ?? false;

        await PrefService.setValue(
            PrefKey.userImage, getUserModel.data?.userProfile ?? "");
        await PrefService.setValue(
            PrefKey.isFreeUser, getUserModel.data?.isFreeVersion ?? false);
        await PrefService.setValue(
            PrefKey.isSubscribed, getUserModel.data?.isSubscribed ?? false);
        await PrefService.setValue(
            PrefKey.subId, getUserModel.data?.subscriptionId ?? '');
        setState(() {

        });
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25,),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: 300,
                      width: Get.width,
                      color: const Color(0xffF6FBF5),
                    ),
                    Image.asset(
                      ImageConstant.sub,
                      height: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Dimens.d20.spaceWidth,
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(
                              ImageConstant.close,
                              height: 22,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          widget.skip!
                              ? GestureDetector(
                                  onTap: () async {
                                    await PrefService.setValue(
                                        PrefKey.subscription, true);
                                    await PrefService.setValue(
                                        PrefKey.firstTimeRegister, true);
                                    await PrefService.setValue(
                                        PrefKey.addGratitude, true);
                                    /* Navigator.push(context, MaterialPageRoute(
                                                builder: (context) {
                                                  return const WelcomeHomeScreen();
                                                },
                                              ));*/
                                    if (getUserModel
                                            .data?.morningMoodQuestions ??
                                        false == false &&
                                            greeting == "goodMorning") {
                                      Get.offAll(() => SleepQuestions());
                                    } else if (getUserModel
                                            .data?.morningSleepQuestions ??
                                        false == false &&
                                            greeting == "goodMorning") {
                                      Get.offAll(() => StressQuestions());
                                    } else if (getUserModel
                                            .data?.morningStressQuestions ??
                                        false == false &&
                                            greeting == "goodMorning") {
                                      Get.offAll(() =>
                                          const HowFeelingTodayScreen());
                                    } else if (getUserModel.data
                                            ?.morningMotivationQuestions ??
                                        false == false &&
                                            greeting == "goodMorning") {
                                      Get.offAll(
                                          () => MotivationalQuestions());
                                    } else if (getUserModel
                                            .data?.eveningMoodQuestions ??
                                        false == false &&
                                            greeting == "goodEvening") {
                                      Get.offAll(
                                          () => const HowFeelingsEvening());
                                    } else if (getUserModel
                                            .data?.eveningStressQuestions ??
                                        false == false &&
                                            greeting == "goodEvening") {
                                      Get.offAll(() => EveningStress());
                                    } else if (getUserModel.data
                                            ?.eveningMotivationQuestions ??
                                        false == false &&
                                            greeting == "goodEvening") {
                                      Get.offAll(() => EveningMotivational());
                                    } else {
                                      Get.offAll(
                                          () => const DashBoardScreen());
                                    }
                            },
                            child: Text(
                              "skip".tr,
                              style: Style.nunRegular(
                                  color: ColorConstant.black,
                                  fontSize: Dimens.d16),
                            ),
                          )
                              : const SizedBox(),
                          Dimens.d20.spaceWidth,
                        ],
                      ),
                    )
                  ],
                ),
                Dimens.d10.spaceHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "PREMIUM",
                      style: Style.nunitoBold(
                        fontSize: Dimens.d16,
                        color: ColorConstant.themeColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      ImageConstant.star,
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
                Dimens.d10.spaceHeight,
                Text(
                  "Try it for free".tr,
                  style: Style.nunitoBold(
                    fontSize: Dimens.d28,
                  ),
                  textAlign: TextAlign.center,
                ),
                Dimens.d10.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 43),
                  child: Text(
                    "Unleash your full potential with TransformYourMind!".tr,
                    style: Style.nunMedium(
                        fontSize: Dimens.d14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Dimens.d10.spaceHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "PREMIUM PLUS",
                      style: Style.nunitoBold(
                        fontSize: Dimens.d16,
                        color: ColorConstant.themeColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      ImageConstant.star,
                      width: 25,
                      height: 25,
                    ),
                    Image.asset(
                      ImageConstant.star,
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
                Dimens.d10.spaceHeight,
                Text(
                  "Unlock all functions".tr,
                  style: Style.nunitoBold(
                    fontSize: Dimens.d28,
                  ),
                  textAlign: TextAlign.center,
                ),
                Dimens.d10.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: currentLanguage == "en-US" ? Text(
                    '''Unlock advanced features with a subscription and enhance your experience.
                      Enjoy exclusive tools like pods and gratitude journal ,self hypnosis,
                      Subscribe now to access even more features!''',
                    style: Style.nunMedium(
                        fontSize: Dimens.d18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ) : Text(
                    "Affirmationen und tiefgehenden Meditation bis hin zu transformierenden Selbsthypnose-Audios, deinem personlichen Wohlfuhlbarometer und Achtsamkeitstraining.",
                    style: Style.nunMedium(
                        fontSize: Dimens.d14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,),
                ),

                Dimens.d20.spaceHeight,
                selectPlan()
              ],
            ),
          ),
          if (loader == true) commonLoader() else
            const SizedBox()
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          actions: <Widget>[
            Dimens.d27.spaceHeight,
            Center(
                child: SvgPicture.asset(
                  ImageConstant.passwordCheck,
                  height: Dimens.d100,
                  width: Dimens.d100,
                )),
            Dimens.d8.spaceHeight,
            Center(
              child: Text("Thank you for subscribing".tr,
                  textAlign: TextAlign.center,
                  style: Style.nunMedium(
                    fontSize: Dimens.d22,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            Dimens.d7.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "YourTransactionSuccess".tr,
                  style: Style.nunRegular(
                    fontSize: Dimens.d12,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            Dimens.d31.spaceHeight,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
              child: CommonElevatedButton(
                title: "ok".tr,
                onTap: () {
                  Get.back();
                },
              ),
            )
          ],
        );
      },
    );
  }

  Widget selectPlan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => subscriptionController.plan.isNotEmpty
                ? ListView.builder(
                    itemCount: currentLanguage == "en-US"
                        ? subscriptionController.selectPlan.length
                        : subscriptionController.selectPlanG.length,
                    shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                      var data;

                      if (currentLanguage == "en-US") {
                        data = subscriptionController.selectPlan[index];
                      } else {
                        data = subscriptionController.selectPlanG[index];
                      }
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
                                ? ColorConstant.color7C9EA7.withOpacity(0.10)
                                : themeController.isDarkMode.isTrue
                                    ? ColorConstant.transparent
                                    : Colors.transparent,
                            border: Border.all(
                              color: subscriptionController.plan[index] == true
                            ? themeController.isDarkMode.isTrue
                                      ? ColorConstant.white
                                      : ColorConstant.themeColor
                                          .withOpacity(0.10)
                                  : themeController.isDarkMode.isTrue
                                      ? ColorConstant.transparent
                                      : Colors.transparent,
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
                                          ImageConstant.checkSubSub,
                                          height: Dimens.d24,
                                          width: Dimens.d24,
                                          color:
                                              themeController.isDarkMode.isTrue
                                                  ? ColorConstant.white
                                                  : ColorConstant.black,
                                        )
                                      : Container(
                              height: Dimens.d24,
                              width: Dimens.d24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: themeController.isDarkMode.isTrue
                                      ? ColorConstant.white
                                                  : ColorConstant.black,
                                            ),
                                          ),
                            ),
                            Dimens.d10.spaceWidth,
                            Text(
                              data["plan"],
                                    style: Style.nunitoBold(fontSize: 16),
                                  ),
                                ],
                        ),
                        Dimens.d5.spaceHeight,
                              Padding(
                                padding: const EdgeInsets.only(left: 35),
                                child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["des"],
                                style: Style.nunRegular(
                                  fontSize: 13,
                                        color: themeController.isDarkMode.isTrue
                                            ? ColorConstant.colorBFBFBF
                                            : ColorConstant.color525252,
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
            ):const SizedBox(),
          ),
          Dimens.d40.spaceHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: valueChecked
                ? CommonElevatedButton(
                    title: "cancelSub".tr,
                    buttonColor: ColorConstant.themeColor,
                    onTap: () async {
                      showCancelSubscriptionDialog(context);
                    },
                  )
                : CommonElevatedButton(
                    title: "purchase".tr,
              buttonColor:
              valueChecked ? Colors.grey : ColorConstant.themeColor,
              onTap: () async {


                if (!valueChecked) {
                  if (subscriptionController.plan[0] == true) {
                    _purchasePlan("1 Month");
                  } else if (subscriptionController.plan[1] == true) {
                    _purchasePlan("1 Year");
                  }
                  debugPrint("${subscriptionController.plan}");
               }
              },
            ),
          ),
          Dimens.d15.spaceHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  ImageConstant.secure,
                  color: themeController.isDarkMode.isTrue
                      ? ColorConstant.white
                      : ColorConstant.black,
                ),
                Dimens.d10.spaceWidth,
                Text(
                  "Secured by the App Store. Can be canceled at any time".tr,
                  style: Style.nunRegular(
                    fontSize: 12,
                    color: themeController.isDarkMode.isTrue
                        ? ColorConstant.white
                        : ColorConstant.black,
                  ),
                ),
              ],
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
              fontSize: 14,
              color: themeController.isDarkMode.isTrue ? ColorConstant.white : ColorConstant.black,
            ),
          ),
          TextSpan(
            text: des,
            style: Style.nunMedium(
              fontSize: 14,
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
/*if(Platform.isAndroid) {

        await api();
}*/
        checkData();
        /*     if(Platform.isAndroid) {

          Get.back();
        }*/
      }
    } catch (e) {
      // Handle any errors
      showSnackBarError(context, "Error purchasing plan: $e");
    }
  }

  Future<void> _updatePlan(String plan) async {
    try {
      // Logic for updating the plan
      String productId;
      if (plan == "1 Month") {
        productId = _kSilverSubscriptionId;
      } else if (plan == "1 Year") {
        productId = _kGoldSubscriptionId;
      } else {
        throw Exception("Invalid plan selected");
      }

      ProductDetails? selectedProduct = _products.firstWhereOrNull(
        (product) => product.id == productId,
      );

      if (selectedProduct == null) {
        print("Product not found");
        return;
      }

      // Simulate plan update (this could involve sending an API request, etc.)
      print("Updating plan to: $plan");

      // After successful update
      checkData();
    } catch (e) {
      showSnackBarError(context, "Error updating plan: $e");
    }
  }

  Future<void> showCancelSubscriptionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Cancel Subscription',
            style: Style.nunRegular(
                color: themeController.isDarkMode.value
                    ? ColorConstant.white
                    : ColorConstant.black,
                fontSize: Dimens.d16),
          ),
          content: Text(
            'Are you sure you want to cancel your subscription?',
            style: Style.nunRegular(
                color: themeController.isDarkMode.value
                    ? ColorConstant.white
                    : ColorConstant.black,
                fontSize: Dimens.d16),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Yes',
                style: Style.nunRegular(
                    color: themeController.isDarkMode.value
                        ? ColorConstant.white
                        : ColorConstant.black,
                    fontSize: Dimens.d16),
              ),
              onPressed: () {
                if (Platform.isIOS) {
                  openAppleSubscriptions();
                } else {
                  openGooglePlaySubscriptions();
                }
              },
            ),
            TextButton(
              child: Text(
                'No',
                style: Style.nunRegular(
                    color: themeController.isDarkMode.value
                        ? ColorConstant.white
                        : ColorConstant.black,
                    fontSize: Dimens.d16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then(
      (value) async {
        await checkData();
      },
    );
  }

  updateUser(BuildContext context) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));
      request.fields.addAll({
        'isSubscribed': "false",
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await PrefService.setValue(PrefKey.focuses, true);
      //  showSnackBarSuccess(context, "cancel subscription successfully");

        Get.back();
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void openGooglePlaySubscriptions() async {
    const url = 'https://play.google.com/store/account/subscriptions';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openAppleSubscriptions() async {
    const url = 'https://apps.apple.com/account/subscriptions';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
