import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';
import 'package:transform_your_mind/presentation/start_practcing_screen/start_pratice_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

List gratitudeList = [];

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

/*  int pageNumber = 1;
  int pageNumberDrafts = 1;
  int totalItemCountOfGratitude = 0;
  int totalItemCountOfGratitudeDrafts = 0;*/

  ThemeController themeController = Get.find<ThemeController>();
  bool select = false;
  ValueNotifier selectedCategory = ValueNotifier(null);

/*  FocusNode searchFocus = FocusNode();
  TextEditingController searchController = TextEditingController();

  GratitudeModel gratitudeModel = GratitudeModel();
  CommonModel commonModel = CommonModel();*/
  bool loader = false;
  @override
  void initState() {
    _setGreetingBasedOnTime();
    /*getGratitude();*/
    super.initState();
  }

/*  searchBookmarks(String query, List bookmarks) {
    return bookmarks
        .where((bookmark) =>
            bookmark.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }


  getGratitude() async {
    setState(() {
      loader = true;
    });
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
      categoryList = [];
      for (int i = 0; i < gratitudeList.length; i++) {
        categoryList.add(gratitudeList[i].name);
      }
      debugPrint("gratitude Model $gratitudeList");
      debugPrint("gratitude Model ${gratitudeModel.data}");
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

  deleteGratitude(id) async {
    setState(() {
      loader = true;
    });
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

  getFilterData() {
    gratitudeList = gratitudeModel.data!
        .where((item) => item.name == selectedCategory.value)
        .toList();

    setState(() {});
  }*/

  DateTime? picked;
  var birthDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          select = false;
        });
      },
      child: gratitudeList.isNotEmpty
          ? Scaffold(
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
                        style: Style.montserratRegular(fontSize: 26),
                      ),
                      Text(
                        DateFormat('d MMMM yyyy').format(todayDate),
                        style: Style.gothamLight(fontSize: 12),
                      ),
                      Dimens.d15.spaceHeight,
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            ImageConstant.gratitudeBackground,
                            height: Dimens.d150,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "“Calm mind brings inner strength and self-confidence, so that's very important for good health” ",
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              style: Style.montserratRegular(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      Dimens.d20.spaceHeight,
                      commonText(
                        "today'sGratitude".tr,
                      ),
                      Dimens.d20.spaceHeight,
                      ListView.builder(
                        itemCount: gratitudeList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: commonContainer(
                                des: gratitudeList[index]["title"],
                                date: "${index + 1}",
                                day: "TUE"),
                          );
                        },
                      ),
                      Dimens.d25.spaceHeight,
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const StartPracticeScreen();
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
                                style: Style.montserratRegular(
                                    fontSize: 16, color: ColorConstant.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      Dimens.d30.spaceHeight,
                    ],
                  ),
                ),
              )

              /*Stack(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimens.d100),
                    child: SvgPicture.asset(themeController.isDarkMode.isTrue
                        ? ImageConstant.profile1Dark
                        : ImageConstant.profile1),
                  )),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.d120),
                    child: SvgPicture.asset(themeController.isDarkMode.isTrue
                        ? ImageConstant.profile2Dark
                        : ImageConstant.profile2),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.d30),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      datePicker(context);
                                    });
                                  },
                                  child: CommonTextField(
                                      enabled: false,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              datePicker(context);
                                            });
                                          },
                                          child: SvgPicture.asset(
                                              ImageConstant.calendar),
                                        ),
                                      ),
                                      hintText: "DD/MM/YYYY",
                                      controller: dateController,
                                      focusNode: dateFocus),
                                ),
                              ),
                              Dimens.d20.spaceHeight,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    _buildCategoryDropDown(context),
                                    Dimens.d10.spaceWidth,
                                    Expanded(
                                      child: Container(
                                        height: 38,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorConstant.colorBFD0D4
                                                  .withOpacity(0.5),
                                              blurRadius: 8.0,
                                              spreadRadius:
                                                  0.5, // Spread the shadow slightly
                                            ),
                                          ],
                                        ),
                                        child: CommonTextField(
                                          hintText: "search".tr,
                                          controller: searchController,
                                          focusNode: searchFocus,
                                          prefixLottieIcon:
                                              ImageConstant.lottieSearch,
                                          textInputAction: TextInputAction.done,
                                          onChanged: (value) async {
                                            if (value.isEmpty) {
                                              await getGratitude();
                                            } else {
                                              gratitudeList = searchBookmarks(
                                                  value, gratitudeList);
                                            }
                                            setState(()  {

                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// saved list
                              Expanded(
                                child: (_isLoading &&
                                        (pageNumber == 1) &&
                                        !_isSearching)
                                    ? const JournalListShimmer()
                                    : (gratitudeList.isNotEmpty)
                                        ? LayoutContainer(
                                            child: ListView.builder(
                                              itemCount: gratitudeList.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                var data = gratitudeList[index];
                                                return JournalListTileLayout(
                                                  description: data.description,
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
                                                          categoryList:
                                                              categoryList,
                                                          id: data.id,
                                                          description:
                                                              data.description,
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
                                                  createdDate: data.date ?? '',
                                                );
                                              },
                                            ),
                                          )
                                        : _isLoadingDraft
                                            ? const SizedBox.shrink()
                                            : gratitudeList.isEmpty
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom:
                                                                Dimens.d150),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(ImageConstant.noSearch,),
                                                        Text("dataNotFound".tr,style: Style.gothamMedium(
                                                            fontSize: 24,fontWeight: FontWeight.w700),),
                                                      ],
                                                    ),
                                                  )
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
          )*/
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
                        "${greeting.tr}, ${PrefService.getString(PrefKey.name).toString()}",
                        textAlign: TextAlign.center,
                        style: Style.montserratRegular(
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

  Widget commonContainer({String? date, String? day, String? des}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AddGratitudePage(
              categoryList: gratitudeList,
              isFromMyGratitude: true,
              registerUser: false,
              edit: true,
            );
          },
        )).then(
          (value) {
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
                    style: Style.gothamLight(
                        fontSize: 10, color: ColorConstant.white),
                  ),
                  Text(
                    date ?? "",
                    style: Style.gothamMedium(
                        fontSize: 30, color: ColorConstant.white),
                  ),
                ],
              ),
            ),
            Dimens.d13.spaceWidth,
            Expanded(
                child: Text(
              des ?? "",
              style: Style.montserratRegular(
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
      style: Style.gothamLight(fontSize: 20, fontWeight: FontWeight.w500),
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
      dateController.clear();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return AddGratitudePage(
            categoryList: categoryList,
            isFromMyGratitude: true,
            registerUser: false,
            edit: false,
          );
        },
      )).then(
        (value) async {
          /*  await getGratitude();*/
          setState(() {});
        },
      );
    }
  }



  datePicker(context,) async {
    FocusScope.of(context).unfocus();
    picked = await showDatePicker(
      builder: (context, child) {
        TextStyle customTextStyle = Style.montserratRegular(fontSize: 14,color: Colors.black);
        TextStyle editedTextStyle = customTextStyle.copyWith(color: Colors.red); // Define the edited text style

        return Theme(
          data: ThemeData.light().copyWith(focusColor: ColorConstant.themeColor,
              scaffoldBackgroundColor: ColorConstant.themeColor,
              primaryColor: ColorConstant.themeColor,
              colorScheme: const ColorScheme.light(
                primary: ColorConstant.themeColor,
              ),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
              textTheme: TextTheme(
                bodyLarge:customTextStyle,
                bodyMedium: customTextStyle,
                bodySmall: customTextStyle,
                displayLarge: customTextStyle,
                displayMedium: customTextStyle,
                headlineLarge: customTextStyle,
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
    );

    if (picked != null) {
      birthDate = DateFormat('dd/MM/yyyy').format(picked!);
      // birthDate = DateFormat("yyyy-MM-dd").format(picked!);
      dateController.text = birthDate;
    }
  }

  Widget _buildCategoryDropDown(BuildContext context) {
    return Expanded(
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstant.lightGrey),
          borderRadius: BorderRadius.circular(30),
          color: ColorConstant.themeColor,
        ),
        child: DropdownButton(
          value: selectedCategory.value,
          borderRadius: BorderRadius.circular(30),
          onChanged: (value) async {
            {
              setState(() {
                selectedCategory.value = value;
              });
              /*  getFilterData();*/
              setState(() {});
            }
          },
          selectedItemBuilder: (_) {
            return categoryList.map<Widget>((item) {
              bool isSelected = selectedCategory.value == item;
              return Padding(
                padding: const EdgeInsets.only(left: 18, top: 8),
                child: Text(
                  item ?? '',
                  maxLines: 1,
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
          dropdownColor: ColorConstant.themeColor,
          items: categoryList.map<DropdownMenuItem>((item) {
            bool isSelected = selectedCategory.value == item;
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
                    item ?? '',
                    style: Style.montserratRegular(
                      fontSize: Dimens.d14,
                      color: ColorConstant.white,
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
              height: Dimens.d96,
              width: Dimens.d96,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: Dimens.d28),
                  textStyle: Style.montserratRegular(
                      fontSize: Dimens.d12, color: ColorConstant.white),
                  title: "delete".tr,
                  onTap: () async {
                    setState(() {
                      gratitudeList = [];
                    });
                    /* await deleteGratitude(id);
                    await getGratitude();
                    getFilterData();*/
                    setState(() {});
                    Get.back();
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
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
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
