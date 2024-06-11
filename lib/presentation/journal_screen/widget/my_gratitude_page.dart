import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/on_loading_bottom_indicator.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/date_time.dart';
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
import 'package:transform_your_mind/theme/theme_controller.dart';
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
  TextEditingController dateController = TextEditingController();
  FocusNode dateFocus = FocusNode();

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
  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? ColorConstant.black
              : ColorConstant.backGround,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: "myGratitude".tr,
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
              /*         BackGroundContainer(
                image: ImageConstant.homeBgBookmarks,
                isLeft: true,
                top: Dimens.d251,
                height: Dimens.d289,
              ),*/
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimens.d20),
                                              child: Text(
                                                "drafts".tr,
                                                style: Style.montserratRegular(
                                                  fontSize: Dimens.d18,
                                                ),
                                              ),
                                            ),
                                            Dimens.d20.h.spaceHeight,
                                            SizedBox(
                                              height: Dimens.d70.h,
                                              child: SmartRefresher(
                                                controller:
                                                    _refreshControllerDrafts,
                                                enablePullUp: true,
                                                enablePullDown: false,
                                                // footer: const OnLoadingFooter(),
                                                onLoading: () {},
                                                child: ListView.builder(
                                                  itemCount:
                                                      gratitudeDraftList.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    var data =
                                                        gratitudeDraftList[
                                                            index];
                                                    return GestureDetector(
                                                      onTap: () {},
                                                      child:
                                                          JournalDraftListTileLayout(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: Dimens
                                                                          .d16),
                                                              title: data[
                                                                      "title"] ??
                                                                  '',
                                                              image:
                                                                  'https://picsum.photos/250?image=9' /* data["image"] */ ??
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
                                                                setState(() {});
                                                              }),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                              Dimens.d20.spaceHeight,
                              gratitudeDraftList.isNotEmpty ||
                                      gratitudeList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimens.d30),
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          DateTime initialDate = dateController
                                                  .text.isNotEmpty
                                              ? DateTimeUtils.parseDate(
                                                          dateController.text,
                                                          format: DateTimeUtils
                                                              .ddMMyyyyToParse)
                                                      .isAfter(DateTime.now())
                                                  ? DateTimeUtils.parseDate(
                                                      dateController.text,
                                                      format: DateTimeUtils
                                                          .ddMMyyyyToParse)
                                                  : DateTime.now()
                                              : DateTime.now();
                                          picker.DatePicker.showDatePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime.now().subtract(
                                                  const Duration(days: 1)),
                                              theme: picker.DatePickerTheme(
                                                  doneStyle: Style.montserratRegular(
                                                      color:
                                                          ColorConstant.white),
                                                  cancelStyle: Style.montserratRegular(
                                                      color:
                                                          ColorConstant.white),
                                                  itemStyle: Style.montserratRegular(
                                                      color:
                                                          ColorConstant.white),
                                                  backgroundColor:
                                                      ColorConstant.themeColor),
                                              maxTime: DateTime(2050),
                                              onChanged: (date) {},
                                              onConfirm: (date) {
                                            dateController.text =
                                                DateTimeUtils.formatDate(date);
                                            FocusScope.of(context).unfocus();
                                          },
                                              currentTime: initialDate,
                                              locale: picker.LocaleType.en);
                                        },
                                        child: CommonTextField(
                                            enabled: false,
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(13.0),
                                              child: SvgPicture.asset(
                                                  ImageConstant.calendar),
                                            ),
                                            hintText: "DD/MM/YYYY",
                                            controller: dateController,
                                            focusNode: dateFocus),
                                      ),
                                    )
                                  : const SizedBox(),

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
                                                  _refreshController
                                                      .loadComplete();
                                                } else {
                                                  _refreshController
                                                      .loadComplete();
                                                }
                                              },
                                              onRefresh: () {
                                                pageNumber = 1;
                                                _isSearching = false;
                                                gratitudeList.clear();

                                                _refreshController
                                                    .loadComplete();
                                                _refreshController
                                                    .refreshCompleted();
                                              },
                                              child: ListView.builder(
                                                itemCount: gratitudeList.length,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var data =
                                                      gratitudeList[index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return const AddGratitudePage(
                                                            isFromMyGratitude:
                                                                true,
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
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              width: Dimens.d65,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .red
                                                                    .withOpacity(
                                                                        0.5),
                                                                borderRadius:
                                                                    Dimens.d16
                                                                        .radiusAll,
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: SvgPicture
                                                                  .asset(
                                                                ImageConstant
                                                                    .icDeleteWhite,
                                                                width:
                                                                    Dimens.d24,
                                                                height:
                                                                    Dimens.d24,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      child:
                                                          JournalListTileLayout(
                                                        margin: EdgeInsets.only(
                                                            bottom:
                                                                Dimens.d20.h),
                                                        title:
                                                            data["title"] ?? '',
                                                        //image: data["image"] ?? '',
                                                        image:
                                                            "https://picsum.photos/250?image=9" ??
                                                                '',
                                                        createdDate:
                                                            data["createdOn"] ??
                                                                '',
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : _isLoadingDraft
                                            ? const SizedBox.shrink()
                                            : gratitudeList.isEmpty &&
                                                    gratitudeDraftList.isEmpty
                                                ? Center(
                                                    child: JournalNoDataWidget(
                                                    showBottomHeight: true,
                                                    title: _isSearching
                                                        ? "noSearchData".tr
                                                        : "noGratitudeData".tr,
                                                    onClick: () {
                                                      _onAddClick(context);
                                                    },
                                                  ))
                                                : const SizedBox(),
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
          )),
    );
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
      });
    }
  }

  void _refreshGratitudeList(bool isSaved) {
    pageNumber = 1;

    pageNumberDrafts = 1;
    gratitudeDraftList.clear();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with query
      _isSearching = true;
      pageNumber = 1;
      query.trim();

      if (query.isNotEmpty) {
        if (!RegExp(r'[^\w\s]').hasMatch(query)) {}
      } else {}
    });
  }
}
