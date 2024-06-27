import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/positive_moment/add_positive_page.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class PositiveScreen extends StatefulWidget {
  const PositiveScreen({super.key});

  @override
  State<PositiveScreen> createState() => _PositiveScreenState();
}

class _PositiveScreenState extends State<PositiveScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  ThemeController themeController = Get.find<ThemeController>();
  PositiveController positiveController = Get.put(PositiveController());
  late ScrollController scrollController = ScrollController();
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.white, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    scrollController.addListener(() {
      double showOffset = 10.0;

      if (scrollController.offset > showOffset) {
        showScrollTop.value = true;
      } else {
        showScrollTop.value = false;
      }
    });

    super.initState();
  }

  List positiveMoment = [
    "weekly",
    "monthly",
    "3 months ",
    "6 months",
    "yearly"
  ];

  searchBookmarks(String query, List bookmarks) {
    return bookmarks
        .where((bookmark) =>
            bookmark['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
        appBar: CustomAppBar(
          title: "positiveMoments".tr,
          showBack: true,
          action: Padding(
            padding: const EdgeInsets.only(right: Dimens.d20),
            child: GestureDetector(
              onTap: () {
                _onAddClick(context);
              },
              child: SvgPicture.asset(
                ImageConstant.addTools,
                height: Dimens.d22,
                width: Dimens.d22,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Dimens.d15.h.spaceHeight,
                  Row(
                    children: [
                      Container(
                        width: Get.width - 100,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: ColorConstant.themeColor.withOpacity(0.1),
                              blurRadius: Dimens.d8,
                            )
                          ],
                        ),
                        child:  CommonTextField(
                            onChanged: (value) {
                              setState(() {
                                positiveController.filteredBookmarks =
                                    searchBookmarks(value,
                                        positiveController.positiveMomentList);
                              });
                            },
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(ImageConstant.search),
                            ),
                            suffixIcon: searchController.text.isEmpty?const SizedBox(): Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: GestureDetector(
                                  onTap: () {
                                    searchController.clear();
                                    setState(() {
                                      positiveController.filteredBookmarks = positiveController.positiveMomentList;
                                    });
                                  },child: SvgPicture.asset(ImageConstant.close)),
                            ),
                            hintText: "search".tr,
                            textStyle:
                            Style.montserratRegular(fontSize: 12),
                            controller: searchController,
                            focusNode: searchFocusNode),

                      ),
                      Dimens.d10.spaceWidth,
                      GestureDetector(
                          onTap: () {
                            _showAlertDialogFilter(context, themeController);
                          },
                          child: SvgPicture.asset(ImageConstant.filterPositive))
                    ],
                  ),
                  Dimens.d30.h.spaceHeight,
                  GetBuilder<PositiveController>(
                    id: "update",
                    builder: (controller) {
                      return Expanded(
                        child: (controller.filteredBookmarks??[]).isNotEmpty
                            ? GridView.builder(
                                controller: scrollController,
                                padding:
                                    const EdgeInsets.only(bottom: Dimens.d20),
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1,
                                  crossAxisCount: 2,
                                  // Number of columns
                                  crossAxisSpacing: 20,
                                  // Spacing between columns
                                  mainAxisSpacing: 20, // Spacing between rows
                                ),
                                itemCount:
                                    controller.filteredBookmarks?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 156,
                                    width: 156,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    decoration: BoxDecoration(
                                        color: themeController.isDarkMode.isTrue
                                            ? ColorConstant.textfieldFillColor
                                            : ColorConstant.colorDCE9EE,
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            searchFocusNode.unfocus();
                                            _showAlertDialog(context,
                                                title: controller
                                                        .filteredBookmarks?[
                                                    index]["title"],
                                                image: controller
                                                        .filteredBookmarks?[
                                                    index]["img"],
                                                desc: controller
                                                        .filteredBookmarks?[
                                                    index]["des"]);
                                          },
                                          child: CommonLoadImage(
                                              borderRadius: 10.0,
                                              url:
                                                  controller.filteredBookmarks?[
                                                          index]["img"] ??
                                                      "",
                                              width: Dimens.d139,
                                              height: Dimens.d101),
                                        ),
                                        Dimens.d15.spaceHeight,
                                        Row(
                                          children: [
                                            const Spacer(),
                                            PopupMenuButton(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              color: themeController
                                                      .isDarkMode.isTrue
                                                  ? ColorConstant
                                                      .textfieldFillColor
                                                  : ColorConstant.white,
                                              child: SvgPicture.asset(
                                                ImageConstant.moreVert,
                                                height: 5,
                                              ),
                                              itemBuilder: (context) {
                                                return List.generate(
                                                  1,
                                                  (indexPop) {
                                                    return PopupMenuItem(
                                                        child: Column(
                                                      children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                            _onAddClick1(
                                                                image: controller
                                                                            .filteredBookmarks?[
                                                                        index]
                                                                    ["img"],
                                                                title: controller
                                                                            .filteredBookmarks?[
                                                                        index]
                                                                    ["title"],
                                                                description:
                                                                    controller
                                                                            .filteredBookmarks?[index]
                                                                        ["des"],
                                                                context,
                                                                controller.filteredBookmarks?[
                                                                            index]
                                                                        [
                                                                        "id"] ??
                                                                    "");
                                                        },
                                                        child: Container(
                                                          height: 28,
                                                          width: 86,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: ColorConstant
                                                                  .color5B93FF
                                                                  .withOpacity(
                                                                        0.05)),
                                                            child: Row(
                                                              children: [
                                                                Dimens.d5.spaceWidth,

                                                                SvgPicture.asset(
                                                                ImageConstant
                                                                    .editTools,
                                                                color: ColorConstant
                                                                    .color5B93FF,
                                                              ),
                                                                Dimens.d5.spaceWidth,


                                                                Text(
                                                                'edit'.tr,
                                                                style: Style
                                                                    .montserratRegular(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: ColorConstant
                                                                      .color5B93FF,
                                                                ),
                                                              ),
                                                                Spacer(),

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Dimens.d15.spaceHeight,
                                                      InkWell(
                                                        onTap: () {
                                                          Get.back();

                                                          _showAlertDialogDelete(
                                                              context,
                                                              index,
                                                                controller.filteredBookmarks?[
                                                                        index]
                                                                    ["id"]);
                                                          },
                                                        child: Container(
                                                          height: 28,
                                                          width: 86,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: ColorConstant
                                                                  .colorE71D36
                                                                  .withOpacity(
                                                                        0.05)),
                                                            child: Row(
                                                              children: [
                                                               Dimens.d5.spaceWidth,

                                                              SvgPicture.asset(
                                                                ImageConstant
                                                                    .delete,
                                                                color: ColorConstant
                                                                    .colorE71D36,
                                                              ),
                                                                Dimens.d5.spaceWidth,


                                                                Text(
                                                                'delete'.tr,
                                                                style: Style
                                                                    .montserratRegular(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: ColorConstant
                                                                      .colorE71D36,
                                                                ),
                                                              ),
                                                                Spacer(),

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                                  },
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                        Text(
                                          positiveController
                                                      .filteredBookmarks?[index]
                                                  ['title'] ??
                                              "",
                                          maxLines: 1,
                                          style: Style.montserratMedium(
                                              fontSize: Dimens.d14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                                child: SizedBox(
                                  height: Get.height - 400,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(ImageConstant.noData),
                                      Dimens.d20.spaceHeight,
                                      Text(
                                        "dataNotFound".tr,
                                        style:
                                            Style.montserratBold(fontSize: 24),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                      );
                    },
                  )
                ],
              ),
            ),
            Obx(
              () => positiveController.loader.isTrue
                  ? commonLoader()
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  void _showAlertDialogDelete(BuildContext context, int index, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          actions: <Widget>[
            Dimens.d18.spaceHeight,
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      ImageConstant.close,
                    ))),
            Center(
                child: SvgPicture.asset(
              ImageConstant.deleteAffirmation,
              height:  Dimens.d96,
              width:  Dimens.d96,
            )),
            Dimens.d20.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "areYouSureYouWantToDeletePo".tr,
                  style: Style.montserratRegular(
                    fontSize: Dimens.d14,
                  )),
            ),
            Dimens.d24.spaceHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CommonElevatedButton(
                  height: 33,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                  textStyle: Style.montserratRegular(
                      fontSize: Dimens.d12, color: ColorConstant.white),
                  title: "delete".tr,
                  onTap: () async {
                    Get.back();
                    await positiveController.deletePositiveMoment(id,context);
                    Future.delayed(const Duration(seconds: 1)).then(
                      (value) async {
                        await positiveController.getPositiveMoments();
                        setState(() {});
                      },
                    );
                    setState(() {});
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 33,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 21,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        border: Border.all(color: ColorConstant.themeColor)),
                    child: Center(
                      child: Text(
                        "cancel".tr,
                        style: Style.montserratRegular(fontSize: 14),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context,
      {String? title, String? desc, String? image}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              //backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              actions: <Widget>[
                Dimens.d21.spaceHeight,
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      ImageConstant.closePositive,
                      height: 28,
                      width: 28,
                    )),
                Dimens.d10.spaceHeight,
                CommonLoadImage(borderRadius: 10,
                    url: image!, width: Get.width, height: Dimens.d125),
                Dimens.d15.spaceHeight,
                Center(
                  child: Text(
                    title ?? "",
                    style: Style.cormorantGaramondBold(fontSize: 22),
                  ),
                ),
                Dimens.d20.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  child: Center(
                    child: Text(
                      desc ?? "",
                      textAlign: TextAlign.center,maxLines: 7,
                      style: Style.montserratRegular(fontSize: 12)
                          .copyWith(height: 2),
                    ),
                  ),
                ),
                Dimens.d22.spaceHeight,
              ],
            );
          },
        );
      },
    );
  }

  void _showAlertDialogFilter(
      BuildContext context, ThemeController themeController) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 299,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(11),
              topRight: Radius.circular(11),
            ),
            color: themeController.isDarkMode.isTrue
                ? ColorConstant.textfieldFillColor
                : ColorConstant.white,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      "Filter".tr,
                      style: Style.montserratRegular(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        ImageConstant.close,
                        color: themeController.isDarkMode.isTrue
                            ? ColorConstant.white
                            : ColorConstant.hintText,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        positiveController.onTapCon("isLastWeek");
                      },
                      child: Container(
                        height: 42,
                        width: 116,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border:
                                Border.all(color: ColorConstant.colorAFAFAF)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(
                              () => Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: ColorConstant.colorAFAFAF),
                                    color: positiveController.conTap.value ==
                                            'isLastWeek'
                                        ? ColorConstant.themeColor
                                        : ColorConstant.transparent),
                                child: positiveController.conTap.value ==
                                        'isLastWeek'
                                    ? Center(
                                            child: SvgPicture.asset(
                                              ImageConstant.done,
                                              height: 5.5,
                                              width: 8,
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                            ),
                            Text(
                              "Weekly".tr,
                              style: Style.montserratMedium(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        positiveController.onTapCon1("isLastMonth");
                      },
                      child: Container(
                        height: 42,
                        width: 124,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border:
                                Border.all(color: ColorConstant.colorAFAFAF)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(
                              () => Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: ColorConstant.colorAFAFAF),
                                    color: positiveController.conTap.value ==
                                            'isLastMonth'
                                        ? ColorConstant.themeColor
                                        : ColorConstant.transparent),
                                child: positiveController.conTap.value ==
                                        'isLastMonth'
                                    ? Center(
                                            child: SvgPicture.asset(
                                              ImageConstant.done,
                                              height: 5,
                                              width: 8,
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                            ),
                            Text(
                              "Monthly".tr,
                              style: Style.montserratMedium(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    positiveController.onTapCon2("isLastYear");
                  },
                  child: Container(
                    height: 42,
                    width: 103,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ColorConstant.colorAFAFAF),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(
                          () => Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: ColorConstant.colorAFAFAF),
                              color: positiveController.conTap.value ==
                                      'isLastYear'
                                  ? ColorConstant.themeColor
                                  : ColorConstant.transparent,
                            ),
                            child:
                                positiveController.conTap.value == 'isLastYear'
                                    ? Center(
                                    child: SvgPicture.asset(
                                      ImageConstant.done,
                                      height: 5,
                                      width: 8,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        Text(
                          "Yearly".tr,
                          style: Style.montserratMedium(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        positiveController.onTapCon3("isLastThreeMonths");
                      },
                      child: Container(
                        height: 42,
                        width: 133,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border:
                                Border.all(color: ColorConstant.colorAFAFAF)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(
                              () => Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: ColorConstant.colorAFAFAF),
                                      color: positiveController.conTap.value ==
                                              'isLastThreeMonths'
                                          ? ColorConstant.themeColor
                                          : ColorConstant.transparent),
                                  child: positiveController.conTap.value ==
                                          'isLastThreeMonths'
                                      ? Center(
                                              child: SvgPicture.asset(
                                                ImageConstant.done,
                                                height: 5,
                                                width: 8,
                                              ),
                                            )
                                          : const SizedBox()),
                            ),
                            Text(
                              "3 Months ".tr,
                              style: Style.montserratMedium(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        positiveController.onTapCon4("isLastSixMonths");
                      },
                      child: Container(
                        height: 42,
                        width: 134,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border:
                                Border.all(color: ColorConstant.colorAFAFAF)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(
                              () => Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: ColorConstant.colorAFAFAF),
                                      color: positiveController.conTap.value ==
                                              'isLastSixMonths'
                                          ? ColorConstant.themeColor
                                          : ColorConstant.transparent),
                                  child: positiveController.conTap.value ==
                                          'isLastSixMonths'
                                      ? Center(
                                          child: SvgPicture.asset(
                                            ImageConstant.done,
                                            height: 5,
                                            width: 8,
                                          ),
                                        )
                                      : const SizedBox()),
                            ),
                            Text(
                              "6 Months".tr,
                              style: Style.montserratMedium(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    await positiveController
                        .filterMoment(positiveController.conTap.value);
                  },
                  child: Container(
                    width: 238,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      color: ColorConstant.themeColor,
                    ),
                    child: Center(
                        child: Text(
                      "apply".tr,
                      style: Style.montserratRegular(
                          color: ColorConstant.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    )),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _onAddClick(BuildContext context) {
    final subscriptionStatus = "SUBSCRIBED";

    /// to check if item counts are not more then the config count in case of no subscription
    if (!(subscriptionStatus == "SUBSCRIBED" ||
        subscriptionStatus == "SUBSCRIBED")) {
      /*  Navigator.pushNamed(context, SubscriptionPage.subscription, arguments: {
        AppConstants.isInitialUser: AppConstants.noSubscription,
        AppConstants.subscriptionMessage: i10n.journalNoSubscriptionMessage,
      });*/
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return AddPositivePage(
            isFromMyAffirmation: true,
            isEdit: false,
          );
        },
      )).then(
        (value) async {
          await positiveController.getPositiveMoments();
          setState(() {});
        },
      );
    }
  }

  void _onAddClick1(BuildContext context, param1,
      {String? title, String? description, String? image}) {
    final subscriptionStatus = "SUBSCRIBED";

    /// to check if item counts are not more then the config count in case of no subscription
    if (!(subscriptionStatus == "SUBSCRIBED" ||
        subscriptionStatus == "SUBSCRIBED")) {
      /*  Navigator.pushNamed(context, SubscriptionPage.subscription, arguments: {
        AppConstants.isInitialUser: AppConstants.noSubscription,
        AppConstants.subscriptionMessage: i10n.journalNoSubscriptionMessage,
      });*/
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return AddPositivePage(
            id: param1,
            title: title,
            des: description,
            image: image,
            isFromMyAffirmation: true,
            isEdit: true,
          );
        },
      )).then(
        (value) async {
          await positiveController.getPositiveMoments();
          setState(() {});
        },
      );
    }
  }
}
