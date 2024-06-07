import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/explore_screen/widget/home_app_bar.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';

bool isRitualUpdated = false;
bool isRitualShowPlayer = false;

class RitualsPage extends StatefulWidget {
  final int? ritualPage;

  const RitualsPage({Key? key, this.ritualPage = 0}) : super(key: key);

  @override
  State<RitualsPage> createState() => _RitualsPageState();
}

class _RitualsPageState extends State<RitualsPage>
    with TickerProviderStateMixin {
  ThemeController themeController = Get.find<ThemeController>();
  int _currentTabIndex = 0;
  final TextEditingController ownRitualsController = TextEditingController();
  final FocusNode ownRitualsFocus = FocusNode();

  List listOfMyRituals = [];
  List<Map<String, dynamic>> quickAccessList = [
    {
      "title": "meditation".tr,
    },
    {
      "title": "sleep".tr,
    },
    {
      "title": "transformPods".tr,
    },
    {
      "title": "journal".tr,
    },
    {
      "title": "journal".tr,
    },
    {
      "title": "journal".tr,
    },
    {
      "title": "journal".tr,
    },
    {
      "title": "journal".tr,
    },
    {
      "title": "journal".tr,
    },
  ];
  bool showLock = false;

  int ritualAddedCount = 0;

  ValueNotifier selectedCategory = ValueNotifier(null);
  List categoryList = [
    {"title": "Self-Esteem"},
    {"title": "Health"},
    {"title": "Sleep"},
    {"title": "Self Love"},
    {"title": "Hobbies"},
  ];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  List userDraftRitualsList = [];
  List? _filteredBookmarks;
  int perPageCount = 100;
  bool ratingView = false;
  int initialRating = 0;
  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    isTutorialVideoVisible.value = (ritualAddedCount < 3);
    if (isTutorialVideoVisible.value) {
      _controller.forward();
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
        body: Padding(
      padding: const EdgeInsets.only(top: 30.0, right: 20.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeAppBar(
            downloadWidget: const SizedBox(),
            downloadShown: true,
            title: "",
            isInfo: false,
            showMeIcon: false,
            ratings: ratingView,
            ratingViewUi: true,
            onRatingTap: () {
              setState(() {
                if (ratingView == true) {
                  ratingView = false;
                } else {
                  ratingView = true;
                }
              });
            },
            onInfoTap: () {
              setState(() {
                ratingView = false;
              });
              isTutorialVideoVisible.value = !isTutorialVideoVisible.value;
              if (isTutorialVideoVisible.value) {
                _controller.forward();
              } else {
                // videoKeys[6].currentState?.pause();
                _controller.reverse();
              }
            },
            back: true,
          ),
          Dimens.d10.spaceHeight,
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
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d14),
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
                      "myRituals".tr,
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
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d34),
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
                      "transformRituals".tr,
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
          //________________________ rituals view _________________
          tabChangeView()
        ],
      ),
    ));
  }

  Widget tabChangeView() {
    return _currentTabIndex == 0 ? myRituals() : transformRituals();
  }

  Widget myRituals() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Dimens.d10.spaceHeight,
            Text("myDrafts".tr,
                style: Style.cormorantGaramondBold(
                  fontSize: Dimens.d20,
                )),
            Dimens.d10.spaceHeight,
            userDraftRitualsList.isNotEmpty
                ? ListView.builder(
                    itemCount: userDraftRitualsList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
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
                                userDraftRitualsList.removeAt(index);
                                setState(() {});
                              },
                              child: Container(
                                width: Dimens.d40,
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          decoration: BoxDecoration(
                            color: ColorConstant.themeColor,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  userDraftRitualsList[index]["title"],
                                  maxLines: 3,
                                  style: Style.montserratRegular(
                                      fontSize: Dimens.d14,
                                      color: ColorConstant.white),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child:
                                      SvgPicture.asset(ImageConstant.editTools))
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No Data",
                      style: Style.montserratRegular(
                          fontSize: Dimens.d14,
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black),
                    ),
                  ),
            Dimens.d10.spaceHeight,
            Text("myRituals".tr,
                style: Style.cormorantGaramondBold(
                  fontSize: Dimens.d20,
                )),
            Dimens.d10.spaceHeight,
            listOfMyRituals.isNotEmpty
                ? ListView.builder(
                    itemCount: listOfMyRituals.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
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
                                listOfMyRituals.removeAt(index);
                                setState(() {});
                              },
                              child: Container(
                                width: Dimens.d40,
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          decoration: BoxDecoration(
                            color: ColorConstant.themeColor,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  listOfMyRituals[index]["title"],
                                  maxLines: 3,
                                  style: Style.montserratRegular(
                                      fontSize: Dimens.d14,
                                      color: ColorConstant.white),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child:
                                      SvgPicture.asset(ImageConstant.editTools))
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No Data",
                      style: Style.montserratRegular(
                          fontSize: Dimens.d14,
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget transformRituals() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Dimens.d15.spaceHeight,
            Text(
                "Add your rituals to unleash your inner champion & conquer your day!",
                textAlign: TextAlign.center,
                style: Style.cormorantGaramondBold(fontSize: Dimens.d18)),
            Dimens.d15.spaceHeight,
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
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
                hintText: "writeYourOwnRitual".tr,
                controller: ownRitualsController,
                focusNode: ownRitualsFocus,
                prefixLottieIcon: ImageConstant.lottieSearch,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Dimens.d20.spaceHeight,
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (ownRitualsController.text.isNotEmpty) {
                      userDraftRitualsList
                          .add({"title": ownRitualsController.text});
                      setState(() {
                        ownRitualsController.clear();
                      });
                    } else {
                      showSnackBarError(
                          context, "pleaseWriteYourOwnRituals".tr);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            color: themeController.isDarkMode.value
                                ? ColorConstant.white.withOpacity(0.5)
                                : ColorConstant.black.withOpacity(0.5))),
                    child: Text(
                      "drafts".tr,
                      style: Style.montserratRegular(
                          fontSize: Dimens.d18,
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (ownRitualsController.text.isNotEmpty) {
                      listOfMyRituals.add({"title": ownRitualsController.text});
                      setState(() {
                        ownRitualsController.clear();
                      });
                    } else {
                      showSnackBarError(
                          context, "pleaseWriteYourOwnRituals".tr);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: ColorConstant.themeColor),
                    child: Text(
                      "save".tr,
                      style: Style.montserratRegular(
                          fontSize: Dimens.d18, color: ColorConstant.white),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            Dimens.d10.spaceHeight,
            Text("Explore Transform Rituals",
                textAlign: TextAlign.center,
                style: Style.cormorantGaramondBold(fontSize: Dimens.d18)),
            Dimens.d10.spaceHeight,
            LayoutContainer(
              horizontal: 0,
              child: Row(
                children: [
                  _buildCategoryDropDown(context),
                  Dimens.d10.spaceWidth,
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
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
                        focusNode: searchFocusNode,
                        prefixLottieIcon: ImageConstant.lottieSearch,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          setState(() {
                            _filteredBookmarks =
                                searchBookmarks(value, quickAccessList);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // 3 items per row
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20 // Set the aspect ratio as needed
                    ),
                itemCount: quickAccessList.length,
                // Total number of items
                itemBuilder: (BuildContext context, int index) {
                  // Generating items for the GridView
                  return GestureDetector(
                    onTap: () {
                      listOfMyRituals
                          .add({"title": quickAccessList[index]["title"]});
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: themeController.isDarkMode.value
                              ? ColorConstant.textfieldFillColor
                              : ColorConstant.themeColor),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Listen to a podcast",
                                  // Displaying item index
                                  style: Style.montserratRegular(
                                      fontSize: 12, color: ColorConstant.white),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                                onTap: () {
                                  listOfMyRituals.add({
                                    "title": quickAccessList[index]["title"]
                                  });
                                  setState(() {});
                                },
                                child: SvgPicture.asset(
                                  ImageConstant.icEmoji,
                                  height: 25,
                                  width: 25,
                                )),
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
}
