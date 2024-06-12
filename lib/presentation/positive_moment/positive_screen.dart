import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/edit_profile_screen.dart';
import 'package:transform_your_mind/presentation/positive_moment/add_positive_page.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
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
  List? _filteredBookmarks;

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
    setState(() {
      _filteredBookmarks = positiveController.positiveMomentList;
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
      child: Scaffold(
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
        body: Padding(
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
                    child: CommonTextField(
                        onChanged: (value) {
                          setState(() {
                            _filteredBookmarks = searchBookmarks(
                                value, positiveController.positiveMomentList);
                          });
                        },
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: SvgPicture.asset(ImageConstant.searchExplore),
                        ),
                        hintText: "search".tr,
                        controller: searchController,
                        focusNode: searchFocusNode),
                  ),
                  Dimens.d10.spaceWidth,
                  GestureDetector(
                      onTap: () {
                        _showAlertDialogFilter(context);
                      },
                      child: SvgPicture.asset(ImageConstant.filterPositive))
                ],
              ),
              Dimens.d30.h.spaceHeight,
              Expanded(
                child: _filteredBookmarks != null
                    ? GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: Dimens.d20),
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
                        itemCount: _filteredBookmarks?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 156,
                            width: 156,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                                color: ColorConstant.colorDCE9EE,
                                borderRadius: BorderRadius.circular(18)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    searchFocusNode.unfocus();
                                    _showAlertDialog(context);
                                  },
                                  child: Image.asset(
                                    _filteredBookmarks?[index]["img"] ?? "",
                                    height: 101,
                                    width: 138,
                                  ),
                                ),
                                /*      CustomImageView(
                                  imagePath: positiveController
                                      .positiveMomentList[index]['image'],
                                  height: Dimens.d135,
                                  radius: BorderRadius.circular(10),
                                  fit: BoxFit.cover,
                                ),*/
                                Dimens.d10.spaceHeight,
                                Row(
                                  children: [
                                    Spacer(),
                                    PopupMenuButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      color: ColorConstant.white,
                                      child: SvgPicture.asset(
                                          ImageConstant.moreVert),
                                      itemBuilder: (context) {
                                        return List.generate(
                                          1,
                                          (index) {
                                            return PopupMenuItem(
                                                child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _onAddClick1(context);
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    width: 86,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: ColorConstant
                                                            .color5B93FF
                                                            .withOpacity(0.05)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SvgPicture.asset(
                                                          ImageConstant
                                                              .editTools,
                                                          color: ColorConstant
                                                              .color5B93FF,
                                                        ),
                                                        Text(
                                                          'Edit',
                                                          style: Style
                                                              .montserratRegular(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorConstant
                                                                .color5B93FF,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Dimens.d15.spaceHeight,
                                                InkWell(
                                                  onTap: () {
                                                    _showAlertDialogDelete(context, index);
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    width: 86,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: ColorConstant
                                                            .colorE71D36
                                                            .withOpacity(0.05)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SvgPicture.asset(
                                                          ImageConstant.delete,
                                                          color: ColorConstant
                                                              .colorE71D36,
                                                        ),
                                                        Text(
                                                          'Delete',
                                                          style: Style
                                                              .montserratRegular(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorConstant
                                                                .colorE71D36,
                                                          ),
                                                        ),
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
                                  _filteredBookmarks?[index]['title'] ?? "",
                                  maxLines: Dimens.d2.toInt(),
                                  style: Style.montserratMedium(
                                      fontSize: Dimens.d14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        })
                    : GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: Dimens.d20),
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
                        itemCount: positiveController.positiveMomentList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              searchFocusNode.unfocus();
                              _showAlertDialog(context);
                              // _onTileClick(index, context);
                            },
                            child: Container(
                              height: 156,
                              width: 156,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              decoration: BoxDecoration(
                                  color: ColorConstant.colorDCE9EE,
                                  borderRadius: BorderRadius.circular(18)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    positiveController.positiveMomentList[index]
                                        ["img"],
                                    height: 101,
                                    width: 138,
                                  ),
                                  /*      CustomImageView(
                                        imagePath: positiveController
                                            .positiveMomentList[index]['image'],
                                        height: Dimens.d135,
                                        radius: BorderRadius.circular(10),
                                        fit: BoxFit.cover,
                                      ),*/
                                  Dimens.d12.spaceHeight,
                                  Text(
                                    positiveController.positiveMomentList[index]
                                        ['title'],
                                    maxLines: Dimens.d2.toInt(),
                                    style: Style.montserratMedium(
                                        fontSize: Dimens.d14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialogDelete(BuildContext context, int index) {
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
                  height: Dimens.d140,
                  width: Dimens.d140,
                )),
            Dimens.d20.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "Are you sure want to delete positive moments ?".tr,
                  style: Style.montserratRegular(
                    fontSize: Dimens.d14,
                  )),
            ),
            Dimens.d24.spaceHeight,
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CommonElevatedButton(
                  height: 33,
                  textStyle: Style.montserratRegular(
                      fontSize: Dimens.d12, color: ColorConstant.white),
                  title: "Delete".tr,
                  onTap: () {
                    setState(() {

                    });
                    Get.back();
                  },
                ),
                Container(
                  height: 33,margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 21,),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      border: Border.all(color: ColorConstant.themeColor)),
                  child: Center(
                    child: Text(
                      "cancel".tr,
                      style: Style.montserratRegular(fontSize: 14),
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
  void _showAlertDialog(BuildContext context) {
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
                Image.asset(ImageConstant.moment),
                Dimens.d15.spaceHeight,
                Center(
                  child: Text(
                    "Meditation".tr,
                    style: Style.cormorantGaramondBold(fontSize: 22),
                  ),
                ),
                Dimens.d20.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  child: Text(
                    "Ever wondered why addiction takes hold? From innocent curiosity to relentless cravings, uncover the roots of addiction and empower yourself with knowledge.",
                    textAlign: TextAlign.center,
                    style: Style.montserratRegular(fontSize: 12)
                        .copyWith(height: 2),
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

  void _showAlertDialogFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 299,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(11),
              topRight: Radius.circular(11),
            ),
            color: ColorConstant.white,
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
                        color: ColorConstant.hintText,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        positiveController.onTapCon("value");
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
                                            'value'
                                        ? ColorConstant.themeColor
                                        : ColorConstant.transparent),
                                child:
                                    positiveController.conTap.value == 'value'
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
                        positiveController.onTapCon1("select");
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
                                            'select'
                                        ? ColorConstant.themeColor
                                        : ColorConstant.transparent),
                                child:
                                    positiveController.conTap.value == 'select'
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
                    positiveController.onTapCon2("year");
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
                              color: positiveController.conTap.value == 'year'
                                  ? ColorConstant.themeColor
                                  : ColorConstant.transparent,
                            ),
                            child: positiveController.conTap.value == 'year'
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
                        positiveController.onTapCon3("month");
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
                                              'month'
                                          ? ColorConstant.themeColor
                                          : ColorConstant.transparent),
                                  child:
                                      positiveController.conTap.value == 'month'
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
                        positiveController.onTapCon4("selectMonth");
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
                                              'selectMonth'
                                          ? ColorConstant.themeColor
                                          : ColorConstant.transparent),
                                  child: positiveController.conTap.value ==
                                          'selectMonth'
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
                Container(
                  width: 238,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color: ColorConstant.themeColor,
                  ),
                  child: Center(
                      child: Text(
                    "Apply".tr,
                    style: Style.montserratRegular(
                        color: ColorConstant.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // void _showAlertDialogFilter(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             //backgroundColor: Colors.white,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(11.0), // Set border radius
  //             ),
  //             content: Column(mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Dimens.d5.spaceHeight,
  //                 GestureDetector(
  //                     onTap: () {
  //                       Get.back();
  //                     },
  //                     child: Align(
  //                       alignment: Alignment.topRight,
  //                       child: SvgPicture.asset(
  //                         ImageConstant.closePositive,
  //                         height: 28,
  //                         width: 28,
  //                       ),
  //                     )),
  //                 Dimens.d10.spaceHeight,
  //                 SizedBox(
  //                   height: Dimens.d150,
  //                   width: Dimens.d100,
  //                   child: ListView.builder(
  //                     itemCount: positiveMoment.length,
  //                     itemBuilder: (context, index) {
  //                       return Padding(
  //                         padding: const EdgeInsets.only(bottom: 10.0),
  //                         child: Center(
  //                             child: Text(
  //                           positiveMoment[index],
  //                           style: Style.montserratRegular(fontSize: 18),
  //                         )),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //                 Dimens.d10.spaceHeight,
  //                 Padding(
  //                   padding:EdgeInsets.symmetric(horizontal: 40),
  //                   child: CommonElevatedButton(
  //                     height: 30,
  //                     title: "submit".tr,
  //                     onTap: () {},
  //                   ),
  //                 )
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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
          return const AddPositivePage(
            isFromMyAffirmation: true,
            isEdit: false,
          );
        },
      )).then(
        (value) {
          setState(() {});
        },
      );
    }
  }
  void _onAddClick1(BuildContext context) {
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
          return const AddPositivePage(
            isFromMyAffirmation: true,
            isEdit: true,
          );
        },
      )).then(
            (value) {
          setState(() {});
        },
      );
    }
  }
}
