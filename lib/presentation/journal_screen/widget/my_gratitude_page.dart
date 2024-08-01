import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_api/common_api.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/shimmer_widget.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/model_class/gratitude_all_data.dart';
import 'package:transform_your_mind/model_class/gratitude_model.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';
import 'package:transform_your_mind/presentation/start_practcing_screen/start_pratice_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';


class MyGratitudePage extends StatefulWidget {
  final bool fromNotification;

  const MyGratitudePage({
    super.key,
    this.fromNotification = false,
  });

  @override
  State<MyGratitudePage> createState() => _MyGratitudePageState();
}

class _MyGratitudePageState extends State<MyGratitudePage> {
  TextEditingController dateController = TextEditingController();
  List categoryList = [];
  DateTime todayDate = DateTime.now();


  ThemeController themeController = Get.find<ThemeController>();
  bool select = false;
  ValueNotifier selectedCategory = ValueNotifier(null);

  DateTime now = DateTime.now();
  String lastMonthName = "";
  bool loader = false;
  @override
  void initState() {
    setGetApi();
    DateTime lastMonth = DateTime(now.year, now.month - 1, 1);
    lastMonthName = DateFormat('MMMM yyyy').format(lastMonth);

    _setGreetingBasedOnTime();
    getGratitude(DateFormat('dd/MM/yyyy').format(now));
    getGratitudeAll();
    super.initState();
  }

  GratitudeModel gratitudeModel = GratitudeModel();
  GratitudeAllDataModel gratitudeAllData = GratitudeAllDataModel();
  List<GratitudeAllData> lastMonthData = [];
  getGratitude(date) async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}get-gratitude?created_by=${PrefService.getString(PrefKey.userId)}&date=$date&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      gratitudeModel = GratitudeModel();
      final responseBody = await response.stream.bytesToString();
      gratitudeModel = gratitudeModelFromJson(responseBody);
      debugPrint("gratitude Model ${gratitudeModel.data} ");
      setState(() {
        loader = false;
      });
      setState(() {});
    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
  }

  getGratitudeAll({String? dateGratitude}) async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    String url = "";
    if (dateGratitude != null) {
      url =
          '${EndPoints.baseUrl}get-gratitude?created_by=${PrefService.getString(PrefKey.userId)}&date=$dateGratitude&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}';
    } else {
      url =
          '${EndPoints.baseUrl}get-gratitude?created_by=${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}';
    }
    var request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      gratitudeAllData = GratitudeAllDataModel();
      final responseBody = await response.stream.bytesToString();
      gratitudeAllData = GratitudeAllDataModelFromJson(responseBody);
      if (dateGratitude != null) {
        lastMonthData = gratitudeAllData.data!;
      } else {
        final now = DateTime.now();
        final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
        final lastDayOfPreviousMonth =
            firstDayOfCurrentMonth.subtract(const Duration(days: 1));
        final firstDayOfPreviousMonth = DateTime(
            lastDayOfPreviousMonth.year, lastDayOfPreviousMonth.month, 1);

        lastMonthData = gratitudeAllData.data
                ?.where((element) =>
                    element.createdAt != null &&
                    element.createdAt!.isAfter(firstDayOfPreviousMonth) &&
                    element.createdAt!.isBefore(firstDayOfCurrentMonth))
                .toList() ??
            [];
        /* final now = DateTime.now();
        final lastMonth = now.subtract(const Duration(days: 30));
        lastMonthData = gratitudeAllData.data
                ?.where((element) =>
                    element.createdAt != null &&
                    element.createdAt!.isAfter(lastMonth))
                .toList() ??
            [];*/
      }

      debugPrint("gratitude Model ${gratitudeModel.data} $lastMonthData");
      setState(() {
        loader = false;
      });
      setState(() {});
    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
  }

  CommonModel commonModel = CommonModel();

  DateTime? picked;
  var dateGratitude = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String selectedDate = "";
  String greeting = "";

  void _setGreetingBasedOnTime() {
    greeting = _getGreetingBasedOnTime();
    setState(() {});
  }

  String _getGreetingBasedOnTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'goodMorning';
    } else if (hour >= 12 && hour < 17) {
      return 'goodAfternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'goodEvening';
    } else {
      return 'goodNight';
    }
  }

  setGetApi() async {
    await getUSer(context);
  }
  GetUserModel getUserModel = GetUserModel();
  getUSer(BuildContext context) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getUser}${PrefService.getString(PrefKey.userId)}",
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getUserModel = getUserModelFromJson(responseBody);
      setState(() {

      });

      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          select = false;
        });
      },
      child: (getUserModel.data?.myGratitude??false) == true
          ? Stack(
            children: [
              Scaffold(
                  floatingActionButton: GestureDetector(
                    onTap: () {
                      datePicker(context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          color: ColorConstant.themeColor, shape: BoxShape.circle),
                      child: Center(
                          child: SvgPicture.asset(ImageConstant.calenderGratitude)),
                    ),
                  ),
                  backgroundColor: themeController.isDarkMode.value
                  ? ColorConstant.darkBackground
                  : ColorConstant.backGround,
              resizeToAvoidBottomInset: false,
              appBar: CustomAppBar(
                title: "myGratitude".tr,
                showBack: true,
                action: Padding(
                  padding: const EdgeInsets.only(right: Dimens.d20),
                  child: GestureDetector(
                    onTap: () {
                      selectedCategory = ValueNotifier(null);
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
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Dimens.d10.spaceHeight,
                          Text(
                            "${"welcome".tr}, ${PrefService.getString(PrefKey.name).toString()}",
                            textAlign: TextAlign.center,
                            style: Style.nunRegular(fontSize: 26),
                          ),
                          Text(
                            DateFormat('d MMMM yyyy').format(todayDate),
                            style: Style.nunRegular(fontSize: 12),
                          ),
                          Dimens.d15.spaceHeight,
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                ImageConstant.gratitudeContainer,
                                height: Dimens.d150,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "“Calm mind brings inner strength and self-confidence, so that's very important for good health” ",
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  style: Style.nunRegular(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: ColorConstant.black),
                                ),
                              )
                            ],
                          ),
                       Dimens.d35.spaceHeight,
                            commonText("today'sGratitude".tr),
                            if ((gratitudeModel.data ?? []).isEmpty)
                              loader == true
                                  ?  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child:  shimmerCommon(),
                                  )
                                  : Center(
                                      child:   Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text("dataNotFound".tr,style: Style.gothamMedium(
                                            fontSize: 24,fontWeight: FontWeight.w700),),
                                      ),
                              ),
                          Dimens.d20.spaceHeight,
                          (gratitudeModel.data ?? []).isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                  itemCount: 1,
                                  shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: commonContainer(
                                          gratitudeList: gratitudeModel.data,
                                          des:
                                              gratitudeModel.data?[0].description ??
                                                  "",
                                            date:
                                                "${gratitudeModel.data![0].createdAt?.day ?? ""}",
                                            day: DateFormat('EEE')
                                              .format(gratitudeModel
                                                  .data![0].createdAt!)
                                              .toUpperCase()),
                                    );
                            },
                                )
                              : const SizedBox(),
                          Dimens.d10.spaceHeight,
                          (gratitudeModel.data ?? []).isNotEmpty
                                ? GestureDetector(
                                    onTap: () {

                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                            return StartPracticeScreen(
                                              gratitudeList: gratitudeModel.data,
                                            );
                                          },
                              ));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              height: Dimens.d46,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),
                                  color: ColorConstant.themeColor),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(ImageConstant.playGratitude,
                                      height: 20, width: 20),
                                  Dimens.d8.spaceWidth,
                                  Text(
                                    "startPracticing".tr,
                                              style: Style.nunRegular(
                                                  fontSize: 16, color: ColorConstant.white),
                                  )
                                ],
                              ),
                            ),
                                    )
                                : const SizedBox(),
                          (gratitudeModel.data ?? []).isEmpty?const SizedBox(): Dimens.d30.spaceHeight,
                            Row(
                              children: [
                                commonText(
                                  selectedDate.isNotEmpty
                                      ? selectedDate
                                      : lastMonthName,
                                ),
                                const Spacer(),
                                selectedDate.isEmpty
                                    ? const SizedBox()
                                    : GestureDetector(
                                        onTap: () async {
                                          dateGratitude =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(now);
                                          await getGratitudeAll();
                                          selectedDate = "";
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.clear,
                                          color:
                                              themeController.isDarkMode.isTrue
                                                  ? Colors.white
                                                  : Colors.black,
                                        ))
                              ],
                            ),
                            Dimens.d30.spaceHeight,
                            lastMonthData.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: lastMonthData.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: commonContainerAllData(
                                            dateForList:
                                                lastMonthData[index].createdAt,
                                            gratitudeList: lastMonthData,
                                            des: lastMonthData[index]
                                                    .description ??
                                                "",
                                            date:
                                                "${lastMonthData[index].createdAt?.day ?? ""}",
                                            day: DateFormat('EEE')
                                                .format(lastMonthData[index]
                                                    .createdAt!)
                                                .toUpperCase()),
                                      );
                                    },
                                  )
                                : loader == true
                                    ? shimmerCommon()
                                    : Center(
                                        child:  Text(
                                          "dataNotFound".tr,
                                          style: Style.gothamMedium(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                            Dimens.d50.spaceHeight,
                          ],
                      ),
                    ),
                  )


                  ),
              loader==true?commonLoader():const SizedBox()
            ],
          )
          : Stack(
              children: [
                Image.asset(
                  "assets/images/share_background.png",
                  height: Get.height,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: CustomAppBar(
                    title: "myGratitude".tr,
                    showBack: true,
                    onTap: () {
                      if (widget.fromNotification) {
                        Get.toNamed(AppRoutes.dashBoardScreen);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          DateFormat('d MMMM yyyy').format(todayDate),
                          style: Style.gothamLight(
                              fontSize: 12, color: ColorConstant.white),
                        ),
                      ),
                      Dimens.d12.spaceHeight,
                      Text(
                        "${greeting.tr}, ${PrefService.getString(PrefKey.name).toString()}!",
                        textAlign: TextAlign.center,
                        style: Style.nunRegular(
                            fontSize: 26, color: ColorConstant.white),
                      ),
                      Dimens.d27.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: CommonElevatedButton(
                          textStyle: Style.gothamLight(
                              fontSize: 16, color: ColorConstant.white),
                          title: "startYourFirstGratitude".tr,
                          onTap: () {
                            _onAddClick(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget commonContainer(
      {String? date,
      String? day,
      String? des,
      List<GratitudeData>? gratitudeList}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AddGratitudePage(
              date: dateGratitude,
              previous: false,
              categoryList: gratitudeList,
              isFromMyGratitude: true,
              registerUser: false,
              edit: true,
            );
          },
        )).then(
          (value) async {

            await getGratitude(dateGratitude);
            await getGratitudeAll();
            setState(() {});
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
            color: themeController.isDarkMode.isTrue
                ? ColorConstant.textfieldFillColor
                : ColorConstant.white,
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 63,
              width: 63,
              decoration: BoxDecoration(
                  color: ColorConstant.themeColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Dimens.d3.spaceHeight,
                  Text(
                    day ?? "",
                    style: Style.nunRegular(
                        fontSize: 10, color: ColorConstant.white),
                  ),
                  Text(
                    date ?? "",
                    style: Style.nunitoBold(
                        fontSize: 30, color: ColorConstant.white),
                  ),
                ],
              ),
            ),
            Dimens.d13.spaceWidth,
            Expanded(
                child: Text(
              "“$des”",
              style: Style.nunRegular(
                  height: 2, fontSize: 11, fontWeight: FontWeight.w400),
            ))
          ],
        ),
      ),
    );
  }

  Widget commonContainerAllData(
      {String? date,
      String? day,
      String? des,
      DateTime? dateForList,
      List<GratitudeAllData>? gratitudeList}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AddGratitudePage(
              previous: true,
              date: DateFormat("dd/MM/yyyy").format(dateForList!),
              categoryListAll: gratitudeList,
              isFromMyGratitude: true,
              registerUser: false,
              edit: true,
            );
          },
        )).then(
          (value) async {
            await getGratitude(dateGratitude);
            await getGratitudeAll();

            setState(() {});
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
            color: themeController.isDarkMode.isTrue
                ? ColorConstant.textfieldFillColor
                : ColorConstant.white,
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 63,
              width: 63,
              decoration: BoxDecoration(
                  color: ColorConstant.themeColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Dimens.d3.spaceHeight,
                  Text(
                    day ?? "",
                    style: Style.nunRegular(
                        fontSize: 10, color: ColorConstant.white),
                  ),
                  Text(
                    date ?? "",
                    style: Style.nunitoBold(
                        fontSize: 30, color: ColorConstant.white),
                  ),
                ],
              ),
            ),
            Dimens.d13.spaceWidth,
            Expanded(
                child: Text(
              "“$des”",
              style: Style.nunRegular(
                  height: 2, fontSize: 11, fontWeight: FontWeight.w400),
            ))
          ],
        ),
      ),
    );
  }

  Widget commonText(text) {
    return Text(
      text,
      style: Style.nunitoBold(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Future<void> _onAddClick(BuildContext context) async {
    final subscriptionStatus = "SUBSCRIBED";

    /// to check if item counts are not more then the config count in case of no subscription
    if (!(subscriptionStatus == "SUBSCRIBED" ||
        subscriptionStatus == "SUBSCRIBED")) {
      /*   Navigator.pushNamed(context, SubscriptionPage.subscription, arguments: {
        AppConstants.isInitialUser: AppConstants.noSubscription,
        AppConstants.subscriptionMessage: i10n.journalNoSubscriptionMessage,
      });*/
    } else {
     await updateApi(context,pKey: "myGratitude");
     setGetApi();
      dateController.clear();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return AddGratitudePage(
            date: dateGratitude,
            categoryList: gratitudeModel.data,
            isFromMyGratitude: true,
            registerUser: false,
            edit: false,
          );
        },
      )).then(
        (value) async {
          await getGratitude(dateGratitude);
          await getGratitudeAll();

          setState(() {});
        },
      );
    }
  }



  datePicker(context,) async {
    FocusScope.of(context).unfocus();
    picked = await showDatePicker(
      builder: (context, child) {
        TextStyle customTextStyle =
            Style.nunMedium(fontSize: 15, color: Colors.black);
        TextStyle editedTextStyle = customTextStyle.copyWith(color: Colors.red);
        return Theme(
          data: ThemeData.light().copyWith(focusColor: ColorConstant.themeColor,
              colorScheme: ColorScheme.light(
                primary: ColorConstant.themeColor,
                onPrimary: Colors.white,
                onBackground: Colors.white,
                background: Colors.white,
                surface: themeController.isDarkMode.isTrue
                    ? ColorConstant.textfieldFillColor
                    : ColorConstant.white,
                surfaceTint: themeController.isDarkMode.isTrue
                    ? ColorConstant.color7A7A7A
                    : ColorConstant.themeColor,
                onSurface: themeController.isDarkMode.isTrue
                    ? Colors.white
                    : ColorConstant.black,
              ),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
              dialogTheme: const DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Remove border radius
                ),
                elevation: 0.0,
                insetPadding:
                    EdgeInsets.all(0), // Remove padding around the dialog
              ),
              textTheme: TextTheme(
                bodyLarge:customTextStyle,
                bodyMedium: customTextStyle,
                bodySmall: customTextStyle,
                displayLarge: customTextStyle,
                displayMedium: customTextStyle,
                titleLarge: customTextStyle,
                displaySmall: customTextStyle,
                headlineMedium: customTextStyle,
                headlineSmall: customTextStyle,
                labelLarge: customTextStyle,
                labelMedium: customTextStyle,
                labelSmall: customTextStyle,
                titleMedium: editedTextStyle,
                titleSmall: editedTextStyle,
              )),
          child: child!,
        );
      },

      context: context,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      initialDate: DateTime.now(),
      onDatePickerModeChange: (value) {},
    );

    if (picked != null) {
      dateGratitude = DateFormat('dd/MM/yyyy').format(picked!);
      dateController.text = dateGratitude;
      setState(() {
        selectedDate = DateFormat('MMMM yyyy').format(picked!);
      });
      //await getGratitude(dateGratitude);
      await getGratitudeAll(dateGratitude: dateGratitude);
    }
  }


}
