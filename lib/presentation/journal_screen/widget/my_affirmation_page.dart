import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:transform_your_mind/core/common_widget/affirmation_draft.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/bookmark_shimmer.dart';
import 'package:transform_your_mind/core/common_widget/category_drop_down.dart';
import 'package:transform_your_mind/core/common_widget/custom_tab_bar.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/lottie_icon_button.dart';
import 'package:transform_your_mind/core/common_widget/no_data_available.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/common_widget/tab_text.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/edit_affirmation_dialog_widget.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_list_tile_layout.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_shimmer_widget.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/app_confirmation_dialog.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

List affirmationList = [];
List affirmationDraftList = [];

class MyAffirmationPage extends StatefulWidget {
  const MyAffirmationPage({Key? key}) : super(key: key);

  @override
  State<MyAffirmationPage> createState() => _MyAffirmationPageState();
}

class _MyAffirmationPageState extends State<MyAffirmationPage>
    with SingleTickerProviderStateMixin {
  List listOfBookmarks = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _bookrefreshController =
      RefreshController(initialRefresh: false);
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

  late TabController _tabController;
  int _currentTabIndex = Dimens.d0.toInt();
  ValueNotifier<bool> isDraftAdded = ValueNotifier(false);

  List categoryList = [];

  final TextEditingController _userAffirmationController =
      TextEditingController();
  final FocusNode _userAffirmationFocus = FocusNode();
  int perPageCount = 100;
  ValueNotifier selectedCategory = ValueNotifier(null);


  @override
  void initState() {
    super.initState();

    /*  bookmarkBloc.add(
      GetMyBookmarksEvent(
        paginationRequest: PaginationRequest(
          page: pageNumber,
          perPage: perPageCount,
          contentType: AppContentType.affirmation.value,
        ),
      ),
    );
    _affirmationBloc.add(
      GetMyAffirmationEvent(
        paginationRequest: PaginationRequest(
          page: pageNumberAf,
          perPage: perPageCount,
          isSaved: true,
        ),
      ),
    );

    _affirmationBloc.add(
      GetMyAffirmationEvent(
        paginationRequest: PaginationRequest(
          page: pageNumberDrafts,
          perPage: perPageCount,
          isSaved: false,
        ),
      ),
    );*/

    // _affirmationBloc.add(GetMyAffirmationDarftEvent(pageNumber: pageNumberDrafts));
    _tabController = TabController(length: Dimens.d2.toInt(), vsync: this);

    /// Fetch categories for affirmation
    /*   categoryBloc.add(
      FetchCategories(contentId: AppContentType.affirmation.value),
    );*/
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
          return const AddAffirmationPage(isFromMyAffirmation: true);
        },
      )).then(
        (value) {
          setState(() {});
          if (value != null && value is bool) {
            value ? affirmationList.clear() : affirmationDraftList.clear();
            setState(() {});
            /*     _affirmationBloc.add(
            GetMyAffirmationEvent(
              paginationRequest: PaginationRequest(
                page: 1,
                perPage: perPageCount,
                isSaved: value,
                searchKey: value
                    ? searchController.text.isNotEmpty
                        ? searchController.text
                        : null
                    : null,
              ),
            ),
          );*/
          }
        },
      );
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _isSearching = true;
      pageNumber = 1;

      if (query.isNotEmpty) {
        query.trim();
        if (!RegExp(r'[^\w\s]').hasMatch(query) && query.isNotEmpty) {
          /* _affirmationBloc.add(
            GetMyAffirmationEvent(
              paginationRequest: PaginationRequest(
                page: pageNumber,
                perPage: perPageCount,
                isSaved: true,
                searchKey: query,
              ),
              isSearchQuery: true,
            ),
          );*/
        }
      } else {
        /*     _affirmationBloc.add(
          GetMyAffirmationEvent(
            paginationRequest: PaginationRequest(
              page: pageNumber,
              perPage: perPageCount,
              isSaved: true,
            ),
            isSearchQuery: true,
          ),
        );*/
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: themeController.isDarkMode.value ? ColorConstant.black : ColorConstant.backGround,
      appBar: CustomAppBar(showBack: true,
        title: "myAffirmation".tr,
        action: (_isLoading || _isLoadingDraft)
            ? const Offstage()
            : LottieIconButton(
                icon: ImageConstant.lottieNavAdd,
                iconHeight: 35,
                iconWidth: 35,
                repeat: true,
                onTap: () => _onAddClick(context),
              ),
      ),
      body: Stack(
        children: [
          BackGroundContainer(
            image: ImageConstant.homeBgBookmarks,
            isLeft: true,
            top: Dimens.d251,
            height: Dimens.d289,
          ),
          LayoutContainer(
            vertical: 0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CustomTabBar(
                    bgColor: ColorConstant.themeColor.withOpacity(Dimens.d0_1),
                    padding: Dimens.d12.paddingHorizontal,
                    labelPadding: Dimens.d12.paddingHorizontal,
                    tabBarIndicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                    listOfItems: [
                      TabText(
                        text: "yourAffirmation".tr,
                        value: Dimens.d0,
                        selectedIndex: _currentTabIndex.toDouble(),
                        padding: Dimens.d15.paddingAll,
                        textHeight: Dimens.d1_2,
                        fontSize: Dimens.d14,
                      ),
                      TabText(
                        text: "affirmations".tr,
                        value: Dimens.d1,
                        selectedIndex: _currentTabIndex.toDouble(),
                        padding: Dimens.d15.paddingAll,
                        textHeight: Dimens.d1_2,
                        fontSize: Dimens.d14,
                      ),
                    ],
                    tabController: _tabController,
                    onTapCallBack: (value) {
                      if (_currentTabIndex == value) {
                        return;
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                      // searchController.text = '';
                      _currentTabIndex = value;
                      setState(() {});
                    },
                    unSelectedLabelColor: ColorConstant.textGreyColor,
                  ),
                ),
                Dimens.d20.spaceHeight,
                _getTabListOfGoals(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTabListOfGoals() {
    if (_currentTabIndex == 0) {
      return yourAffirmationWidget();
    } else {
      return shoorahAffirmationWidget();
    }
  }

  Widget yourAffirmationWidget() {
    return /*pageNumberAf == 1 &&
        !_isSearching
        ? const JournalListShimmer()
        : affirmationList.isNotEmpty || affirmationDraftList.isNotEmpty
        ?*/
        Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ///draft part
            _draftAffirmationListWidget(),
            Dimens.d20.spaceHeight,
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "myAffirmation".tr,
                style: Style.montserratRegular(
                  fontSize: Dimens.d18,
                ).copyWith(
                  letterSpacing: Dimens.d0_16,
                ),
              ),
            ),
            Dimens.d20.spaceHeight,
            ListView.builder(
              itemCount: affirmationList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final data = affirmationList[index];
                return GestureDetector(
                  onTap: () {
                    /* Navigator.pushNamed(
                                    context,
                                    HomeMessagePage.homeMessagePage,
                                    arguments: {
                                      AppConstants.affirmationData:
                                          TodayAffirmationData(
                                              displayName:
                                                  affirmationList[index].title,
                                              id: affirmationList[index]
                                                  .affirmationId,
                                              isBookMarked: true)
                                    },
                                  ).then((value) {
                                    bool saved = (value as bool? ?? true);
                                    if (!saved) {
                                      listOfBookmarks.removeAt(index);
                                      bookmarkBloc.add(RefreshBookmarksEvent());
                                    }
                                  });*/
                  },
                  child: true
                      ? Slidable(
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
                                  /*      _affirmationBloc.add(
                                                  DeleteAffirmationEvent(
                                                      deleteAffirmationRequest:
                                                          DeleteAffirmationRequest(
                                                              affirmationId:
                                                                  data.affirmationId ??
                                                                      ""),
                                                      isFromDraft: false),
                                                );*/
                                  affirmationList.removeAt(index);
                                  _isSearching = affirmationList.isNotEmpty;
                                  setState(() {});
                                  /*_affirmationBloc.add(
                                                    RefreshAffirmationEvent());*/
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
                          child: Container(
                            margin: const EdgeInsets.only(bottom: Dimens.d16),
                            padding: const EdgeInsets.all(Dimens.d24),
                            decoration: BoxDecoration(
                              color: ColorConstant.themeColor.withOpacity(0.8),
                              borderRadius: Dimens.d16.radiusAll,
                              image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                  index.isEven
                                      ? ColorConstant.themeColor
                                          .withOpacity(0.8)
                                      : ColorConstant.themeColor,
                                  BlendMode.color,
                                ),
                                image: AssetImage(
                                  index.isEven
                                      ? ImageConstant.imgAffirmationTileBg1
                                      : ImageConstant.imgAffirmationTileBg2,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    data["title"] ?? '',
                                    style: Style.montserratRegular(
                                            height: Dimens.d1_3.h,
                                            fontSize: Dimens.d18,
                                            color: Colors.white)
                                        .copyWith(wordSpacing: Dimens.d4),
                                    maxLines: 7,
                                  ),
                                ),
                                Dimens.d24.spaceWidth,
                                Column(
                                  children: [
                                    Lottie.asset(
                                      ImageConstant.lottieRightArrowWhite,
                                      height: Dimens.d24,
                                      width: Dimens.d24,
                                      fit: BoxFit.cover,
                                      repeat: false,
                                    ),
                                    Dimens.d10.spaceHeight,
                                    InkWell(
                                      borderRadius: Dimens.d25.radiusAll,
                                      onTap: () => onEditAffirmation(
                                        context,
                                      ),
                                      child: SvgPicture.asset(
                                        ImageConstant.icPencil,
                                        color: Colors.white,
                                        height: Dimens.d16,
                                        width: Dimens.d16,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Slidable(
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
                                  /*      _affirmationBloc.add(
                                                  DeleteAffirmationEvent(
                                                      deleteAffirmationRequest:
                                                          DeleteAffirmationRequest(
                                                              affirmationId:
                                                                  data.affirmationId ??
                                                                      ""),
                                                      isFromDraft: false),
                                                );*/
                                  affirmationList.removeAt(index);
                                  _isSearching = affirmationList.isNotEmpty;
                                  setState(() {});
                                  /*_affirmationBloc.add(
                                                    RefreshAffirmationEvent());*/
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
                          child: JournalListTileLayout(
                            margin: EdgeInsets.only(bottom: Dimens.d20.h),
                            title: data["title"] ?? '',
                            image: data["image"] ?? '',
                            createdDate: data["createdOn"] ?? '',
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    )
        /*: const NoDataAvailable(
      showBottomHeight: false,
      message: "Affirmation No Data",
      horizontalPadding: 0,
    )*/
        ;
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
                    Text(
                      "drafts".tr,
                      style: Style.montserratRegular(
                        fontSize: Dimens.d18,
                      ).copyWith(
                        letterSpacing: Dimens.d0_16,
                      ),
                    ),
                    Dimens.d20.spaceHeight,
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data = affirmationDraftList[index];
                        return GestureDetector(
                          onTap: () {
                            /*  Navigator.pushNamed(
                    context,
                    HomeMessagePage.homeMessagePage,
                    arguments: {
                      AppConstants.affirmationData:
                      TodayAffirmationData(
                          displayName:
                          affirmationList[index].title,
                          id: affirmationList[index]
                              .affirmationId,
                          isBookMarked: true)
                    },
                  ).then((value) {
                    bool saved = (value as bool? ?? true);
                    if (!saved) {
                      listOfBookmarks.removeAt(index);
                      bookmarkBloc.add(RefreshBookmarksEvent());
                    }
                  });*/
                          },
                          child: true
                              ? Slidable(
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
                                          /*      _affirmationBloc.add(
                                                  DeleteAffirmationEvent(
                                                      deleteAffirmationRequest:
                                                          DeleteAffirmationRequest(
                                                              affirmationId:
                                                                  data.affirmationId ??
                                                                      ""),
                                                      isFromDraft: false),
                                                );*/
                                          affirmationDraftList.removeAt(index);
                                          _isSearching =
                                              affirmationDraftList.isNotEmpty;
                                          setState(() {});
                                          /*_affirmationBloc.add(
                                                    RefreshAffirmationEvent());*/
                                        },
                                        child: Container(
                                          width: Dimens.d65,
                                          margin: EdgeInsets.only(
                                              bottom: Dimens.d20.h),
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
                                    margin: const EdgeInsets.only(
                                        bottom: Dimens.d16),
                                    padding: const EdgeInsets.all(Dimens.d24),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.colorThemed8,
                                      borderRadius: Dimens.d16.radiusAll,
                                      image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                          index.isEven
                                              ? ColorConstant.colorThemed8
                                              : ColorConstant.themeColor,
                                          BlendMode.color,
                                        ),
                                        image: AssetImage(
                                          index.isEven
                                              ? ImageConstant
                                                  .imgAffirmationTileBg1
                                              : ImageConstant
                                                  .imgAffirmationTileBg2,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            data["title"] ?? '',
                                            style: Style.montserratRegular(
                                                    height: Dimens.d1_3.h,
                                                    fontSize: Dimens.d18,
                                                    color: Colors.white)
                                                .copyWith(
                                                    wordSpacing: Dimens.d4),
                                            maxLines: 7,
                                          ),
                                        ),
                                        Dimens.d24.spaceWidth,
                                        Column(
                                          children: [
                                            Lottie.asset(
                                              ImageConstant
                                                  .lottieRightArrowWhite,
                                              height: Dimens.d24,
                                              width: Dimens.d24,
                                              fit: BoxFit.cover,
                                              repeat: false,
                                            ),
                                            Dimens.d10.spaceHeight,
                                            InkWell(
                                              borderRadius:
                                                  Dimens.d25.radiusAll,
                                              onTap: () => onEditAffirmation(
                                                context,
                                                isFromDraft: true,
                                              ),
                                              child: SvgPicture.asset(
                                                ImageConstant.icPencil,
                                                color: Colors.white,
                                                height: Dimens.d16,
                                                width: Dimens.d16,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : AffirmationDraftListItem(
                                  index: index,
                                  listOfAffirmationDraftsResponse:
                                      affirmationDraftList,
                                  onDeleteTapCallback: () {
                                    /*      _affirmationBloc.add(
                          DeleteAffirmationEvent(
                              deleteAffirmationRequest:
                              DeleteAffirmationRequest(
                                  affirmationId:
                                  affirmationDraftList[
                                  index]
                                      .affirmationId),
                              isFromDraft: true));
                      affirmationDraftList.removeAt(index);
                      _affirmationBloc
                          .add(RefreshAffirmationEvent());*/
                                  }),
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

  Widget shoorahAffirmationWidget() {
    return /* pageNumber == 1
        ? const JournalListAffirmationShimmer()
        : listOfBookmarks.isNotEmpty
        ? */
        Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Dimens.d10.spaceHeight,
                AutoSizeText(
                  "affirmationHeader".tr,
                  textAlign: TextAlign.center,
                  style: Style.montserratRegular(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                ),
                Dimens.d20.spaceHeight,
                CommonTextField(
                  hintText: "enterYourOwnAffirmation".tr,
                  controller: _userAffirmationController,
                  focusNode: _userAffirmationFocus,
                  textInputAction: TextInputAction.done,
                ),
                LayoutContainer(
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonElevatedButton(
                          title: "draft".tr,
                          outLined: true,
                          textStyle: Style.montserratRegular(
                              color: ColorConstant.textDarkBlue),
                          onTap: () => addUserAffirmation(isSave: false),
                        ),
                      ),
                      Dimens.d20.spaceWidth,
                      Expanded(
                        child: CommonElevatedButton(
                          title: "save".tr,
                          onTap: () => addUserAffirmation(),
                        ),
                      ),
                    ],
                  ),
                ),
                AutoSizeText(
                  "exploreTransformAffirmations".tr,
                  textAlign: TextAlign.center,
                  style: Style.montserratRegular(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            LayoutContainer(
              horizontal: 0,
              child: Row(
                children: [
                  _buildCategoryDropDown(context),
                  Dimens.d10.spaceWidth,
                  Expanded(
                    child: CommonTextField(
                      hintText: "search".tr,
                      controller: searchController,
                      focusNode: searchFocus,
                      prefixLottieIcon: ImageConstant.lottieSearch,
                      textInputAction: TextInputAction.done,
                      onChanged: _onSearchChanged,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ListView.builder(
                itemCount: listOfBookmarks.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  final bookMarkAffirmationData = listOfBookmarks[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: Dimens.d16),
                    padding: const EdgeInsets.all(Dimens.d24),
                    decoration: BoxDecoration(
                      color: ColorConstant.themeColor.withOpacity(0.8),
                      borderRadius: Dimens.d16.radiusAll,
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                          index.isEven
                              ? ColorConstant.themeColor.withOpacity(0.8)
                              : ColorConstant.themeColor,
                          BlendMode.color,
                        ),
                        image: AssetImage(
                          index.isEven
                              ? ImageConstant.imgAffirmationTileBg1
                              : ImageConstant.imgAffirmationTileBg2,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            bookMarkAffirmationData.contentName ?? '',
                            style: Style.montserratRegular(
                                    height: Dimens.d1_3.h,
                                    fontSize: Dimens.d18,
                                    color: Colors.white)
                                .copyWith(wordSpacing: Dimens.d4),
                            maxLines: 7,
                          ),
                        ),
                        Dimens.d24.spaceWidth,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Lottie.asset(
                              ImageConstant.lottieRightArrowWhite,
                              height: Dimens.d24,
                              width: Dimens.d24,
                              fit: BoxFit.cover,
                              repeat: false,
                            ),
                            GestureDetector(
                              onTap: () {
                                /*   bookmarkBloc.add(
                                                AddMyBookmarkEvent(
                                                  addBookmarkRequest:
                                                      AddBookmarkRequest(
                                                    contentType: 2,
                                                    contentId:
                                                        bookMarkAffirmationData
                                                            .bookmarkId,
                                                  ),
                                                ),
                                              );*/

                                listOfBookmarks.removeAt(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  ImageConstant.icEmoji,
                                  height: Dimens.d20,
                                  width: Dimens.d20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    )
        /* : const NoDataAvailable(
      showBottomHeight: false,
      message:"Have you considered saving affirmations that resonate with you, so you can revisit them whenever you need a boost of positivity?",
      horizontalPadding: 0,
    )*/
        ;
  }

  Widget _buildCategoryDropDown(BuildContext context) {
    return Expanded(
      child: CategoryDropDown(
        key: UniqueKey(),
        categoryList: List.from(categoryList),
        selectedCategory: selectedCategory,
        onSelected: () {
          if (selectedCategory.value == null) {
            _fetchInitialRecords();
          } else {
            pageNumber = 1;
          }
        },
      ),
    );
  }

  void _refreshCleanseList(bool isSaved) {
    pageNumber = 1;
    affirmationList.clear();
/*    _affirmationBloc.add(
      GetMyAffirmationEvent(
        paginationRequest: PaginationRequest(
          page: pageNumberAf,
          perPage: perPageCount,
          isSaved: true,
          searchKey: isSaved
              ? searchController.text.isNotEmpty
                  ? searchController.text
                  : null
              : null,
        ),
      ),
    );*/
    pageNumberDrafts = 1;
    affirmationDraftList.clear();
/*    _affirmationBloc.add(
      GetMyAffirmationEvent(
        paginationRequest: PaginationRequest(
          page: pageNumberDrafts,
          perPage: perPageCount,
          isSaved: false,
          searchKey: isSaved
              ? searchController.text.isNotEmpty
                  ? searchController.text
                  : null
              : null,
        ),
      ),
    );*/
  }

  void _fetchInitialRecords() {
    pageNumber = 1;
/*    _affirmationBloc.add(
      GetMyAffirmationEvent(
        paginationRequest: PaginationRequest(
          page: pageNumberDrafts,
          perPage: perPageCount,
          isSaved: false,
        ),
      ),
    );*/

    /// to fetch saved affirmations
/*    _affirmationBloc.add(
      GetMyAffirmationEvent(
        paginationRequest: PaginationRequest(
          page: pageNumberDrafts,
          perPage: perPageCount,
          isSaved: true,
        ),
      ),
    );*/
  }

  void addUserAffirmation({bool isSave = true}) {
    if (_userAffirmationController.text.trim().isEmpty) {
      showSnackBarError(context, "pleaseEnterYourOwnAffirmation".tr);
      return;
    }
    /* _affirmationBloc.add(
      AddAffirmationEvent(
        addAffirmationRequest: AddAffirmationRequest(
          title: _userAffirmationController.text.trim(),
          imageUrl: '',
          isSaved: isSave,
        ),
      ),
    );*/
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
                    /*_affirmationBloc.add(
                      DeleteAffirmationEvent(
                        deleteAffirmationRequest: DeleteAffirmationRequest(
                            affirmationId: data.affirmationId),
                        isFromDraft: isFromDraft,
                      ),
                    );*/
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
    /*_affirmationBloc.add(
      AddAffirmationEvent(
        addAffirmationRequest: AddAffirmationRequest(
          affirmationId: affirmationId,
          title: affirmationTitle,
          imageUrl: '',
          isSaved: isSaved,
        ),
      ),
    );*/
  }
}
