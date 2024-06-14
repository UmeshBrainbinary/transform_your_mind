import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/on_loading_bottom_indicator.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/gratitude_model.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_list_tile_layout.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_no_data.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_shimmer_widget.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';



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
  List gratitudeList = [];

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
  DateTime _currentDate = DateTime.now();
  bool select = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    getGratitude();
    super.initState();
  }

  GratitudeModel gratitudeModel = GratitudeModel();
  CommonModel commonModel = CommonModel();

  getGratitude() async {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}get-gratitude?created_by=${PrefService.getString(PrefKey.userId)}&date=${dateController.text}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      gratitudeModel = GratitudeModel();
      final responseBody = await response.stream.bytesToString();
      gratitudeModel = gratitudeModelFromJson(responseBody);
      gratitudeList = gratitudeModel.data!;

      setState(() {
        debugPrint("gratitude Model $gratitudeList");
        debugPrint("gratitude Model ${gratitudeModel.data}");
      });
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  deleteGratitude(id) async {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'DELETE', Uri.parse('${EndPoints.baseUrl}delete-gratitude?id=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message ?? "");
    } else {
      debugPrint(response.reasonPhrase);
    }
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
                              Dimens.d20.spaceHeight,
                               Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimens.d30),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            select = !select;
                                          });
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
                                    ),

                              if (select == true) widgetCalendar(),

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
                                                  return JournalListTileLayout(
                                                    onDeleteTapCallback: () {
                                                      _showAlertDialogDelete(
                                                          context,
                                                          index,
                                                          data.id);
                                                      setState(() {});
                                                    },
                                                    onEditTapCallback: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return AddGratitudePage(
                                                            id: data.id,
                                                            description: data
                                                                .description,
                                                            title: data.name,
                                                            date:
                                                                data.createdAt ??
                                                                    '',
                                                            edit: true,
                                                            isFromMyGratitude:
                                                                true,
                                                            registerUser: false,
                                                            isSaved: true,
                                                          );
                                                        },
                                                      )).then(
                                                        (value) async {
                                                          if (value != null &&
                                                              value is bool) {
                                                            _refreshGratitudeList(
                                                                value);
                                                          }
                                                          await getGratitude();
                                                          setState(() {});
                                                        },
                                                      );
                                                    },
                                                    margin: EdgeInsets.only(
                                                        bottom: Dimens.d20.h),
                                                    title: data.name ?? '',
                                                    //image: data["image"] ?? '',
                                                    image:
                                                        "https://picsum.photos/250?image=9" ??
                                                            '',
                                                    createdDate:
                                                        data.date ?? '',
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : _isLoadingDraft
                                            ? const SizedBox.shrink()
                                            : gratitudeList.isEmpty
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
              height: Dimens.d140,
              width: Dimens.d140,
            )),
            Dimens.d20.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "areYouSureDeleteGratitude".tr,
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
                  textStyle: Style.montserratRegular(
                      fontSize: Dimens.d12, color: ColorConstant.white),
                  title: "delete".tr,
                  onTap: () async {
                  setState(() {
                    gratitudeList = [];
                  });
                    await deleteGratitude(id);
                    await getGratitude();
                    setState(() {});
                    Get.back();
                  },
                ),
                Container(
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
                )
              ],
            )
          ],
        );
      },
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
      }).then(
        (value) async {
          await getGratitude();
        },
      );
    }
  }

  void _refreshGratitudeList(bool isSaved) {
    pageNumber = 1;

    pageNumberDrafts = 1;

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

  Widget widgetCalendar() {
    return Container(
        height: 350,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorConstant.white,
        ),
        child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events) async {
            if (date.isBefore(DateTime.now())) {
              setState.call(() => _currentDate = date);

              print("==========$_currentDate");
              setState.call(() {
                dateController.text = DateFormat('dd/MM/yyyy').format(date);

                /*dateController.text = "${date.day}/${date.month}/${date.year}";*/
                select = false;
              });
              await getGratitude();
              setState((){});
            }

          },

          weekendTextStyle:
          Style.montserratRegular(fontSize: 15, color: ColorConstant.black),
          // Customize your text style
          thisMonthDayBorderColor: Colors.transparent,
          customDayBuilder: (
              bool isSelectable,
              int index,
              bool isSelectedDay,
              bool isToday,
              bool isPrevMonthDay,
              TextStyle textStyle,
              bool isNextMonthDay,
              bool isThisMonthDay,
              DateTime day,
              ) {
            if (isSelectedDay) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: Dimens.d32,
                width: Dimens.d32,
                decoration: BoxDecoration(
                  color: ColorConstant.themeColor,
                  // Customize your selected day color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: Style.montserratRegular(
                        fontSize: 15,
                        color: ColorConstant
                            .white), // Customize your selected day text style
                  ),
                ),
              );
            } else {
              return null;
            }
          },
          weekFormat: false,
          daysTextStyle:
          Style.montserratRegular(fontSize: 15, color: ColorConstant.black),
          height: 300.0,
          markedDateIconBorderColor: Colors.transparent,
          childAspectRatio: 1.5,
          dayPadding: 0.0,
          prevDaysTextStyle: Style.montserratRegular(fontSize: 15),
          selectedDateTime: _currentDate,
          headerTextStyle: Style.montserratRegular(
              color: ColorConstant.black, fontWeight: FontWeight.bold),
          dayButtonColor: Colors.white,
          weekDayBackgroundColor: Colors.white,
          markedDateMoreCustomDecoration:
          const BoxDecoration(color: Colors.white),
          shouldShowTransform: false,
          staticSixWeekFormat: false,
          weekdayTextStyle: Style.montserratRegular(
              fontSize: 11,
              color: ColorConstant.color797B86,
              fontWeight: FontWeight.bold),
          todayButtonColor: Colors.transparent,
          selectedDayBorderColor: Colors.transparent,
          todayBorderColor: Colors.transparent,
          selectedDayButtonColor: Colors.transparent,
          daysHaveCircularBorder: false,
          todayTextStyle:
          Style.montserratRegular(fontSize: 15, color: ColorConstant.black),
        ));

  }
}
