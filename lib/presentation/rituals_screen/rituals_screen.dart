import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transform_your_mind/core/common_widget/category_drop_down.dart';
import 'package:transform_your_mind/core/common_widget/custom_tab_bar.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/no_data_available.dart';
import 'package:transform_your_mind/core/common_widget/on_loading_bottom_indicator.dart';
import 'package:transform_your_mind/core/common_widget/ritual_tile.dart';
import 'package:transform_your_mind/core/common_widget/screen_info_widget.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/common_widget/tab_text.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/explore_screen/widget/home_app_bar.dart';
import 'package:transform_your_mind/presentation/rituals_screen/widget/edit_ritual_dialog_widget.dart';
import 'package:transform_your_mind/presentation/rituals_screen/widget/rituals_grid_shimmer_widget.dart';
import 'package:transform_your_mind/presentation/rituals_screen/widget/rituals_shimmer_widget.dart';
import 'package:transform_your_mind/widgets/app_confirmation_dialog.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/divider.dart';



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
  late TabController _tabController;
  final ValueNotifier<double> _currentTabIndex = ValueNotifier(0.0);
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  List listOfRituals = [];
  List listOfMyRituals = [];

  bool _isLoading = false;
  bool _isLoadingMyRituals = false;
  final RefreshController _refreshControllerShoorahRituals =
  RefreshController(initialRefresh: false);
  final RefreshController _refreshControllerMyRituals =
  RefreshController(initialRefresh: false);
  int pageNumber = 1;
  int totalItemCountOfRituals = 0;
  int pageNumberMyRituals = 1;
  int totalItemCountOfMyRituals = 0;
  int itemIndexToRemove = -1;
  Timer? _debounce;
  Timer? _debounceForAdd;
  bool showLock = false;

  int ritualAddedCount = 0;


  /// animated list key

  final GlobalKey<AnimatedListState> _shoorahRitualsListKey =
  GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _myRitualListKey =
  GlobalKey<AnimatedListState>();

  ValueNotifier selectedCategory = ValueNotifier(null);
  List categoryList = [];

  final GlobalKey<AnimatedListState> _userDraftRitualKey =
  GlobalKey<AnimatedListState>();
  final RefreshController _refreshControllerUserRitualDraft =
  RefreshController(initialRefresh: false);
  List userDraftRitualsList = [];
  final TextEditingController _userRitualController = TextEditingController();
  final FocusNode _userRitualFocus = FocusNode();

  int perPageCount = 100;
  bool ratingView = false;
  int initialRating=0;
  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    /// Fetch categories for rituals

    //  var value = SharedPrefUtils.getValue(SharedPrefUtilsKeys.selectedFocusList, '');
    // _filteredFocusIds = value.isNotEmpty ? List<String>.from(jsonDecode(value)) : [];
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.ritualPage ?? 0);
    _currentTabIndex.value = (widget.ritualPage)?.toDouble() ?? 0.0;



    _fetchInitialRecords();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    isTutorialVideoVisible.value = (ritualAddedCount < 3);
    if (isTutorialVideoVisible.value) {
      _controller.forward();
    }

  }

  @override
  void dispose() {
    _refreshControllerShoorahRituals.dispose();
    _refreshControllerMyRituals.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:ValueListenableBuilder(
        valueListenable: _currentTabIndex,
        builder: (context, value, child) {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child!,
                  Dimens.d10.spaceHeight,
                 // welcomeTextTitle(title: "Welcome To Rituals"),
                 // welcomeTextDescriptionTitle(title: i10n.welcomeRitualsDesc),
                  LayoutContainer(
                    vertical: 0,
                    child: Column(
                      children: [
                        CustomTabBar(
                          bgColor: ColorConstant.themeColor
                              .withOpacity(Dimens.d0_1),
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          tabBarIndicatorSize: TabBarIndicatorSize.label,
                          listOfItems: [
                            TabText(
                              text: "myRituals".tr,
                              value: Dimens.d1,
                              selectedIndex: _currentTabIndex.value,
                              padding: Dimens.d15.paddingAll,
                              textHeight: Dimens.d1_2,
                              fontSize: Dimens.d16,
                            ),
                            TabText(
                              text: "transformRituals".tr,
                              value: Dimens.d0,
                              selectedIndex: _currentTabIndex.value,
                              padding: Dimens.d15.paddingAll,
                              textHeight: Dimens.d1_32,
                              fontSize: Dimens.d16,
                            ),
                          ],
                          tabController: _tabController,
                          onTapCallBack: (value) {
                            if (_currentTabIndex.value == value.toDouble()) {
                              return;
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                            _currentTabIndex.value = value.toDouble();
                          },
                          unSelectedLabelColor: ColorConstant.textGreyColor,
                        ),
                      ],
                    ),
                  ),
                  _getTabListOfRituals(),
                ],
              ),
              ratingView
                  ? Padding(
                padding:  EdgeInsets.only(top: Dimens.d110.h),
                child: AddRatingsView(
                  onRatingChanged: (p0) {
                    initialRating = p0;
                   // _exploreBloc.add(AddFeatureRatingEvent( addFeatureRatingRequestModel:
                   // AddFeatureRatingRequestModel(contentType:2 ,rating: p0)));
                  },
                  initialRating: initialRating,
                  screenTitle:"giveYourRating".tr,
                  screenHeading: 'We genuinely value your input and strive to continuously improve our services.',
                  screenDesc: 'Please take a moment to rate your experience with Shoorah Rituals.',
                ),
              )
                  : const SizedBox(),
        /*      (tutorialVideoData?.sId != null)? ratingView
                  ? const SizedBox()
                  :Padding(
                padding:  EdgeInsets.only(top: Dimens.d110.h),
                child: SizedBox(height: Dimens.d210.h,
                  child: ScreenInfoWidget(
                    videoStateKey: videoKeys[5],
                    controller: _controller,
                    isTutorialVideoVisible: isTutorialVideoVisible,
                    tutorialVideoData:
                    tutorialVideoData ?? TutorialVideoData(),
                    screenTitle: "Welcome to Rituals",
                    screenHeading: tutorialVideoData?.heading ?? '',
                    screenDesc: tutorialVideoData?.subHeading ?? '',
                    showVideoIcon: (tutorialVideoData?.videoUrl != null)?true:false,
                    onVideoViewTap: () {
                      SharedPrefUtils.setValue(
                          SharedPrefUtilsKeys.ritualAddedCount, 5);
                    },
                  ),
                ),
              ):const SizedBox(),*/
            ],
          );
        },
        child:Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: HomeAppBar(downloadWidget: const SizedBox(),downloadShown: true,
            title:"",
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
              isTutorialVideoVisible.value =
              !isTutorialVideoVisible.value;
              if (isTutorialVideoVisible.value) {
                _controller.forward();
              } else {
               // videoKeys[6].currentState?.pause();
                _controller.reverse();
              }
            }, back: true,
          ),
        ),
      )
    );
  }

  Widget _getTabListOfRituals() {
    if (_currentTabIndex.value == 0.0) {
      return (_isLoadingMyRituals && pageNumberMyRituals == 1)
          ? const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: RitualsShimmer(),
      )
          : (listOfMyRituals.isNotEmpty || userDraftRitualsList.isNotEmpty)
          ? Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              _getUserRitualsDraft(),
              _getRitualsList(),
            ],
          ),
        ),
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NoDataAvailable(
            message: "addMoreRitualsToDailyRoutine".tr,
            showBottomHeight: false,
          ),
        ],
      );
    } else {
      return (_isLoading && pageNumber == 1)
          ? const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: RitualsGridShimmer(),
      )
          : (listOfRituals.isNotEmpty)
          ? Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Dimens.d10.spaceHeight,
                    AutoSizeText(
                      "addYourOwnRitual".tr,
                      textAlign: TextAlign.center,
                      style: Style.montserratBold(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                    ),
                    Dimens.d20.spaceHeight,
                    CommonTextField(
                      hintText: "writeYourOwnRitual".tr,
                      controller: _userRitualController,
                      focusNode: _userRitualFocus,
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
                              onTap: () =>
                                  _addUserRitual(isSaved: false),
                            ),
                          ),
                          Dimens.d20.spaceWidth,
                          Expanded(
                            child: CommonElevatedButton(
                              title: "save".tr,
                              onTap: () =>
                                  _addUserRitual(isSaved: true),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AutoSizeText(
                      "exploreTransformRituals".tr,
                      textAlign: TextAlign.center,
                      style: Style.montserratBold(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                    Dimens.d20.spaceHeight,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        showMultipleSuffix:
                        searchController.text.isNotEmpty
                            ? true
                            : false,
                        suffixLottieIcon2:
                        searchController.text.isNotEmpty
                            ? ImageConstant.lottieClose
                            : null,
                        suffixTap2: () {
                          searchController.text = '';
                          setState(() {});
                          _onSearchChanged(searchController.text);
                          searchFocus.unfocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Dimens.d20.h.spaceHeight,
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Dimens.d20,
                  ),
                  child: StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function())
                        setState) =>
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.start,
                          children:
                          listOfRituals.mapIndexed((index, data) {
                            return ShoorahRitualTileWidget(
                              data,
                                  () {
                               /* _ritualsBloc.add(
                                  AddMyRitualsEvent(
                                    addMyRitualsRequest:
                                    AddMyRitualsRequest(
                                      ritualIds: [data.id ?? ''],
                                    ),
                                  ),
                                );*/
                                listOfRituals.removeAt(index);
                                if (mounted) setState(() {});
                              },
                            );
                          }).toList(),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NoDataAvailable(
            message: "selectMoreFocusToFindNewRituals".tr,
            showBottomHeight: false,
          ),
          const Spacer()
        ],
      );
    }
  }

  void _refreshMyRitualsList() {
    pageNumberMyRituals = 1;
    listOfMyRituals.clear();
 /*   _ritualsBloc.add(
      GetMyRitualsEvent(
        paginationRequest: PaginationRequest(
          page: pageNumberMyRituals,
          perPage: perPageCount,
          searchKey:
          searchController.text.isNotEmpty ? searchController.text : null,
        ),
      ),
    );*/
  }

  void _refreshShoorahList() {
    pageNumber = 1;
    listOfRituals.clear();
/*    _ritualsBloc.add(
      GetShoorahRitualsEvent(
        paginationRequest: PaginationRequest(
          page: pageNumber,
          perPage: perPageCount,
          searchKey:
          searchController.text.isNotEmpty ? searchController.text : null,
          categoryId: selectedCategory.value?.id,
        ),
      ),
    );*/
  }

  _buildMyRitualTile(
      BuildContext context,
      int index,

      animation,
      Function(String id) secondaryBtnAction, {
        bool isDraft = false,
      }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: animation,
            child: RitualTile(
              onTap: () {
                showAppConfirmationDialog(
                  context: context,
                  message: "yourSelectedRitualHasBeenDelete".tr,
                  primaryBtnTitle: "no".tr,
                  secondaryBtnTitle: "yes".tr,
                  secondaryBtnAction: () => secondaryBtnAction("" ?? ''),
                );
              },
              title: "ritualsName".tr ?? '',
              subTitle: "ritualsName".tr   ?? '',
              multiSubTitle: ["rituals Name" ],
              showDelete: true,
              image: '',
              showEdit: isDraft ? isDraft : false,
              onEditTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
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
                        child: EditRitualDialogWidget(
                          onDraftTap: (newRitualText) {
                            Navigator.of(context).pop();
                            _updateUserRitual(
                              newRitualText.trim(),
                              "",
                              isSaved: false,
                            );
                          },
                          onSaveTap: (newRitualText) {
                            Navigator.of(context).pop();
                            _updateUserRitual(
                              newRitualText.trim(),
                              "",
                              isSaved: true,
                            );
                          },
                          onDeleteTap: () {
                            Navigator.of(context).pop();
                            showAppConfirmationDialog(
                              context: context,
                              message: "yourSelectedRitualHasBeenDelete".tr,
                              primaryBtnTitle: "no".tr,
                              secondaryBtnTitle: "yes".tr,
                              secondaryBtnAction: () =>
                                  secondaryBtnAction("" ?? ''),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              // color: AppColors.deleteRedLight,
            ),
          ),
        ),
        if (index < listOfMyRituals.length - 1)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: DividerWidget(),
          )
      ],
    );
  }

  _buildShoorahRitualsTile(
      BuildContext context, int index, animation) {
    return Column(
      children: [
        SizeTransition(
          axis: Axis.vertical,
          sizeFactor: animation,
          child: RitualTile(
            onTap: () {
              if (_debounceForAdd?.isActive ?? false) _debounceForAdd?.cancel();
              itemIndexToRemove = index;
              setState(() {});
              _debounceForAdd = Timer(const Duration(milliseconds: 200), () {
                final retVal = listOfRituals.removeAt(itemIndexToRemove);

                _shoorahRitualsListKey.currentState?.removeItem(index,
                        (_, animation) {
                      return _buildShoorahRitualsTile(
                          context, index, retVal, );
                    }, duration: const Duration(milliseconds: 200));
                itemIndexToRemove = -1;

            /*    _ritualsBloc.add(
                  AddMyRitualsEvent(
                    addMyRitualsRequest: AddMyRitualsRequest(
                      ritualIds: [data.id ?? ''],
                    ),
                  ),
                );*/
              });
            },
            title: "sadfsdf" ?? '',
            subTitle: "Sdafds",
            multiSubTitle: ["sdfsd"],
            image: itemIndexToRemove != index
                ? ImageConstant.imgAddRounded
                : ImageConstant.imgAddRounded,
            showEdit: true,
            onEditTap: () {},
          ),
        ),
        if (index < listOfRituals.length - 1)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: DividerWidget(),
          )
      ],
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with query
      pageNumber = 1;
      pageNumberMyRituals = 1;
/*      _ritualsBloc.add(
        GetShoorahRitualsEvent(
          paginationRequest: PaginationRequest(
            page: pageNumber,
            perPage: perPageCount,
            searchKey: (query.isNotEmpty) ? query : null,
            categoryId: selectedCategory.value?.id,
          ),
          isSearchQuery: true,
          isSearchFiltered: true,
        ),
      );
      _ritualsBloc.add(
        GetMyRitualsEvent(
          paginationRequest: PaginationRequest(
            page: pageNumberMyRituals,
            perPage: perPageCount,
            searchKey: (query.isNotEmpty) ? query : null,
          ),
          isSearchQuery: true,
          isSearchFiltered: true,
        ),
      );*/
    });
  }

  Widget _buildCategoryDropDown(BuildContext context) {
    return Expanded(
      child: CategoryDropDown(
        key: UniqueKey(),
        categoryList: List.from(categoryList),
        selectedCategory: selectedCategory,
        onSelected: () {
          _fetchInitialRecords();
        },
      ),
    );
  }

  Widget _getUserRitualsDraft() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dimens.d10.spaceHeight,
        Padding(
          padding: const EdgeInsets.only(left: Dimens.d20),
          child: AutoSizeText(
            "myDrafts".tr,
            style: Style.montserratBold(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ),
        Dimens.d10.spaceHeight,
        Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimens.d20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Dimens.d15.radiusAll,
          ),
          child: AnimatedList(
            key: _userDraftRitualKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            initialItemCount: userDraftRitualsList.length,
            itemBuilder: (context, index, animation) {
              if (index < userDraftRitualsList.length) {
                final data = userDraftRitualsList[index];
                return _buildMyRitualTile(
                  context,
                  index,
                  data,
                  isDraft: true,
                      (id) {
                    Navigator.pop(context);
                    final retVal = userDraftRitualsList.removeAt(index);
                    _userDraftRitualKey.currentState?.removeItem(index,
                            (_, animation) {
                          return _buildMyRitualTile(
                              context, index, retVal,
                              isDraft: true, (id) {
                        /*    _userRitualsDraftBloc.add(
                              DeleteMyRitualsEvent(
                                ritualId: id,
                              ),
                            );*/
                          });
                        }, duration: const Duration(milliseconds: 200));
                  /*  _userRitualsDraftBloc.add(
                      DeleteMyRitualsEvent(
                        ritualId: id,
                      ),
                    );*/
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        Dimens.d10.spaceHeight,
      ],
    );
  }

  Widget _getRitualsList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dimens.d10.spaceHeight,
        Padding(
          padding: const EdgeInsets.only(left: Dimens.d20),
          child: AutoSizeText(
            "myRituals".tr,
            style: Style.montserratBold(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ),
        Dimens.d10.spaceHeight,
        true
            ? Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimens.d20),
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: Dimens.d15.radiusAll,
          ),
          child: AnimatedList(
            key: _myRitualListKey,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            initialItemCount: listOfMyRituals.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index, animation) {
              if (index < listOfMyRituals.length) {
                final data = listOfMyRituals[index];
                return _buildMyRitualTile(
                  context,
                  index,
                  data,
                                        (id) {
                    Navigator.pop(context);
                    final retVal = listOfMyRituals.removeAt(index);
                    _myRitualListKey.currentState?.removeItem(index,
                            (_, animation) {
                          return _buildMyRitualTile(
                              context, index, retVal, (id) {
                         /*   _ritualsBloc.add(
                              DeleteMyRitualsEvent(
                                ritualId: id,
                              ),
                            );*/
                          });
                        }, duration: const Duration(milliseconds: 200));
                /*    _ritualsBloc.add(
                      DeleteMyRitualsEvent(
                        ritualId: id,
                      ),
                    );*/
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        )
            : SmartRefresher(
          key: const ValueKey('myRituals'),
          controller: _refreshControllerMyRituals,
          enablePullUp: true,
          enablePullDown: true,
          footer: const OnLoadingFooter(),
          physics: const NeverScrollableScrollPhysics(),
          onLoading: () {
            if (listOfMyRituals.length < totalItemCountOfMyRituals &&
                (pageNumberMyRituals <
                    (totalItemCountOfMyRituals / 10).ceil())) {
              pageNumberMyRituals += 1;
          /*    _ritualsBloc.add(
                GetMyRitualsEvent(
                  paginationRequest: PaginationRequest(
                    page: pageNumberMyRituals,
                    perPage: perPageCount,
                    searchKey: searchController.text.isNotEmpty
                        ? searchController.text
                        : null,
                  ),
                ),
              );*/
              _refreshControllerMyRituals.loadComplete();
            } else {
              _refreshControllerMyRituals.loadComplete();
            }
          },
          onRefresh: () {
            _refreshMyRitualsList();
            _refreshControllerMyRituals.loadComplete();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Dimens.d20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Dimens.d15.radiusAll,
            ),
            child: AnimatedList(
              key: _myRitualListKey,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              initialItemCount: listOfMyRituals.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index, animation) {
                if (index < listOfMyRituals.length) {
                  final data = listOfMyRituals[index];
                  return _buildMyRitualTile(
                    context,
                    index,
                    data,

                        (id) {
                      Navigator.pop(context);
                      final retVal = listOfMyRituals.removeAt(index);
                      _myRitualListKey.currentState?.removeItem(index,
                              (_, animation) {
                            return _buildMyRitualTile(
                                context, index, retVal, (id) {
                         /*     _ritualsBloc.add(
                                DeleteMyRitualsEvent(
                                  ritualId: id,
                                ),
                              );*/
                            });
                          }, duration: const Duration(milliseconds: 200));
                     /* _ritualsBloc.add(
                        DeleteMyRitualsEvent(
                          ritualId: id,
                        ),
                      );*/
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _fetchInitialRecords() {
    pageNumber = 1;
    listOfMyRituals.clear();
    listOfRituals.clear();
/*    _ritualsBloc
      ..add(
        GetMyRitualsEvent(
          paginationRequest: PaginationRequest(
            page: pageNumberMyRituals,
            perPage: perPageCount,
          ),
        ),
      )
      ..add(
        GetShoorahRitualsEvent(
          paginationRequest: PaginationRequest(
            page: pageNumber,
            perPage: perPageCount,
            categoryId: selectedCategory.value?.id,
          ),
        ),
      );*/
  }

  void _addUserRitual({bool isSaved = true}) {
    if (_userRitualController.text.isEmpty) {
      showSnackBarError(context, "pleaseAddOwnRituals".tr);
      return;
    }
  /*  _ritualsBloc.add(
      AddUserRitualsEvent(
        addUserRitualsRequest: AddUserRitualsRequest(
            ritualName: _userRitualController.text.trim(), isSaved: isSaved),
      ),
    );*/
    _userRitualController.clear();
    _userRitualFocus.unfocus();
  }

  void _updateUserRitual(
      String customRitualTitle,
      String ritualId, {
        bool isSaved = true,
      }) {
    if (customRitualTitle.isEmpty) {
      showSnackBarError(context, "pleaseAddOwnRituals".tr);
      return;
    }
  /*  _ritualsBloc.add(
      AddUserRitualsEvent(
        addUserRitualsRequest: AddUserRitualsRequest(
          ritualName: customRitualTitle.trim(),
          isSaved: isSaved,
          ritualId: ritualId,
        ),
      ),
    );*/
  }
}

class ShoorahRitualTileWidget extends StatelessWidget {

  final int index;
  final VoidCallback onAdd;

  const ShoorahRitualTileWidget(

      this.index,
      this.onAdd, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getTileWidth(context),
      height: getTileWidth(context),
      decoration: BoxDecoration(
        color:
        index.isOdd ?ColorConstant.colorThemed4 : ColorConstant.colorThemed7,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: AutoSizeText(
              "ritualName".tr ?? '',
              textAlign: TextAlign.center,
              style: Style.montserratBold(
                fontSize: Dimens.d16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 18,
            right: 10,
            child: GestureDetector(
              onTap: onAdd,
              child: SvgPicture.asset(
                ImageConstant.icEmoji,
                height: Dimens.d20,
                width: Dimens.d20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTileWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width / 2 - Dimens.d32;
}

getHeight(width) {
  return ((1080 / 1920) * (width - 40));
}
