import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/affirmation_category_model.dart';
import 'package:transform_your_mind/model_class/affirmation_data_model.dart';
import 'package:transform_your_mind/model_class/affirmation_model.dart';
import 'package:transform_your_mind/model_class/alarm_model.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/presentation/home_screen/home_message_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/journal_controller.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/audio_list.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_pratice_affirmation.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/divider.dart';
import 'package:voice_message_package/voice_message_package.dart';

class MyAffirmationPage extends StatefulWidget {
  const MyAffirmationPage({super.key});

  @override
  State<MyAffirmationPage> createState() => _MyAffirmationPageState();
}

class _MyAffirmationPageState extends State<MyAffirmationPage>
    with SingleTickerProviderStateMixin {
  int pageNumber = 1;
  int pageNumberAf = 0;
  int totalItemCountOfBookmarks = 0;
  int itemIndexToRemove = -1;
  int pageNumberDrafts = 1;
  String selectedDate = "";

  //k-naveen
  bool _isLoading = false;
  int totalItemCountOfAffirmation = 0;
  int totalItemCountOfAffirmationDrafts = 0;
  TextEditingController searchController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  FocusNode searchFocus = FocusNode();
  JournalController journalController = Get.put(JournalController());
  int _currentTabIndex = 0;
  ValueNotifier<bool> isDraftAdded = ValueNotifier(false);
  List categoryList = [];
  List affirmationList = [];

  int perPageCount = 100;
  ValueNotifier selectedCategory = ValueNotifier(null);
  List<bool> like = [];
  List<bool> likeAffirmation = [];
  List? _filteredBookmarks;

  bool am = true;
  bool pm = false;
  Duration selectedDuration = const Duration(hours: 0, minutes: 0, seconds: 0);
  int selectedHour = 0;
  int selectedHourIndex = 0;
  int selectedMinute = 0;
  int selectedSeconds = 0;
  bool soundMute = false;
  bool playPause = false;
  final String audioFilePath = 'assets/audio/audio.mp3';
  AffirmationModel affirmationModel = AffirmationModel();
  AffirmationCategoryModel affirmationCategoryModel = AffirmationCategoryModel();
  AffirmationDataModel affirmationDataModel = AffirmationDataModel();
  bool loader = false;
  List<AffirmationData>? data;
  DateTime todayDate = DateTime.now();
  AlarmModel alarmModel = AlarmModel();
  File i = File("");
  Animation<double>? animation;
  AnimationController? animationController;
  DateTime? picked;
  var affirmationDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  checkInternet() async {
    if (await isConnected()) {
      getData();
    } else {
      showSnackBarError(context, "noInternet".tr);
    }
  }

  getData() async {
    await getAffirmationYour(affirmationDate);
    await getAffirmationData();
    await getCategoryAffirmation();
  }

  void _onAddClick(BuildContext context) {
    String subscriptionStatus = "SUBSCRIBED";
    if (!(subscriptionStatus == "SUBSCRIBED" ||
        subscriptionStatus == "SUBSCRIBED")) {
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const AddAffirmationPage(
            isFromMyAffirmation: true,
            isEdit: false,
          );
        },
      )).then(
        (value) async {
          await getAffirmationYour(affirmationDate);
          setState(() {});
        },
      );
    }
  }

  searchBookmarks(String query, List bookmarks) {
    return bookmarks
        .where((bookmark) =>
            bookmark.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }


  getAffirmationAlarm() async {
    alarmModel = AlarmModel();
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}get-alarm?created_by=${PrefService.getString(PrefKey.userId)}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      alarmModel = alarmModelFromJson(responseBody);
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  getAffirmationYour(date) async {
    setState(() {
      loader = false;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.getYourAffirmation}${PrefService.getString(PrefKey.userId)}&isDefault=false&date=$date'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      affirmationModel = affirmationModelFromJson(responseBody);
      if (affirmationModel.data != null) {
        for (int i = 0; i < affirmationModel.data!.length; i++) {
          like.add(affirmationModel.data![i].isLiked!);
          // likeAffirmation.add(affirmationModel.data![i].userLiked!);
        }
      }
      loader = false;
      setState(() {});
    } else {
      affirmationModel = AffirmationModel();
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
  }

  createAlarm(id, String? title, String? des) async {
    setState(() {
      loader == true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('POST', Uri.parse(EndPoints.addAlarm));
    request.body = json.encode({
      "hours": selectedHour,
      "minutes": selectedMinute,
      "seconds": selectedSeconds,
      "time": am == true ? "AM" : "PM",
      "affirmationId": id,
      "created_by": PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      selectedSeconds = 0;
      selectedMinute = 0;
      selectedHour = 0;
      setState(() {
        loader == false;
      });

      debugPrint(await response.stream.bytesToString());
      showSnackBarSuccess(context, "alarmSet".tr);
      Get.back();
    } else {
      selectedSeconds = 0;
      selectedMinute = 0;
      selectedHour = 0;
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message ?? "alarmAlreadySet".tr);
      Get.back();

      setState(() {
        loader == false;
      });

      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader == false;
    });
  }

  getCategoryListAffirmation() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.categoryAffirmation}${selectedCategory.value["title"]}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();

      affirmationDataModel = affirmationDataModelFromJson(responseBody);
      setState(() {
        _filteredBookmarks = affirmationDataModel.data;
        for (int i = 0; i < _filteredBookmarks!.length; i++) {
          like.add(_filteredBookmarks![i].isLiked);
          likeAffirmation.add(_filteredBookmarks![i].userLiked);
        }
      });
    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  getCategoryAffirmation() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET', Uri.parse('${EndPoints.baseUrl}${EndPoints.getCategory}1'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      affirmationCategoryModel = affirmationCategoryModelFromJson(responseBody);
      categoryList.add({"title": "All"});
      for (int i = 0; i < affirmationCategoryModel.data!.length; i++) {
        categoryList.add({"title": affirmationCategoryModel.data![i].name});
      }

      setState(() {
        loader = false;
    });

    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  getAffirmationData() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.getAffirmation}&userId=${PrefService.getString(PrefKey.userId)}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();

      affirmationDataModel = affirmationDataModelFromJson(responseBody);
      _filteredBookmarks = affirmationDataModel.data;
      for (int i = 0; i < _filteredBookmarks!.length; i++) {
        // like.add(_filteredBookmarks![i].isLiked);
        likeAffirmation.add(_filteredBookmarks![i].userLiked);
      }
      setState(() {});
    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  CommonModel commonModel = CommonModel();
  addAffirmation({String? title, String? des}) async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(EndPoints.addAffirmation));
    request.fields.addAll({
      'created_by': PrefService.getString(PrefKey.userId),
      'name': title!,
      'description': des!
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      showSnackBarSuccess(context, "successfullyAddedAffirmation".tr);
      setState(() {});
    } else {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message ?? "");

      debugPrint(response.reasonPhrase);
    }
  }

  updateLike({String? id, bool? isLiked}) async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('POST',
        Uri.parse('${EndPoints.baseUrl}${EndPoints.updateAffirmation}$id'));
    request.body = json.encode({"isLiked": isLiked});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
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
    setState(() {
      loader = false;
    });
  }

  updateAffirmationLike({String? id, bool? isLiked}) async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));

    request.fields.addAll({'isLike': "$isLiked", 'affirmationId': "$id"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
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
    setState(() {
      loader = false;
    });
  }

  deleteAffirmation(id) async {

    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('DELETE',
        Uri.parse('${EndPoints.baseUrl}${EndPoints.deleteAffirmation}$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      affirmationList = [];
      // showSnackBarSuccess(context, "Affirmation Deleted");
      setState(() {
        loader = false;
      });
    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
  }

  VoiceController? voiceController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: _currentTabIndex == 1
          ? const SizedBox()
          : GestureDetector(
              onTap: () {
                datePicker(context);
              },
              child: Container(
                height: 50,
                width: 50,
          decoration: const BoxDecoration(
              color: ColorConstant.themeColor, shape: BoxShape.circle),
          child:
              Center(child: SvgPicture.asset(ImageConstant.calenderGratitude)),
        ),
      ),
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        showBack: true,
        title:
            _currentTabIndex == 0 ? "yourAffirmation".tr : "myAffirmation".tr,
        action: (_isLoading)
            ? const Offstage()
            : Padding(
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
      ),
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Dimens.d100),
                      child: SvgPicture.asset(
                          themeController.isDarkMode.isTrue
                              ? ImageConstant.profile1Dark
                              : ImageConstant.profile1),
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.d120),
                      child: SvgPicture.asset(
                          themeController.isDarkMode.isTrue
                              ? ImageConstant.profile2Dark
                              : ImageConstant.profile2),
                    )),
                LayoutContainer(
                  vertical: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Dimens.d13.spaceHeight,
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              getAffirmationYour(affirmationDate);
                              setState(() {
                                _currentTabIndex = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d28),
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
                                  "yourAffirmation".tr,
                                  style: Style.nunRegular(
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
                                selectedCategory = ValueNotifier(null);
                                _currentTabIndex = 1;
                                getAffirmationData();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d40),
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
                                  "affirmation".tr,
                                  style: Style.nunRegular(
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
                        ],
                      ),
                      Dimens.d16.spaceHeight,
                      const DividerWidget(),
                      Dimens.d20.spaceHeight,
                      _getTabListOfGoals(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          loader == true ? commonLoader() : const SizedBox()
        ],
      ),
    );
  }

  Widget _getTabListOfGoals() {
    if (_currentTabIndex == 0) {
      return yourAffirmationWidget();
    } else {
      return transformAffirmationWidget();
    }
  }

  Widget yourAffirmationWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: (affirmationModel.data ?? []).isEmpty
            ? Center(
                child:     Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(themeController.isDarkMode.isTrue
                          ? ImageConstant.darkData
                          : ImageConstant.noData),
                      Text("dataNotFound".tr,style: Style.gothamMedium(
                          fontSize: 24,fontWeight: FontWeight.w700),),

                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          affirmationDate ==
                                  DateFormat('dd/MM/yyyy')
                                      .format(DateTime.now())
                              ? "todayAffirmation".tr
                              : selectedDate,
                          style: Style.nunitoBold(
                            fontSize: Dimens.d18,
                          )),
                      affirmationDate !=
                              DateFormat('dd/MM/yyyy').format(DateTime.now())
                          ? GestureDetector(
                              onTap: () async {
                                setState(() {
                                  affirmationDate = DateFormat('dd/MM/yyyy')
                                      .format(DateTime.now());
                                });
                                await getAffirmationYour(affirmationDate);
                              },
                              child: Icon(
                                Icons.clear,
                                size: 25,
                                color: themeController.isDarkMode.isTrue
                                    ? Colors.white
                                    : Colors.black,
                              ))
                          : const SizedBox()
                    ],
                  ),
                  Dimens.d20.spaceHeight,
                  ListView.builder(
                    itemCount: affirmationModel.data?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return HomeMessagePage(
                                  motivationalMessage: affirmationModel
                                          .data?[index].description ??
                                      "Believe in yourself, even when doubt creeps in. Today's progress is a step towards your dreams.");
                            },
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: Dimens.d16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.d11, vertical: Dimens.d11),
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode.isTrue
                                ? ColorConstant.textfieldFillColor
                                : ColorConstant.white,
                            borderRadius: Dimens.d16.radiusAll,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      affirmationModel.data?[index].name ?? '',
                                      style: Style.nunMedium(
                                              height: Dimens.d1_3.h,
                                              fontSize: Dimens.d18,
                                              color: themeController
                                                      .isDarkMode.isTrue
                                                  ? ColorConstant.white
                                                  : Colors.black)
                                          .copyWith(wordSpacing: Dimens.d4),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: PopupMenuButton(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      color: themeController.isDarkMode.isTrue
                                          ? const Color(0xffE8F4F8)
                                          : ColorConstant.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          ImageConstant.moreVert,
                                          color: ColorConstant.colorD9D9D9,
                                        ),
                                      ),
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                      builder: (context) {
                                                        return AddAffirmationPage(
                                                          index: index,
                                                          id: affirmationModel
                                                                  .data?[index]
                                                                  .id ??
                                                              "",
                                                          isFromMyAffirmation:
                                                              true,
                                                          title:
                                                              affirmationModel
                                                                      .data?[
                                                                          index]
                                                                      .name ??
                                                                  "",
                                                          isEdit: true,
                                                          des: affirmationModel
                                                                  .data?[index]
                                                                  .description ??
                                                              "",
                                                        );
                                                      },
                                                    )).then(
                                                      (value) async {
                                                        await getAffirmationYour(
                                                            affirmationDate);

                                                        setState(() {});
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    width: 86,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: ColorConstant
                                                          .color5B93FF
                                                          .withOpacity(0.05),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Dimens.d5.spaceWidth,
                                                        SvgPicture.asset(
                                                          ImageConstant
                                                              .editTools,
                                                          color: ColorConstant
                                                              .color5B93FF,
                                                        ),
                                                        Dimens.d5.spaceWidth,
                                                        Text(
                                                          'edit'.tr,
                                                          style:
                                                              Style.nunMedium(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorConstant
                                                                .color5B93FF,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Dimens.d15.spaceHeight,
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    _showAlertDialogDelete(
                                                        context,
                                                        index,
                                                        affirmationModel
                                                                .data?[index]
                                                                .id ??
                                                            "");
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    width: 86,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: ColorConstant
                                                          .colorE71D36
                                                          .withOpacity(0.05),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Dimens.d5.spaceWidth,
                                                        SvgPicture.asset(
                                                          ImageConstant.delete,
                                                          color: ColorConstant
                                                              .colorE71D36,
                                                        ),
                                                        Dimens.d5.spaceWidth,
                                                        Text(
                                                          'delete'.tr,
                                                          style:
                                                              Style.nunMedium(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorConstant
                                                                .colorE71D36,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ];
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Dimens.d10.spaceHeight,
                              Text(
                                affirmationModel.data?[index].description ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: Style.nunRegular(
                                    height: Dimens.d2,
                                    fontSize: Dimens.d11,
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : Colors.black),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Dimens.d10.spaceHeight,
                  affirmationDate ==
                          DateFormat('dd/MM/yyyy').format(DateTime.now())
                      ? GestureDetector(
                          onTap: () {
                     Get.off(StartPracticeAffirmation(
                       id: affirmationModel.data?[0].id,
                       data: affirmationModel.data,
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
                  Dimens.d80.spaceHeight,

                ],
              ),
      ),
    );
  }

  Widget transformAffirmationWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Dimens.d5.spaceHeight,
            Row(
              children: [
                _buildCategoryDropDown(context),
                Dimens.d20.spaceWidth,
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: CommonTextField(
                      hintText: "search".tr,
                      controller: searchController,
                      focusNode: searchFocus,
                      prefixLottieIcon: ImageConstant.lottieSearch,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          ImageConstant.search,
                          color: ColorConstant.themeColor,
                        ),
                      ),
                      suffixIcon: searchController.text.isEmpty
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    searchFocus.unfocus();

                                    searchController.clear();
                              setState(() {
                                _filteredBookmarks =
                                    affirmationDataModel.data;
                              });
                            },
                            child:
                            SvgPicture.asset(ImageConstant.close)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _filteredBookmarks = searchBookmarks(
                              value, affirmationDataModel.data!);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Dimens.d20.spaceHeight,

            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: (_filteredBookmarks ?? []).isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredBookmarks?.length ?? 0,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return HomeMessagePage(
                                    motivationalMessage: _filteredBookmarks?[
                                                index]
                                            .description ??
                                        "Believe in yourself, even when doubt creeps in. Today's progress is a step towards your dreams.");
                              },
                            ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: Dimens.d16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.d11, vertical: Dimens.d11),
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.textfieldFillColor
                                  : ColorConstant.white,
                              borderRadius: Dimens.d16.radiusAll,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _filteredBookmarks?[index].name ?? '',
                                        style: Style.nunMedium(
                                                height: Dimens.d1_3.h,
                                                fontSize: Dimens.d18,
                                                color: themeController
                                                        .isDarkMode.isTrue
                                                    ? ColorConstant.white
                                                    : Colors.black)
                                            .copyWith(wordSpacing: Dimens.d4),
                                        maxLines: 1,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await addAffirmation(
                                            title:
                                                _filteredBookmarks?[index].name,
                                            des: _filteredBookmarks?[index]
                                                .description);

                                        setState(() {});
                                      },
                                      child: SvgPicture.asset(
                                          ImageConstant.addAffirmation,
                                          height: 20,
                                          width: 20,
                                          color:
                                              themeController.isDarkMode.isTrue
                                                  ? ColorConstant.white
                                                  : ColorConstant.black),
                                    ),
                                    Dimens.d10.spaceWidth,
                                  ],
                                ),
                                Dimens.d10.spaceHeight,
                                Text(
                                  _filteredBookmarks?[index].description ?? '',
                                  style: Style.nunRegular(
                                          height: Dimens.d2,
                                          fontSize: Dimens.d11,
                                          color:
                                              themeController.isDarkMode.isTrue
                                                  ? ColorConstant.white
                                                  : Colors.black)
                                      .copyWith(wordSpacing: Dimens.d4),
                                  maxLines: 4,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child:    Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(themeController.isDarkMode.isTrue
                              ? ImageConstant.darkData
                              : ImageConstant.noData),
                          Text("dataNotFound".tr,style: Style.gothamMedium(
                              fontSize: 24,fontWeight: FontWeight.w700),),

                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context, id,
      {String? title, String? des, int? index}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: themeController.isDarkMode.isTrue
                  ? ColorConstant.textfieldFillColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              actions: <Widget>[
                Dimens.d18.spaceHeight,
                Row(
                  children: [
                    Text(
                      "newAlarms".tr,
                      style: Style.nunRegular(fontSize: 20),
                    ),
                    const Spacer(),
                    Container(
                      height: 26,
                      width: Dimens.d100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: ColorConstant.colorBFBFBF)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState.call(() {
                                am = true;
                                pm = false;
                                selectedSeconds =0;
                                selectedMinute =0;
                                selectedHour =0;
                              });
                            },
                            child: Container(
                                width: Dimens.d49,
                                decoration: BoxDecoration(
                                    color: am == true
                                        ? ColorConstant.themeColor
                                        : ColorConstant.white,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Center(
                                  child: Text(
                                    "AM",
                                    style: Style.nunRegular(
                                        fontSize: 12,
                                        color: am == true
                                            ? ColorConstant.white
                                            : ColorConstant.black),
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState.call(() {
                                selectedHour = 0;
                                selectedMinute = 0;
                                selectedSeconds = 0;
                                am = false;
                                pm = true;
                              });
                            },
                            child: Container(
                                height: 26,
                                width: Dimens.d49,
                                decoration: BoxDecoration(
                                    color: pm == true
                                        ? ColorConstant.themeColor
                                        : ColorConstant.white,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Center(
                                  child: Text(
                                    "PM",
                                    style: Style.nunRegular(
                                        fontSize: 12,
                                        color: pm == true
                                            ? ColorConstant.white
                                            : ColorConstant.black),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Dimens.d10.spaceHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "hours".tr,
                      style: Style.nunRegular(fontSize: 12),
                    ),
                    Text(
                      "minutes".tr,
                      style: Style.nunRegular(fontSize: 12),
                    ),
                    Text(
                      "seconds".tr,
                      style: Style.nunRegular(fontSize: 12),
                    ),
                  ],
                ),
                Dimens.d10.spaceHeight,
                Row(
                  children: [
                    NumberPicker(
                      zeroPad: true,
                      value: selectedHour,
                      minValue: 0,
                      textStyle: Style.nunRegular(
                          fontSize: 14, color: ColorConstant.colorCACACA),
                      selectedTextStyle: Style.montserratBold(
                          fontSize: 22, color: ColorConstant.themeColor),
                      maxValue: am==true ? 11 : 23,
                      itemHeight: 50,
                      itemWidth: 50,
                      onChanged: (value) =>
                          setState(() => selectedHour = value),
                    ),
                    const Spacer(),
                    numericSymbol(),
                    const Spacer(),
                    NumberPicker(
                      zeroPad: true,
                      value: selectedMinute,
                      minValue: 0,
                      itemHeight: 50,
                      itemWidth: 50,
                      textStyle: Style.nunRegular(
                          fontSize: 14, color: ColorConstant.colorCACACA),
                      selectedTextStyle: Style.montserratBold(
                          fontSize: 22, color: ColorConstant.themeColor),
                      maxValue: 59,
                      onChanged: (value) =>
                          setState(() => selectedMinute = value),
                    ),
                    const Spacer(),
                    numericSymbol(),
                    const Spacer(),
                    NumberPicker(
                      zeroPad: true,
                      value: selectedSeconds,
                      minValue: 0,
                      itemHeight: 50,
                      itemWidth: 50,
                      textStyle: Style.nunRegular(
                          fontSize: 14, color: ColorConstant.colorCACACA),
                      selectedTextStyle: Style.montserratBold(
                          fontSize: 22, color: ColorConstant.themeColor),
                      maxValue: 59,
                      onChanged: (value) =>
                          setState(() => selectedSeconds = value),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const AudioList();
                      },
                    ));
                  },
                  child: Container(
                    height: Dimens.d51,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: ColorConstant.backGround,
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Dimens.d14.spaceWidth,
                        Text(
                          "sound".tr,
                          style: Style.nunRegular(fontSize: 14),
                        ),
                        const Spacer(),
                        Text(
                          "default".tr,
                          style: Style.nunRegular(
                              fontSize: 14, color: ColorConstant.color787878),
                        ),
                        SvgPicture.asset(
                          ImageConstant.settingArrowRight,
                          color: ColorConstant.color787878,
                        ),
                        Dimens.d14.spaceWidth,
                      ],
                    ),
                  ),
                ),
                Dimens.d20.spaceHeight,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
                  child: CommonElevatedButton(
                    textStyle: Style.nunRegular(
                        fontSize: Dimens.d12, color: ColorConstant.white),
                    title: "save".tr,
                    onTap: () async {
                      /*final alarmSettings = AlarmSettings(
                          id:index!+1,
                          dateTime: DateTime.now().add(const Duration(seconds: 20)),
                          assetAudioPath: 'assets/audio/audio.mp3',
                          loopAudio: true,
                          vibrate: true,
                          volume: 0.8,androidFullScreenIntent: true,
                          fadeDuration: 3.0,
                          notificationTitle: title!,
                          notificationBody: des!,
                          enableNotificationOnKill: Platform.isAndroid);
                      await Alarm.set(alarmSettings: alarmSettings,);*/
                      await createAlarm(id, title, des);

                      //await getAffirmationAlarm();
                    },
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _showAlertDialogDelete(BuildContext context, int index, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: themeController.isDarkMode.isTrue
              ? ColorConstant.textfieldFillColor
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Dimens.d18.spaceHeight,
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SvgPicture.asset(
                          ImageConstant.close,
                          color: themeController.isDarkMode.isTrue
                              ? ColorConstant.white
                              : ColorConstant.black,
                        ),
                      ))),
              Dimens.d27.spaceHeight,
              Center(
                  child: SvgPicture.asset(
                ImageConstant.deleteAffirmation,
                height: Dimens.d96,
                width: Dimens.d96,
              )),
              Dimens.d26.spaceHeight,
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                      textAlign: TextAlign.center,
                      "areYouSureDeleteAffirmation".tr,
                      style: Style.nunRegular(
                        fontSize: Dimens.d14,
                      )),
                ),
              ),
              Dimens.d24.spaceHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  CommonElevatedButton(
                    height: 33,
                    width: 94,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: Dimens.d28),
                    textStyle: Style.nunRegular(
                        fontSize: Dimens.d12, color: ColorConstant.white),
                    title: "delete".tr,
                    onTap: () async {
                      Get.back();
                      await deleteAffirmation(id);
                      await getAffirmationYour(affirmationDate);
                      setState(() {});
                    },
                  ),
                  Dimens.d20.spaceWidth,
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 33,
                      width: 93,
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
                          style: Style.nunRegular(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Dimens.d20.spaceHeight,
            ],
          ),
        );
      },
    );
  }

  Widget numericSymbol() {
    return Text(":",
        style: Style.montserratBold(
            fontSize: 22, color: ColorConstant.themeColor));
  }

/*  void _showAlertDialogPlayPause(BuildContext context,
      {String? title, String? des, String? mp3}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              backgroundColor: ColorConstant.backGround,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              content: SizedBox(
                height: Dimens.d120,
                width: Get.width,
                child: Column(
                  children: [
                    Dimens.d14.spaceHeight,
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Dimens.d20.spaceWidth,
                          Text(
                            "Audio".tr,
                            style: Style.cormorantGaramondBold(fontSize: 20),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () {
                                journalController.pause();
                                journalController
                                    .isPlaying.value = false;
                                journalController.update();
                                setState.call((){});
                                Get.back();
                              },
                              child: SvgPicture.asset(ImageConstant.close)),
                          Dimens.d20.spaceWidth,
                        ],
                      ),
                    ),
                    Dimens.d15.spaceHeight,
                    Container(
                      height: Dimens.d46,
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorConstant.white),
                      child: Row(
                        children: [
                          Dimens.d10.spaceWidth,
                        GetBuilder<JournalController>(builder: (controller) {
                          return   Container(
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorConstant.themeColor,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (journalController.isPlaying.isTrue) {
                                    journalController.pause();
                                    journalController.update();
                                  } else {
                                    journalController.play();
                                    journalController.update();
                                  }
                                  setState(() {
                                    journalController
                                        .isPlaying.value =
                                    !journalController
                                        .isPlaying.value;
                                    journalController.update();
                                  });
                                  journalController.update();
                                  setState.call((){});
                                },
                                child: SvgPicture.asset(
                                  journalController.isPlaying.isTrue
                                      ? ImageConstant.pauseAudio
                                      : ImageConstant.play,
                                  height: 10,
                                  width: 10,
                                  color: ColorConstant.black,
                                ),
                              ),
                            ),
                          );
                        },),
                          StreamBuilder<Duration?>(
                            stream:
                                journalController.audioPlayer.positionStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data ?? Duration.zero;
                              return StreamBuilder<Duration?>(
                                stream: journalController
                                    .audioPlayer.durationStream,
                                builder: (context, snapshot) {
                                  final duration =
                                      snapshot.data ?? Duration.zero;
                                  return Slider(
                                    min: 0.0,
                                    max: duration.inMilliseconds.toDouble(),
                                    activeColor: ColorConstant.themeColor,
                                    onChanged: (double value) {
                                      journalController.seekForMeditationAudio(
                                          position: Duration(milliseconds: value.round()));
                                    },
                                    value: min(position.inMilliseconds.toDouble(),
                                       duration.inMilliseconds.toDouble()),
                                  );
                                },
                              );
                            },
                          ),
                          GestureDetector(
                              onTap: () async {
                                setState.call(() {
                                  soundMute = !soundMute;
                                });
                                if (soundMute) {
                                  journalController.audioPlayer.setVolume(0);

                                } else {
                                  journalController.audioPlayer.setVolume(1);
                                }
                              },
                              child: SvgPicture.asset(
                                soundMute
                                    ? ImageConstant.soundMute
                                    : ImageConstant.soundMax,
                                height: Dimens.d22,
                                width: Dimens.d22,
                              )),
                          Dimens.d10.spaceWidth,
                        ],
                      ),
                    ),
                    Dimens.d10.spaceHeight,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }*/

  Widget _buildCategoryDropDown(BuildContext context) {
    return Expanded(
      child: Container(
        height: 38,
        decoration: BoxDecoration(
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
              if (selectedCategory.value["title"] == "All") {
                await getAffirmationData();
              } else {
                await getCategoryListAffirmation();
              }
              setState(() {});
            }
          },
          selectedItemBuilder: (_) {
            return categoryList.map<Widget>((item) {
              bool isSelected =
                  selectedCategory.value?["title"] == item["title"];
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    item["title"] ?? '',
                    maxLines: 1,
                    style: Style.nunRegular(
                      fontSize: Dimens.d12,
                      color: Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList();
          },
          style: Style.nunRegular(
            fontSize: Dimens.d12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          hint: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "selectCategory".tr,
              style:
                  Style.nunRegular(fontSize: Dimens.d14, color: Colors.white),
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
          dropdownColor: themeController.isDarkMode.isTrue
              ? ColorConstant.textfieldFillColor
              : ColorConstant.white,
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
                    style: Style.nunRegular(
                      fontSize: Dimens.d14,
                      color: isSelected
                          ? ColorConstant.themeColor
                          : themeController.isDarkMode.isTrue
                              ? ColorConstant.white
                              : ColorConstant.black,
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

  datePicker(
    context,
  ) async {
    FocusScope.of(context).unfocus();
    picked = await showDatePicker(
      builder: (context, child) {
        TextStyle customTextStyle =
            Style.nunMedium(fontSize: 15, color: Colors.black);
        TextStyle editedTextStyle = customTextStyle.copyWith(
            color: Colors.red); // Define the edited text style
        TextStyle selectedDateTextStyle = Style.nunitoBold(
            fontSize: 15,
            color: themeController.isDarkMode.isTrue
                ? Colors.white
                : Colors.black); // Define the style for the selected date

        return Theme(
          data: ThemeData.light().copyWith(
              focusColor: ColorConstant.themeColor,
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
                bodyLarge: customTextStyle,
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
    );

    if (picked != null) {
      affirmationDate = DateFormat('dd/MM/yyyy').format(picked!);
      dateController.text = affirmationDate;
      setState(() {
        selectedDate = DateFormat('MMMM yyyy').format(picked!);
      });
      await getAffirmationYour(affirmationDate);
      setState(() {});
    }
  }

}
