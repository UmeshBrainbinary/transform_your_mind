import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/focus_filter_bottom_sheet_child.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/ritual_tile.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/common_widget/tutorial_video_player.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/divider.dart';


class AddRitualsPage extends StatefulWidget {
  const AddRitualsPage({Key? key}) : super(key: key);

  @override
  State<AddRitualsPage> createState() => _AddRitualsPageState();
}

class _AddRitualsPageState extends State<AddRitualsPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int pageNumber = 1;
  late List _listOfShoorahRitualsRequest;
  List<String> addShoorahRitual = [];
  int totalItemCountOfRituals = 0;
  int ritualAddedCount = 0;
  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(true);
  ThemeController themeController = Get.find<ThemeController>();

  Timer? _debounce;

  List? listOfSelectFocusResponse = [];
  List<String> _filteredFocusIds = [];

  @override
  void initState() {
    super.initState();
    _listOfShoorahRitualsRequest = [];


    isTutorialVideoVisible.value = (ritualAddedCount < 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: themeController.isDarkMode.value ? ColorConstant.black : ColorConstant.backGround,
      appBar: CustomAppBar(
          title: "rituals".tr,
          action: Row(children: [
            GestureDetector(
                onTap: () async {
             /*     dashboardBloc.add(UpdateOnboardingStepEvent(
                      request: OnboardingStep(onBoardStep: null)));*/
                  await PrefService.setValue(PrefKey.firstTimeRegister,true);
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.dashBoardScreen, (route) => false);
                },
                child: Text("skip".tr,style:Style.montserratRegular(
                  fontSize: Dimens.d15,
                color:  themeController.isDarkMode.value ? ColorConstant.white : ColorConstant.black
                ),)),
            Dimens.d20.spaceWidth,
          ])),
      body: Stack(
        children: [
          LayoutContainer(
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: isTutorialVideoVisible,
                  builder: (BuildContext context, value, Widget? child) {
                    return AnimatedContainer(
                      height: value ? Dimens.d190.h : Dimens.d0,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedOpacity(
                        opacity: value ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: Dimens.d10.h,
                            bottom: Dimens.d20.h,
                          ),
                          child: VideoThumbWidget(

                            onTap: () {
                              if (ritualAddedCount < 3) {
                              /*  SharedPrefUtils.setValue(
                                  SharedPrefUtilsKeys.ritualAddedCount,
                                  3,
                                );*/
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Dimens.d32.spaceHeight,
                Stack(
                  children: [
                    CommonTextField(
                      hintText: "searchRituals".tr,
                      controller: searchController,
                      focusNode: searchFocus,
                      prefixLottieIcon: ImageConstant.lottieSearch,
                      suffixLottieIcon: ImageConstant.lottieFilter,
                      textInputAction: TextInputAction.done,
                      onChanged: _onSearchChanged,
                      suffixTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Dimens.d24),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return FocusFilterBottomSheetChild(
                              listOfSelectFocusResponse:
                              listOfSelectFocusResponse ?? [],
                              onViewResults: (addedResult, updatedList) {
                                listOfSelectFocusResponse?.clear();
                                listOfSelectFocusResponse
                                    ?.addAll(updatedList);
                           /*     _filteredFocusIds = addedResult
                                    .map((e) => e.focusId ?? '')
                                    .toList();
                                pageNumber = 1;
                                _ritualsBloc.add(
                                  GetShoorahRitualsEvent(
                                    paginationRequest: PaginationRequest(
                                      page: pageNumber,
                                      perPage: Dimens.d10.toInt(),
                                      searchKey:
                                      searchController.text.isNotEmpty
                                          ? searchController.text
                                          : null,
                                      focusIds: _filteredFocusIds
                                          .isNotEmpty
                                          ? jsonEncode(_filteredFocusIds)
                                          : null,
                                    ),
                                    isSearchQuery:
                                    searchController.text.isNotEmpty,
                                    isSearchFiltered:
                                    _filteredFocusIds.isNotEmpty,
                                  ),
                                );*/
                              },
                            );
                          },
                        );
                      },
                    ),
                    if (_filteredFocusIds.isNotEmpty)
                      Positioned(
                        right: Dimens.d17,
                        top: Dimens.d14,
                        child: Container(
                          height: Dimens.d9,
                          width: Dimens.d9,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimens.d20),
                              color: ColorConstant.themeColor),
                        ),
                      ),
                  ],
                ),
                Dimens.d20.spaceHeight,
                Expanded(
                  child:/* (state is RitualsLoadingState && pageNumber == 1)
                      ? const RitualsShimmer(horizontalPadding: 0)
                      : _listOfShoorahRitualsRequest.isNotEmpty
                      ? */Container(
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : Colors.white,
                      borderRadius: Dimens.d15.radiusAll,
                    ),
                    child: SmartRefresher(
                        controller: _refreshController,
                        enablePullUp: true,
                        enablePullDown: false,
                        footer: CustomFooter(
                          builder: (BuildContext context,
                              LoadStatus? mode) {
                            Widget body;
                            if (mode == LoadStatus.idle) {
                              body = const Offstage();
                            } else if (mode ==
                                LoadStatus.loading) {
                              body = InkDropLoader(
                                size: Dimens.d40,
                                color:
                               ColorConstant.themeColor,
                              );
                            } else if (mode ==
                                LoadStatus.failed) {
                              body =  Text(
                                  "loadFailedRetry".tr);
                            } else if (mode ==
                                LoadStatus.canLoading) {
                              body =  Text(
                                  "releaseToLoadMore".tr);
                            } else {
                              body =
                               Text("noMoreData".tr);
                            }
                            return SizedBox(
                              height: Dimens.d55,
                              child: Center(child: body),
                            );
                          },
                        ),
                        onLoading: () {
                          if (_listOfShoorahRitualsRequest
                              .length <
                              totalItemCountOfRituals &&
                              (pageNumber <
                                  (totalItemCountOfRituals / 10)
                                      .ceil())) {
                            pageNumber += 1;
                          /*  _ritualsBloc.add(
                              GetShoorahRitualsEvent(
                                paginationRequest:
                                PaginationRequest(
                                  page: pageNumber,
                                  perPage: Dimens.d10.toInt(),
                                  searchKey: searchController
                                      .text.isNotEmpty
                                      ? searchController.text
                                      : null,
                                  focusIds: _filteredFocusIds
                                      .isNotEmpty
                                      ? jsonEncode(
                                      _filteredFocusIds)
                                      : null,
                                ),
                              ),
                            );*/
                            _refreshController.loadComplete();
                          } else {
                            _refreshController.loadComplete();
                          }
                        },
                        child: ListView.separated(
                          physics:
                          const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return RitualTile(
                              onTap: () {
                                _listOfShoorahRitualsRequest[
                                index]
                                    .isSelected =
                                !(_listOfShoorahRitualsRequest[
                                index]
                                    .isSelected ??
                                    true);
                                if (_listOfShoorahRitualsRequest[
                                index]
                                    .isSelected ??
                                    false) {
                                  addShoorahRitual.add(
                                      _listOfShoorahRitualsRequest[
                                      index]
                                          .id ??
                                          '');
                                } else {
                                  addShoorahRitual.remove(
                                      _listOfShoorahRitualsRequest[
                                      index]
                                          .id ??
                                          '');
                                }
                                setState(() {});
                              },
                              title:
                              _listOfShoorahRitualsRequest[
                              index]
                                  .ritualName ??
                                  '',
                              subTitle:
                              _listOfShoorahRitualsRequest[
                              index]
                                  .focusName
                                  ?.join(', ') ??
                                  '',
                              multiSubTitle:
                              _listOfShoorahRitualsRequest[
                              index]
                                  .focusName,
                              image:/*
                              (_listOfShoorahRitualsRequest[
                              index]
                                  .isSelected ??
                                  false)
                                  ? getAssetAccordingToTheme(
                                shoorah: AppAssets
                                    .imgSelectedRitualShoorah,
                                land: AppAssets
                                    .imgSelectedRitualLand,
                                bloom: AppAssets
                                    .imgSelectedRitualBloom,
                                sun: AppAssets
                                    .imgSelectedRitualSun,
                                ocean: AppAssets
                                    .imgSelectedRitualOcean,
                                desert: AppAssets
                                    .imgSelectedRitualDesert,
                              )
                                  :*/ ImageConstant.imgAddRounded,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const DividerWidget();
                          },
                          itemCount:
                          _listOfShoorahRitualsRequest
                              .length,
                        )),
                  )
                   /*   : Center(
                    child: NoDataAvailable(
                      message:
                      i10n.selectMoreFocusToFindNewRituals,
                      showBottomHeight: false,
                    ),
                  ),*/
                ),
                if (_listOfShoorahRitualsRequest.isNotEmpty)
                  Dimens.d20.spaceHeight,
                if (_listOfShoorahRitualsRequest.isNotEmpty)
                  CommonElevatedButton(
                    title: "next".tr,
                    onTap: () {
                      if (addShoorahRitual.isEmpty) {
                        showSnackBarError(context, "pleaseSelectLeastOneRitual".tr);
                      } else {
                    /*    _ritualsBloc.add(AddMyRitualsEvent(
                            addMyRitualsRequest: AddMyRitualsRequest(
                                ritualIds: addShoorahRitual)));*/
                      }
                    },
                  )
              ],
            ),
          ),
        ],
      )
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      pageNumber = 1;

     /* _ritualsBloc.add(
        GetShoorahRitualsEvent(
          paginationRequest: PaginationRequest(
            page: pageNumber,
            perPage: Dimens.d10.toInt(),
            searchKey: (query.isNotEmpty) ? query : null,
            focusIds: _filteredFocusIds.isNotEmpty
                ? jsonEncode(_filteredFocusIds)
                : null,
          ),
          isSearchQuery: true,
          isSearchFiltered: true,
        ),
      );*/
    });
  }
}
