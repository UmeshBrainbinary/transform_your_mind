import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/app_common_dialog.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/explore_screen/explore_controller.dart';
import 'package:transform_your_mind/presentation/explore_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/explore_screen/widget/home_app_bar.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/custom_image_view.dart';

class TransformPodsScreen extends StatefulWidget {
  const TransformPodsScreen({super.key});

  @override
  State<TransformPodsScreen> createState() => _TransformPodsScreenState();
}

class _TransformPodsScreenState extends State<TransformPodsScreen>
    with TickerProviderStateMixin {
  bool ratingView = false;
  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  late AnimationController _controller;
  int ritualAddedCount = 0;
  late ScrollController scrollController = ScrollController();
  final ExploreController exploreController = Get.put(ExploreController());
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  List? _filteredBookmarks;
  ValueNotifier selectedCategory = ValueNotifier(null);
  List categoryList = [
    {"title": "Self-Esteem"},
    {"title": "Health"},
    {"title": "Sleep"},
    {"title": "Self Love"},
    {"title": "Hobbies"},
  ];

  @override
  void initState() {


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    isTutorialVideoVisible.value = (ritualAddedCount < 3);
    if (isTutorialVideoVisible.value) {
      _controller.forward();
    }
    super.initState();
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
      appBar: CustomAppBar(title: "transformPods".tr,showBack: true,),
        body: Padding(
      padding: const EdgeInsets.only( right: 20.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         /* HomeAppBar(
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
          ),*/
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
                          _filteredBookmarks = searchBookmarks(
                              value, exploreController.exploreList);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Dimens.d10.spaceHeight,
          Expanded(
              child: _filteredBookmarks != null
                  ? GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: Dimens.d20),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.71,
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: _filteredBookmarks?.length ?? 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _onTileClick(index, context);
                          },
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  CustomImageView(
                                    imagePath: _filteredBookmarks![index]
                                        ['image'],
                                    height: Dimens.d135,
                                    radius: BorderRadius.circular(10),
                                    fit: BoxFit.cover,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, top: 10),
                                      child:
                                          SvgPicture.asset(ImageConstant.play),
                                    ),
                                  )
                                ],
                              ),
                              Dimens.d10.spaceHeight,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Meditation",
                                    style: Style.montserratMedium(
                                      fontSize: Dimens.d12,
                                    ),
                                  ),
                                  const CircleAvatar(
                                    radius: 2,
                                    backgroundColor: ColorConstant.colorD9D9D9,
                                  ),
                                  Text(
                                    "12:00" ?? '',
                                    style: Style.montserratMedium(
                                      fontSize: Dimens.d12,
                                    ),
                                  ),
                                  SvgPicture.asset(ImageConstant.downloadCircle,
                                      height: Dimens.d25, width: Dimens.d25)
                                ],
                              ),
                              Dimens.d7.spaceHeight,
                              Text(
                                _filteredBookmarks![index]['title'],
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
                        childAspectRatio: 0.71,
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: exploreController.exploreList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _onTileClick(index, context);
                          },
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  CustomImageView(
                                    imagePath: exploreController
                                        .exploreList[index]['image'],
                                    height: Dimens.d135,
                                    radius: BorderRadius.circular(10),
                                    fit: BoxFit.cover,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, top: 10),
                                      child:
                                          SvgPicture.asset(ImageConstant.play),
                                    ),
                                  )
                                ],
                              ),
                              Dimens.d10.spaceHeight,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Meditation",
                                    style: Style.montserratMedium(
                                      fontSize: Dimens.d12,
                                    ),
                                  ),
                                  const CircleAvatar(
                                    radius: 2,
                                    backgroundColor: ColorConstant.colorD9D9D9,
                                  ),
                                  Text(
                                    "12:00" ?? '',
                                    style: Style.montserratMedium(
                                      fontSize: Dimens.d12,
                                    ),
                                  ),
                                  SvgPicture.asset(ImageConstant.downloadCircle,
                                      height: Dimens.d25, width: Dimens.d25)
                                ],
                              ),
                              Dimens.d7.spaceHeight,
                              Text(
                                exploreController.exploreList[index]['title'],
                                maxLines: Dimens.d2.toInt(),
                                style: Style.montserratMedium(
                                    fontSize: Dimens.d14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      })),
        ],
      ),
    ));
  }

  void _onTileClick(int index, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Dimens.d24,
          ),
        ),
      ),
      builder: (BuildContext context) {
        return NowPlayingScreen();
      },
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
