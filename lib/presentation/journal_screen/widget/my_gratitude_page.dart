import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/lottie_icon_button.dart';
import 'package:transform_your_mind/core/common_widget/on_loading_bottom_indicator.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_list_tile_layout.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_no_data.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_shimmer_widget.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

List gratitudeDraftList = [];
List gratitudeList = [];

class MyGratitudePage extends StatefulWidget {
  final bool fromNotification;

  const MyGratitudePage({
    Key? key,
    this.fromNotification = false,
  }) : super(key: key);

  @override
  State<MyGratitudePage> createState() => _MyGratitudePageState();
}

class _MyGratitudePageState extends State<MyGratitudePage> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  bool _isLoading = false;
  bool _isLoadingDraft = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _refreshControllerDrafts =
      RefreshController(initialRefresh: false);
  int pageNumber = 1;
  int pageNumberDrafts = 1;
  int totalItemCountOfGratitude = 0;
  int totalItemCountOfGratitudeDrafts = 0;
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "myGratitude".tr,
          showBack: true,
          action: LottieIconButton(
              icon: ImageConstant.lottieNavAdd,
              iconHeight: 35,
              iconWidth: 35,
              repeat: true,
              onTap: () => _onAddClick(context)),
          onTap: () {
            if (widget.fromNotification) {
              Get.toNamed(AppRoutes.dashBoardScreen);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        body: Stack(
          children: [
            BackGroundContainer(
              image: ImageConstant.homeBgBookmarks,
              isLeft: true,
              top: Dimens.d251,
              height: Dimens.d289,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimens.d30.spaceHeight,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [


                            ///draft list
                            (_isLoadingDraft && pageNumberDrafts == 1)
                                ? const JournalListHorizontalShimmer()
                                : (gratitudeDraftList.isNotEmpty)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimens.d20),
                                            child: Text(
                                              "drafts".tr,
                                              style: Style.montserratMedium(
                                                fontSize: Dimens.d16,
                                              ),
                                            ),
                                          ),
                                          Dimens.d20.h.spaceHeight,
                                          SizedBox(
                                            height: Dimens.d110.h,
                                            child: SmartRefresher(
                                              controller:
                                                  _refreshControllerDrafts,
                                              enablePullUp: true,
                                              enablePullDown: false,
                                              // footer: const OnLoadingFooter(),
                                              onLoading: () {
                                                /*    if (gratitudeDraftList.length <
                                  totalItemCountOfGratitudeDrafts) {
                                pageNumberDrafts += 1;
                                _gratitudeBloc.add(
                                  GetMyGratitudeEvent(
                                    paginationRequest:
                                    PaginationRequest(
                                      page: pageNumberDrafts,
                                      perPage:
                                      Dimens.d10.toInt(),
                                      isSaved: false,
                                    ),
                                  ),
                                );
                                _refreshControllerDrafts
                                    .loadComplete();
                              } else {
                                _refreshControllerDrafts
                                    .loadComplete();
                              }*/
                                              },
                                              child: ListView.builder(
                                                itemCount:
                                                    gratitudeDraftList.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var data =
                                                      gratitudeDraftList[index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      /* Navigator.pushNamed(
                                      context,
                                      AddGratitudePage
                                          .addGratitude,
                                      arguments: {
                                        AppConstants
                                            .isFromGratitude:
                                        true,
                                        AppConstants.isSaved:
                                        false,
                                        AppConstants.data: data,
                                      },
                                    ).then((value) {
                                      if (value != null &&
                                          value is bool) {
                                        _refreshGratitudeList(
                                            value);
                                      }
                                    });*/
                                                    },
                                                    child:
                                                        JournalDraftListTileLayout(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: Dimens
                                                                        .d16),
                                                            title:
                                                                data["title"] ??
                                                                    '',
                                                            image:'https://picsum.photos/250?image=9'
                                                               /* data["image"] */??
                                                                    '',
                                                            createdDate: data[
                                                                    "createdOn"] ??
                                                                '',
                                                            showDelete: true,
                                                            onDeleteTapCallback:
                                                                () {
                                                                  gratitudeDraftList
                                                                      .removeAt(
                                                                      index);
                                                                  setState(() {

                                                                  });
                                                              /*     _gratitudeBloc.add(
                                          DeleteGratitudeEvent(
                                              deleteGratitudeRequest: DeleteGratitudeRequest(
                                                  userGratitudeId:
                                                  data.userGratitudeId ??
                                                      ""),
                                              isFromDraft:
                                              true),
                                        );
                                        gratitudeDraftList
                                            .removeAt(
                                            index);
                                        _gratitudeBloc.add(
                                            RefreshGratitudeEvent());*/
                                                            }),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                            if (_isLoadingDraft ||
                                (gratitudeDraftList.isNotEmpty))

                            (_isLoading && pageNumber == 1 && !_isSearching)
                                ? const JournalSearchShimmer()
                                : (gratitudeList.isNotEmpty ||
                                gratitudeDraftList.isNotEmpty) ||
                                _isSearching
                                ? LayoutContainer(
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(Dimens.d0_1),
                                      blurRadius: Dimens.d67,
                                    ),
                                  ],
                                ),
                                child: CommonTextField(
                                    hintText: "searchGratitudeHere".tr,
                                    controller: searchController,
                                    focusNode: searchFocus,
                                    prefixLottieIcon:
                                    ImageConstant.lottieSearch,
                                    textInputAction:
                                    TextInputAction.done,
                                    onChanged: _onSearchChanged,
                                    suffixLottieIcon: searchController
                                        .text.isNotEmpty
                                        ? ImageConstant.lottieClose
                                        : null,
                                    suffixTap: () {
                                      searchController.text = '';
                                      searchFocus.unfocus();

                                      _onSearchChanged(
                                          searchController.text);
                                    }),
                              ),
                            )
                                : const SizedBox.shrink(),


                            /// saved list
                            Expanded(
                              child: (_isLoading &&
                                      (pageNumber == 1) &&
                                      !_isSearching)
                                  ? const JournalListShimmer()
                                  : (gratitudeList.isNotEmpty)
                                      ? LayoutContainer(
                                        child: SmartRefresher(
                                            controller: _refreshController,
                                            enablePullUp: true,
                                            enablePullDown: true,
                                            footer: const OnLoadingFooter(),
                                            onLoading: () {
                                              if (gratitudeList.length <
                                                  totalItemCountOfGratitude) {
                                                pageNumber += 1;
                                                /*   _gratitudeBloc.add(
                                        GetMyGratitudeEvent(
                                          paginationRequest:
                                          PaginationRequest(
                                            page: pageNumber,
                                            perPage: Dimens.d10
                                                .toInt(),
                                            isSaved: true,
                                            searchKey: searchController
                                                .text
                                                .isNotEmpty
                                                ? searchController
                                                .text
                                                : null,
                                          ),
                                        ),
                                                                            );*/
                                                _refreshController.loadComplete();
                                              } else {
                                                _refreshController.loadComplete();
                                              }
                                            },
                                            onRefresh: () {
                                              pageNumber = 1;
                                              _isSearching = false;
                                              gratitudeList.clear();
                                              /*    _gratitudeBloc.add(
                                                                            GetMyGratitudeEvent(
                                        paginationRequest:
                                        PaginationRequest(
                                          page: pageNumber,
                                          perPage:
                                          Dimens.d10.toInt(),
                                          isSaved: true,
                                          searchKey:
                                          searchController
                                              .text
                                              .isNotEmpty
                                              ? searchController
                                              .text
                                              : null,
                                        ),
                                                                            ),
                                                                          );*/
                                              _refreshController.loadComplete();
                                              _refreshController
                                                  .refreshCompleted();
                                            },
                                            child: ListView.builder(
                                              itemCount: gratitudeList.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                var data = gratitudeList[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                      builder: (context) {
                                                        return const AddGratitudePage(
                                                          isFromMyGratitude: true,
                                                          registerUser: false,
                                                          isSaved: true,
                                                        );
                                                      },
                                                    )).then(
                                                      (value) {
                                                        if (value != null &&
                                                            value is bool) {
                                                          _refreshGratitudeList(
                                                              value);
                                                        }
                                                        setState(() {});
                                                      },
                                                    );
                                                    /*    Navigator.pushNamed(
                                            context,
                                            AddGratitudePage
                                                .addGratitude,
                                            arguments: {
                                           */ /*   AppConstants
                                                  .isFromGratitude:
                                              true,
                                              AppConstants
                                                  .isSaved: true,
                                              AppConstants.data:*/ /*
                                              data,
                                            },
                                          ).then((value) {
                                            if (value != null &&
                                                value is bool) {
                                              _refreshGratitudeList(
                                                  value);
                                            }
                                          });*/
                                                  },
                                                  child: Slidable(
                                                    closeOnScroll: true,
                                                    key: ValueKey<String>(
                                                        data["createdOn"] ??
                                                            ""),
                                                    endActionPane: ActionPane(
                                                      motion:
                                                          const ScrollMotion(),
                                                      dragDismissible: false,
                                                      extentRatio: 0.26,
                                                      children: [
                                                        Dimens.d20.spaceWidth,
                                                        GestureDetector(
                                                          onTap: () {
                                                            gratitudeList
                                                                .removeAt(
                                                                index);
                                                            setState(() {

                                                            });
                                                            /*         _gratitudeBloc
                                                      .add(
                                                    DeleteGratitudeEvent(
                                                        deleteGratitudeRequest: DeleteGratitudeRequest(
                                                            userGratitudeId: data.userGratitudeId ??
                                                                ""),
                                                        isFromDraft:
                                                        false),
                                                  );
                                                  gratitudeList
                                                      .removeAt(
                                                      index);
                                                  _isSearching =
                                                      gratitudeList
                                                          .isNotEmpty;
                                                  _gratitudeBloc.add(
                                                      RefreshGratitudeEvent());*/
                                                          },
                                                          child: Container(
                                                            width: Dimens.d65,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: Dimens
                                                                        .d20.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius: Dimens
                                                                  .d16.radiusAll,
                                                            ),
                                                            alignment:
                                                                Alignment.center,
                                                            child:
                                                                SvgPicture.asset(
                                                              ImageConstant
                                                                  .icDeleteWhite,
                                                              width: Dimens.d24,
                                                              height: Dimens.d24,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: JournalListTileLayout(
                                                      margin: EdgeInsets.only(
                                                          bottom: Dimens.d20.h),
                                                      title:
                                                          data["title"] ?? '',
                                                      //image: data["image"] ?? '',
                                                      image: "https://picsum.photos/250?image=9"?? '',
                                                      createdDate:
                                                          data["createdOn"] ?? '',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                      )
                                      : _isLoadingDraft
                                          ? const SizedBox.shrink()
                                          : gratitudeList.isEmpty && gratitudeDraftList.isEmpty?Center(
                                              child: JournalNoDataWidget(
                                              showBottomHeight: true,
                                              title: _isSearching
                                                  ? "noSearchData".tr
                                                  : "noGratitudeData".tr,
                                              onClick: () {
                                                _onAddClick(context);
                                              },
                                            )):const SizedBox(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  void _onAddClick(BuildContext context) {
    final subscriptionStatus = "SUBSCRIBED";

    /// to check if item counts are not more then the config count in case of no subscription
    if (!(subscriptionStatus == "SUBSCRIBED" ||
        subscriptionStatus == "SUBSCRIBED")) {
      /*   Navigator.pushNamed(context, SubscriptionPage.subscription, arguments: {
        AppConstants.isInitialUser: AppConstants.noSubscription,
        AppConstants.subscriptionMessage: i10n.journalNoSubscriptionMessage,
      });*/
    } else {
      Get.toNamed(AppRoutes.addGratitudePage)!.then((value) {
        setState(() {});
        /*  if (value != null && value is bool) {
          value ? gratitudeList.clear() : gratitudeDraftList.clear();
          _gratitudeBloc.add(
            GetMyGratitudeEvent(
              paginationRequest: PaginationRequest(
                page: 1,
                perPage: Dimens.d10.toInt(),
                isSaved: value,
                searchKey: value
                    ? searchController.text.isNotEmpty
                        ? searchController.text
                        : null
                    : null,
              ),
            ),
          );
        }*/
      });
    }
  }

  void _refreshGratitudeList(bool isSaved) {
    pageNumber = 1;
    /*  gratitudeList.clear();
    _gratitudeBloc.add(
      GetMyGratitudeEvent(
        paginationRequest: PaginationRequest(
          page: pageNumber,
          perPage: Dimens.d10.toInt(),
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
    gratitudeDraftList.clear();
/*    _gratitudeBloc.add(
      GetMyGratitudeEvent(
        paginationRequest: PaginationRequest(
          page: pageNumberDrafts,
          perPage: Dimens.d10.toInt(),
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with query
      _isSearching = true;
      pageNumber = 1;
      query.trim();

      if (query.isNotEmpty) {
        if (!RegExp(r'[^\w\s]').hasMatch(query)) {
          /*   _gratitudeBloc.add(
            GetMyGratitudeEvent(
              paginationRequest: PaginationRequest(
                page: pageNumber,
                perPage: Dimens.d10.toInt(),
                isSaved: true,
                searchKey: query,
              ),
              isSearchQuery: true,
            ),
          );*/
        }
      } else {
        /*   _gratitudeBloc.add(
          GetMyGratitudeEvent(
            paginationRequest: PaginationRequest(
              page: pageNumber,
              perPage: Dimens.d10.toInt(),
              isSaved: true,
            ),
            isSearchQuery: true,
          ),
        );*/
      }
    });
  }
}
