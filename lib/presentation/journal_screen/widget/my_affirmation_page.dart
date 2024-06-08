import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/affirmation_share_screen.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/edit_affirmation_dialog_widget.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/app_confirmation_dialog.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/divider.dart';

List affirmationList = [];
List affirmationDraftList = [];

class MyAffirmationPage extends StatefulWidget {
  const MyAffirmationPage({super.key});

  @override
  State<MyAffirmationPage> createState() => _MyAffirmationPageState();
}

class _MyAffirmationPageState extends State<MyAffirmationPage>
    with SingleTickerProviderStateMixin {
  List listOfBookmarks = [
    {
      "title": "Health",
      "des":
          "There is no right or wrong way to meditate but it’s important to find a correct practice that helps you to meets your needs and overcome with issues and manage symptoms of conditions such a"
    },
    {
      "title": "Self-esteem",
      "des":
          "Self-esteem Affirmations help to replace negative thoughts with positive ones"
    },
    {
      "title": "Success",
      "des":
          "If you find these quotes helpful why not spread a little light around by sharing them with others? Spreading forgiveness around is a lovely way to enhance your day. "
    },
    {
      "title": "Health",
      "des":
          "Meditation is practiced to train attention and awareness, and achieve a mentally clear and emotionally calm and stable state. "
    },
  ];

  int pageNumber = 1;
  int pageNumberAf = 0;
  int totalItemCountOfBookmarks = 0;
  int itemIndexToRemove = -1;
  int pageNumberDrafts = 1;

  //k-naveen
  bool _isLoading = false;
  bool _isLoadingDraft = false;
  int totalItemCountOfAffirmation = 0;
  int totalItemCountOfAffirmationDrafts = 0;

  TextEditingController searchController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  FocusNode searchFocus = FocusNode();

  bool _isSearching = true;
  Timer? _debounce;

  int _currentTabIndex = 0;
  ValueNotifier<bool> isDraftAdded = ValueNotifier(false);

  List categoryList = [
    {"title": "Self-Esteem"},
    {"title": "Health"},
    {"title": "Success"},
  ];

  final TextEditingController _userAffirmationController =
      TextEditingController();
  final FocusNode _userAffirmationFocus = FocusNode();
  int perPageCount = 100;
  ValueNotifier selectedCategory = ValueNotifier(null);
  bool like = false;
  List? _filteredBookmarks;

  @override
  void initState() {
    setState(() {
      _filteredBookmarks = listOfBookmarks;
    });
    super.initState();
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
          return const AddAffirmationPage(
            isFromMyAffirmation: true,
            isEdit: false,
          );
        },
      )).then(
        (value) {
          setState(() {});
          if (value != null && value is bool) {
            value ? affirmationList.clear() : affirmationDraftList.clear();
            setState(() {});
          }
        },
      );
    }
  }

  searchBookmarks(String query, List bookmarks) {
    return bookmarks
        .where((bookmark) =>
            bookmark['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? ColorConstant.black : ColorConstant.backGround,
      appBar: CustomAppBar(
        showBack: true,
        title: "myAffirmation".tr,
        action: (_isLoading || _isLoadingDraft)
            ? const Offstage()
            : Padding(
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
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimens.d100),
                  child: SvgPicture.asset(ImageConstant.profile1),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.d120),
                  child: SvgPicture.asset(ImageConstant.profile2),
                )),
            LayoutContainer(
              vertical: 0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dimens.d13.spaceHeight,
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentTabIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.d14),
                          height: Dimens.d38,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: _currentTabIndex == 0
                                      ? ColorConstant.transparent
                                      : themeController.isDarkMode.value
                                          ? ColorConstant.white
                                          : ColorConstant.black,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(33),
                              color: _currentTabIndex == 0
                                  ? ColorConstant.themeColor
                                  : ColorConstant.transparent),
                          child: Center(
                            child: Text(
                              "yourAffirmation".tr,
                              style: Style.montserratRegular(
                                  fontSize: Dimens.d14,
                                  color: _currentTabIndex == 0
                                      ? ColorConstant.white
                                      : themeController.isDarkMode.value
                                          ? ColorConstant.white
                                          : ColorConstant.black),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentTabIndex = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.d34),
                          height: Dimens.d38,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(33),
                              border: Border.all(
                                  color: _currentTabIndex == 1
                                      ? ColorConstant.transparent
                                      : themeController.isDarkMode.value
                                          ? ColorConstant.white
                                          : ColorConstant.black,
                                  width: 0.5),
                              color: _currentTabIndex == 1
                                  ? ColorConstant.themeColor
                                  : ColorConstant.transparent),
                          child: Center(
                            child: Text(
                              "affirmation".tr,
                              style: Style.montserratRegular(
                                  fontSize: Dimens.d14,
                                  color: _currentTabIndex == 1
                                      ? ColorConstant.white
                                      : themeController.isDarkMode.value
                                          ? ColorConstant.white
                                          : ColorConstant.black),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Dimens.d16.spaceHeight,
                  const DividerWidget(),
                  Dimens.d20.spaceHeight,
                  _getTabListOfGoals(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTabListOfGoals() {
    if (_currentTabIndex == 0) {
      return yourAffirmationWidget();
    } else {
      return transformAffirmationWidget();
    }
  }

  Widget yourAffirmationWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ///draft part
            _draftAffirmationListWidget(),
            Dimens.d15.spaceHeight,
            affirmationList.isNotEmpty
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Text("myAffirmation".tr,
                        style: Style.cormorantGaramondBold(
                          fontSize: Dimens.d20,
                        )),
                  )
                : const SizedBox(),
            Dimens.d11.spaceHeight,
            ListView.builder(
              itemCount: affirmationList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final data = affirmationList[index];
                return Slidable(
                  closeOnScroll: true,
                  key: const ValueKey<String>("" ?? ""),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dragDismissible: false,
                    extentRatio: 0.26,
                    children: [
                      Dimens.d20.spaceWidth,
                      GestureDetector(
                        onTap: () {
                          affirmationList.removeAt(index);
                          _isSearching = affirmationList.isNotEmpty;
                          setState(() {});
                        },
                        child: Container(
                          width: Dimens.d65,
                          margin: EdgeInsets.only(bottom: Dimens.d20.h),
                          decoration: BoxDecoration(
                            color: ColorConstant.deleteRed,
                            borderRadius: Dimens.d16.radiusAll,
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            ImageConstant.icDeleteWhite,
                            width: Dimens.d24,
                            height: Dimens.d24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AffirmationShareScreen(
                          des: affirmationList[index]["des"],
                          title: affirmationList[index]["title"],
                        );
                      },
                    ));
                  },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: Dimens.d16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.d11, vertical: Dimens.d11),
                      decoration: BoxDecoration(
                        color: ColorConstant.white,
                        borderRadius: Dimens.d16.radiusAll,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data["title"] ?? '',
                                  style: Style.cormorantGaramondBold(
                                          height: Dimens.d1_3.h,
                                          fontSize: Dimens.d18,
                                          color: Colors.black)
                                      .copyWith(wordSpacing: Dimens.d4),
                                  maxLines: 1,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return AddAffirmationPage(
                                        isFromMyAffirmation: true,
                                        title: data["title"],
                                        isEdit: true,
                                        des: data["des"],
                                      );
                                    },
                                  )).then(
                                    (value) {
                                      setState(() {});
                                      if (value != null && value is bool) {
                                        value
                                            ? affirmationList.clear()
                                            : affirmationDraftList.clear();
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                child: SvgPicture.asset(
                                  ImageConstant.editTools,
                                  height: Dimens.d18,
                                  width: Dimens.d18,
                                  color: ColorConstant.black,

                                ),
                              ),
                              Dimens.d10.spaceWidth,
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    like = !like;
                                  });
                                },
                                child: SvgPicture.asset(
                                  like
                                      ? ImageConstant.likeRedTools
                                      : ImageConstant.likeTools,
                                  height: Dimens.d18,
                                  width: Dimens.d18,
                                  color: like?ColorConstant.deleteRed:ColorConstant.black,
                                ),
                              )
                            ],
                          ),
                          Dimens.d10.spaceHeight,
                          Text(
                            data["des"] ?? '',
                            style: Style.montserratRegular(
                                    height: Dimens.d2,
                                    fontSize: Dimens.d11,
                                    color: Colors.black)
                                .copyWith(wordSpacing: Dimens.d4),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _draftAffirmationListWidget() {
    return ValueListenableBuilder(
      valueListenable: isDraftAdded,
      builder: (context, value, child) => (_isLoadingDraft &&
              pageNumberDrafts == 1)
          ? const SizedBox.shrink()
          : (affirmationDraftList.isNotEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("drafts".tr,
                        style: Style.cormorantGaramondBold(
                          fontSize: Dimens.d20,
                        )),
                    Dimens.d11.spaceHeight,
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data = affirmationDraftList[index];
                        return Slidable(
                          closeOnScroll: true,
                          key: const ValueKey<String>("" ?? ""),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dragDismissible: false,
                            extentRatio: 0.26,
                            children: [
                              Dimens.d20.spaceWidth,
                              GestureDetector(
                                onTap: () {
                                  affirmationDraftList.removeAt(index);
                                  _isSearching =
                                      affirmationDraftList.isNotEmpty;
                                  setState(() {});
                                },
                                child: Container(
                                  width: Dimens.d65,
                                  margin:
                                      EdgeInsets.only(bottom: Dimens.d20.h),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.deleteRed,
                                    borderRadius: Dimens.d16.radiusAll,
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    ImageConstant.icDeleteWhite,
                                    width: Dimens.d24,
                                    height: Dimens.d24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: GestureDetector(onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AffirmationShareScreen(
                                  des: affirmationDraftList[index]["des"],
                                  title: affirmationDraftList[index]["title"],
                                );
                              },
                            ));
                          },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(bottom: Dimens.d16),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d11,
                                  vertical: Dimens.d11),
                              decoration: BoxDecoration(
                                color: ColorConstant.white,
                                borderRadius: Dimens.d16.radiusAll,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: Dimens.d300,
                                        child: Text(
                                          data["title"] ?? '',
                                          style: Style.cormorantGaramondBold(
                                                  height: Dimens.d1_3.h,
                                                  fontSize: Dimens.d18,
                                                  color: Colors.black)
                                              .copyWith(
                                                  wordSpacing: Dimens.d4),
                                          maxLines: 7,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return AddAffirmationPage(
                                                isFromMyAffirmation: true,
                                                title: data["title"],
                                                isEdit: true,
                                                des: data["des"],
                                              );
                                            },
                                          )).then(
                                            (value) {
                                              setState(() {});
                                              if (value != null &&
                                                  value is bool) {
                                                value
                                                    ? affirmationList.clear()
                                                    : affirmationDraftList
                                                        .clear();
                                                setState(() {});
                                              }
                                            },
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          ImageConstant.editTools,
                                          height: Dimens.d18,
                                          width: Dimens.d18,
                                          color: ColorConstant.black,

                                        ),
                                      )
                                    ],
                                  ),
                                  Dimens.d10.spaceHeight,
                                  Text(
                                    data["des"] ?? '',
                                    style: Style.montserratRegular(
                                            height: Dimens.d2,
                                            fontSize: Dimens.d11,
                                            color: Colors.black)
                                        .copyWith(wordSpacing: Dimens.d4),
                                    maxLines: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Dimens.d16.spaceWidth,
                      itemCount: affirmationDraftList.length,
                    ),
                  ],
                )
              : const Offstage(),
    );
  }

  Widget transformAffirmationWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              "transformYourMindAffirmation".tr,
              textAlign: TextAlign.center,
              style: Style.montserratRegular(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
            ),
            LayoutContainer(
              horizontal: 0,
              child: Row(
                children: [
                  _buildCategoryDropDown(context),
                  Dimens.d10.spaceWidth,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstant.colorBFD0D4.withOpacity(0.5),
                            // Shadow color with transparency
                            blurRadius: 8.0,
                            // Blur the shadow for a smoother effect
                            spreadRadius: 0.5, // Spread the shadow slightly
                          ),
                        ],
                      ),
                      child: CommonTextField(
                        hintText: "search".tr,
                        controller: searchController,
                        focusNode: searchFocus,
                        prefixLottieIcon: ImageConstant.lottieSearch,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          setState(() {
                            _filteredBookmarks =
                                searchBookmarks(value, listOfBookmarks);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: _filteredBookmarks != null
                  ? ListView.builder(
                      itemCount: _filteredBookmarks?.length ?? 0,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AffirmationShareScreen(
                                  des: _filteredBookmarks?[index]["des"],
                                  title: _filteredBookmarks?[index]["title"],
                                );
                              },
                            ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: Dimens.d16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.d11, vertical: Dimens.d11),
                            decoration: BoxDecoration(
                              color: ColorConstant.white,
                              borderRadius: Dimens.d16.radiusAll,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _filteredBookmarks?[index]["title"] ??
                                            '',
                                        style: Style.cormorantGaramondBold(
                                                height: Dimens.d1_3.h,
                                                fontSize: Dimens.d18,
                                                color: Colors.black)
                                            .copyWith(wordSpacing: Dimens.d4),
                                        maxLines: 1,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          like = !like;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        like
                                            ? ImageConstant.likeRedTools
                                            : ImageConstant.likeTools,
                                        height: Dimens.d18,
                                        width: Dimens.d18,
                                        color: like?ColorConstant.deleteRed:ColorConstant.black,
                                      ),
                                    )
                                  ],
                                ),
                                Dimens.d10.spaceHeight,
                                Text(
                                  _filteredBookmarks?[index]["des"] ?? '',
                                  style: Style.montserratRegular(
                                          height: Dimens.d2,
                                          fontSize: Dimens.d11,
                                          color: Colors.black)
                                      .copyWith(wordSpacing: Dimens.d4),
                                  maxLines: 4,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: listOfBookmarks.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AffirmationShareScreen(
                                  des: listOfBookmarks[index]["des"],
                                  title: listOfBookmarks[index]["title"],
                                );
                              },
                            ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: Dimens.d16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.d11, vertical: Dimens.d11),
                            decoration: BoxDecoration(
                              color: ColorConstant.color3D5459,
                              borderRadius: Dimens.d16.radiusAll,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        listOfBookmarks[index]["title"] ?? '',
                                        style: Style.cormorantGaramondBold(
                                                height: Dimens.d1_3.h,
                                                fontSize: Dimens.d18,
                                                color: Colors.white)
                                            .copyWith(wordSpacing: Dimens.d4),
                                        maxLines: 1,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          like = !like;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        like
                                            ? ImageConstant.likeRedTools
                                            : ImageConstant.likeTools,
                                        height: Dimens.d18,
                                        width: Dimens.d18,
                                      ),
                                    )
                                  ],
                                ),
                                Dimens.d10.spaceHeight,
                                Text(
                                  listOfBookmarks[index]["des"] ?? '',
                                  style: Style.montserratRegular(
                                          height: Dimens.d2,
                                          fontSize: Dimens.d11,
                                          color: Colors.white)
                                      .copyWith(wordSpacing: Dimens.d4),
                                  maxLines: 4,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropDown(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstant.lightGrey),
          borderRadius: BorderRadius.circular(30),
          color: ColorConstant.themeColor,
        ),
        child: DropdownButton(
          value: selectedCategory.value,
          borderRadius: BorderRadius.circular(30),
          onChanged: (value) {
            {
              setState(() {
                selectedCategory.value = value;
              });
            }
          },
          selectedItemBuilder: (_) {
            return categoryList.map<Widget>((item) {
              bool isSelected =
                  selectedCategory.value?["title"] == item["title"];
              return Padding(
                padding: const EdgeInsets.only(left: 18, top: 17),
                child: Text(
                  item["title"] ?? '',
                  style: Style.montserratRegular(
                    fontSize: Dimens.d14,
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              );
            }).toList();
          },
          style: Style.montserratRegular(
            fontSize: Dimens.d14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          hint: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "selectCategory".tr,
              style: Style.montserratRegular(
                  fontSize: Dimens.d14, color: Colors.white),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SvgPicture.asset(
              ImageConstant.icDownArrow,
              height: 20,
              color: Colors.white,
            ),
          ),
          elevation: 16,
          itemHeight: 50,
          menuMaxHeight: 350.h,
          underline: const SizedBox(
            height: 0,
          ),
          isExpanded: true,
          dropdownColor: ColorConstant.colorECF1F3,
          items: categoryList.map<DropdownMenuItem>((item) {
            bool isSelected = selectedCategory.value?["title"] == item["title"];
            return DropdownMenuItem(
              value: item,
              child: AnimatedBuilder(
                animation: selectedCategory,
                builder: (BuildContext context, Widget? child) {
                  return child!;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    item["title"] ?? '',
                    style: Style.montserratRegular(
                      fontSize: Dimens.d14,
                      color: ColorConstant.textGreyColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _refreshCleanseList(bool isSaved) {
    pageNumber = 1;
    affirmationList.clear();

    pageNumberDrafts = 1;
    affirmationDraftList.clear();
  }

  void _fetchInitialRecords() {
    pageNumber = 1;
  }

  void addUserAffirmation({bool isSave = true}) {
    if (_userAffirmationController.text.trim().isEmpty) {
      showSnackBarError(context, "pleaseEnterYourOwnAffirmation".tr);
      return;
    }

    _userAffirmationController.clear();
    _userAffirmationFocus.unfocus();
  }

  void onEditAffirmation(
    BuildContext context, {
    bool isFromDraft = false,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          insetPadding: Dimens.d20.paddingAll,
          child: Container(
            padding: Dimens.d20.paddingAll,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Dimens.d16.radiusAll,
            ),
            child: EditAffirmationDialogWidget(
              onDraftTap: (newRitualText) {
                Navigator.of(context).pop();
                _updateUserAffirmation(
                  newRitualText.trim(),
                  "wfd",
                  isSaved: false,
                );
              },
              onSaveTap: (newRitualText) {
                Navigator.of(context).pop();
                _updateUserAffirmation(
                  newRitualText.trim(),
                  "",
                  isSaved: true,
                );
              },
              onDeleteTap: () {
                Navigator.of(context).pop();
                showAppConfirmationDialog(
                  context: context,
                  message: "yourSelectedAffirmationHasBeenDelete".tr,
                  primaryBtnTitle: "no".tr,
                  secondaryBtnTitle: "yes".tr,
                  secondaryBtnAction: () {
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _updateUserAffirmation(
    String affirmationTitle,
    String affirmationId, {
    bool isSaved = false,
  }) {
    if (affirmationTitle.trim().isEmpty) {
      showSnackBarError(context, "pleaseEnterYourOwnAffirmation".tr);
      return;
    }
  }
}
