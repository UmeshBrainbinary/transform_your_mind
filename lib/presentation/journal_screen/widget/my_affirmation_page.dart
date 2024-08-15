import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/shimmer_widget.dart';
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
import 'package:transform_your_mind/model_class/affirmation_list_all.dart';
import 'package:transform_your_mind/model_class/affirmation_model.dart';
import 'package:transform_your_mind/model_class/alarm_model.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/presentation/home_screen/home_message_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/journal_controller.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/start_audio_affirmation/start_audio_affirmation_screen.dart';
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
  AffirmationAllModel affirmationAllModel = AffirmationAllModel();
  List<AffirmationDataAll>? affirmationAllData;
bool isAudio = false;
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
  String lastMonthName = "";

  DateTime now = DateTime.now();
  String currentLanguage = PrefService.getString(PrefKey.language);

  @override
  void initState() {
    currentLanguage = PrefService.getString(PrefKey.language);
    DateTime lastMonth = DateTime(now.year, now.month - 1, 1);
    lastMonthName = DateFormat('MMMM yyyy').format(lastMonth);
    checkInternet();
    debugPrint("currentLanguage get $currentLanguage");
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
    await getAffirmationYour(DateFormat('dd/MM/yyyy').format(DateTime.now()));
    await getAffirmationYourAll();
    await getAffirmationData();
    await getCategoryAffirmation();
  }

  void _onAddClick(BuildContext context,{bool? record, String? des,String? id}) {
    String subscriptionStatus = "SUBSCRIBED";
    if (!(subscriptionStatus == "SUBSCRIBED" ||
        subscriptionStatus == "SUBSCRIBED")) {
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return  AddAffirmationPage(
            isFromMyAffirmation: true,
            isEdit: false,record: record!,
            des: des,
              id: id,
          );
        },
      )).then(
        (value) async {
          await getAffirmationYour(
              DateFormat('dd/MM/yyyy').format(DateTime.now()));
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
            '${EndPoints.baseUrl}get-alarm?created_by=${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));
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
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        // Uri.parse(
        //     '${EndPoints.baseUrl}${EndPoints.getYourAffirmation}${PrefService.getString(PrefKey.userId)}&isDefault=false&date=$date&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.getYourAffirmation}${PrefService.getString(PrefKey.userId)}&date=$date&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

        request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      affirmationModel = affirmationModelFromJson(responseBody);
       isAudio = false;
      affirmationModel.data!.forEach((e){

        if(e.audioFile != null)
        {
          isAudio =true;
          setState(() {

          });
        }
      });

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

  getAffirmationYourAll({String? affirmationDate}) async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    String url = "";
    if (affirmationDate != null) {
      url =
          '${EndPoints.baseUrl}${EndPoints.getYourAffirmation}${PrefService.getString(PrefKey.userId)}&isDefault=false&date=$affirmationDate&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}';
    } else {
      url =
          '${EndPoints.baseUrl}${EndPoints.getYourAffirmation}${PrefService.getString(PrefKey.userId)}&isDefault=false&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}';
    }
    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      affirmationAllModel = affirmationAllModelFromJson(responseBody);

      if (affirmationAllModel.data != null) {
        if (affirmationDate != null) {
          affirmationAllData = affirmationAllModel.data!;
        } else {
          final now = DateTime.now();
          final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
          final lastDayOfPreviousMonth =
              firstDayOfCurrentMonth.subtract(const Duration(days: 1));
          final firstDayOfPreviousMonth = DateTime(
              lastDayOfPreviousMonth.year, lastDayOfPreviousMonth.month, 1);

          affirmationAllData = affirmationAllModel.data
                  ?.where((element) =>
                      element.createdAt != null &&
                      element.createdAt!.isAfter(firstDayOfPreviousMonth) &&
                      element.createdAt!.isBefore(firstDayOfCurrentMonth))
                  .toList() ??
              [];
        }
      }
      loader = false;
      setState(() {});
      debugPrint("affirmation list previous month $affirmationAllData");
    } else {
      affirmationAllModel = AffirmationAllModel();
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
            '${EndPoints.baseUrl}${EndPoints.categoryAffirmation}${selectedCategory.value["title"]}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"} '));
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
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.getCategory}1&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      affirmationCategoryModel = affirmationCategoryModelFromJson(responseBody);
      categoryList.add({"title": "All"});
      for (int i = 0; i < affirmationCategoryModel.data!.length; i++) {
        categoryList.add({"title": affirmationCategoryModel.data![i].name});
      }
      loader = false;


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
            '${EndPoints.baseUrl}${EndPoints.getAffirmation}&userId=${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();

      affirmationDataModel = affirmationDataModelFromJson(responseBody);
      _filteredBookmarks = affirmationDataModel.data;


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
      'description': des??"",
      'lang': PrefService.getString(PrefKey.language).isEmpty
          ? "english"
          : PrefService.getString(PrefKey.language) != "en-US"
              ? "german"
              : "english"
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
                    _onAddClick(context,record: false,);
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
                              getAffirmationYour(DateFormat('dd/MM/yyyy')
                                  .format(DateTime.now()));
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
                      _affirmationsTabs(),
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

  Widget _affirmationsTabs() {
    if (_currentTabIndex == 0) {
      return yourAffirmationWidget();
    } else {
      return transformAffirmationWidget();
    }
  }

  Widget yourAffirmationWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("todayAffirmation".tr,
                style: Style.nunitoBold(
                  fontSize: Dimens.d18,
                )),

            if ((affirmationModel.data ?? []).isNotEmpty)
              Dimens.d20.spaceHeight,
            if ((affirmationModel.data ?? []).isEmpty) loader == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: shimmerCommon(),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "dataNotFound".tr,
                            style: Style.gothamMedium(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        ),
                  ) else ListView.builder(
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
                          child: Stack(alignment: Alignment.bottomRight,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      affirmationModel.data![index].description
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: Style.nunRegular(
                                          height: Dimens.d2,
                                          fontSize: Dimens.d15,
                                          color: themeController.isDarkMode.isTrue
                                              ? ColorConstant.white
                                              : Colors.black),
                                      maxLines: 2,
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
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset(
                                              ImageConstant.moreVert,
                                              color: ColorConstant.colorD9D9D9,
                                            ),
                                          ),

                                          affirmationModel.data?[index].audioFile == null?   GestureDetector(onTap: () {
                                            _onAddClick(context,record: true,des:  affirmationModel.data![index].description
                                                .toString(),id: affirmationModel
                                                .data?[index]
                                                .id ??
                                                "");

                                          },
                                              child: const Icon(Icons.mic_none_rounded,color: Colors.red,)):const SizedBox()
                                        ],
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
                                                          isFromMyAffirmation: true,
                                                          title: affirmationModel
                                                                  .data?[index]
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
                                                            DateFormat('dd/MM/yyyy')
                                                                .format(DateTime
                                                                    .now()));

                                                        setState(() {});
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    width: 86,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(5),
                                                      color: ColorConstant
                                                          .color5B93FF
                                                          .withOpacity(0.05),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Dimens.d5.spaceWidth,
                                                        SvgPicture.asset(
                                                          ImageConstant.editTools,
                                                          color: ColorConstant
                                                              .color5B93FF,
                                                        ),
                                                        Dimens.d5.spaceWidth,
                                                        Text(
                                                          'edit'.tr,
                                                          style: Style.nunMedium(
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
                                                                .data?[index].id ??
                                                            "");
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    width: 86,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(5),
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
                                                          style: Style.nunMedium(
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


                            ],
                          ),

                          /*affirmationModel.data![index].name
                                  .toString()
                                  .isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            affirmationModel
                                                .data![index].description
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: Style.nunRegular(
                                                height: Dimens.d2,
                                                fontSize: Dimens.d15,
                                                color: themeController
                                                        .isDarkMode.isTrue
                                                    ? ColorConstant.white
                                                    : Colors.black),
                                            maxLines: 2,
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
                                            color: themeController
                                                    .isDarkMode.isTrue
                                                ? const Color(0xffE8F4F8)
                                                : ColorConstant.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                ImageConstant.moreVert,
                                                color:
                                                    ColorConstant.colorD9D9D9,
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
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (context) {
                                                              return AddAffirmationPage(
                                                                index: index,
                                                                id: affirmationModel
                                                                        .data?[
                                                                            index]
                                                                        .id ??
                                                                    "",
                                                                isFromMyAffirmation:
                                                                    true,
                                                                title: affirmationModel
                                                                        .data?[
                                                                            index]
                                                                        .name ??
                                                                    "",
                                                                isEdit: true,
                                                                des: affirmationModel
                                                                        .data?[
                                                                            index]
                                                                        .description ??
                                                                    "",
                                                              );
                                                            },
                                                          )).then(
                                                            (value) async {
                                                              await getAffirmationYour(DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(DateTime
                                                                      .now()));

                                                              setState(() {});
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 28,
                                                          width: 86,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: ColorConstant
                                                                .color5B93FF
                                                                .withOpacity(
                                                                    0.05),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Dimens.d5
                                                                  .spaceWidth,
                                                              SvgPicture.asset(
                                                                ImageConstant
                                                                    .editTools,
                                                                color: ColorConstant
                                                                    .color5B93FF,
                                                              ),
                                                              Dimens.d5
                                                                  .spaceWidth,
                                                              Text(
                                                                'edit'.tr,
                                                                style: Style
                                                                    .nunMedium(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
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
                                                                      .data?[
                                                                          index]
                                                                      .id ??
                                                                  "");
                                                        },
                                                        child: Container(
                                                          height: 28,
                                                          width: 86,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: ColorConstant
                                                                .colorE71D36
                                                                .withOpacity(
                                                                    0.05),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Dimens.d5
                                                                  .spaceWidth,
                                                              SvgPicture.asset(
                                                                ImageConstant
                                                                    .delete,
                                                                color: ColorConstant
                                                                    .colorE71D36,
                                                              ),
                                                              Dimens.d5
                                                                  .spaceWidth,
                                                              Text(
                                                                'delete'.tr,
                                                                style: Style
                                                                    .nunMedium(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
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
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                       affirmationModel
                                                  .data![index].name ??
                                              '',
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
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(DateTime
                                                                    .now()));

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
                               affirmationModel.data![index].description
                                        .toString(),
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
                          ),*/
                        ),
                      );
                    },
                  ),
            if ((affirmationModel.data ?? []).isNotEmpty)
              Dimens.d10.spaceHeight,
            (affirmationModel.data ?? []).isNotEmpty
                ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: Dimens.d46,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      color: ColorConstant.themeColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(
                              "startPracticing".tr,
                                    style: Style.nunitoBold(
                                        fontSize: 16, color: ColorConstant.white),
                            )
                          ],
                        ),
                      Row(
                       children: [
                         isAudio?InkWell(
                             onTap:(){
                               Get.off(StartAudioAffirmationScreen(
                                           id: affirmationModel.data?[0].id,
                                           data: affirmationModel.data,
                                         ));
                             },
                             child: const Icon(Icons.keyboard_voice_rounded,size: 30,color:  ColorConstant.white,)):const SizedBox(),
                         const SizedBox(width: 10,),
                         InkWell(
                             onTap:(){
                               Get.off(StartPracticeAffirmation(
                                 id: affirmationModel.data?[0].id,
                                 data: affirmationModel.data,
                               ));
                             },
                             child: const Icon(Icons.text_fields_rounded,size: 30,color:  ColorConstant.white,)),
                       ],
                     ),
                      ],
                    ),
                  ),
                )
                : const SizedBox(),
            Dimens.d40.spaceHeight,
            //______________________________________ filter data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedDate.isNotEmpty ? selectedDate : lastMonthName,
                    style: Style.nunitoBold(
                      fontSize: Dimens.d18,
                    )),
                selectedDate.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          selectedDate = "";
                          await getAffirmationYourAll();

                          setState(() {});
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
            //______________________________________ affirmation all data last month data____________________________
            (affirmationAllData ?? []).isEmpty
                ? loader == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: shimmerCommon(),
                      )
                    : Center(
                        child: Text(
                          "dataNotFound".tr,
                          style: Style.gothamMedium(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                  )
                : ListView.builder(
                    itemCount: affirmationAllData?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return HomeMessagePage(
                                  motivationalMessage:
                                       affirmationAllData![index]
                                              .description
                                              .toString());
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
                          child: Text(
                            affirmationAllData![index].description ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Style.nunRegular(
                                height: Dimens.d2,
                                fontSize: Dimens.d15,
                                color: themeController.isDarkMode.isTrue
                                    ? ColorConstant.white
                                    : Colors.black),
                            maxLines: 2,
                          ), /*affirmationAllData![index].name!.isEmpty?Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(affirmationAllData![index].description ??
                                  '',
                                overflow: TextOverflow.ellipsis,
                                style: Style.nunRegular(
                                    height: Dimens.d2,
                                    fontSize: Dimens.d15,
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : Colors.black),
                                maxLines: 2,
                              ),
                            ],
                          ):Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text( affirmationAllData![index].name ??
                                              "",
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
                                ],
                              ),
                              Dimens.d10.spaceHeight,
                              Text(affirmationAllData![index].description ??
                                        '',
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
                          ),*/
                        ),
                      );
                    },
                  ),

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
                      maxLines: 1,
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
                                    motivationalMessage:   _filteredBookmarks![
                                                index]
                                            .description );
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
                            child: _filteredBookmarks?[index]
                                        ?.name
                                        ?.toString()
                                        .isEmpty ??
                                    true
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _filteredBookmarks![index]
                                                      .description ??
                                                  '',
                                              style: Style.nunRegular(
                                                      height: Dimens.d2,
                                                      fontSize: Dimens.d14,
                                                      color: themeController
                                                              .isDarkMode.isTrue
                                                          ? ColorConstant.white
                                                          : Colors.black)
                                                  .copyWith(
                                                      wordSpacing: Dimens.d4),
                                              maxLines: 4,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await addAffirmation(
                                                  title: currentLanguage ==
                                                              "en-US" ||
                                                          currentLanguage == ""
                                                      ? _filteredBookmarks![
                                                              index]
                                                          .name
                                                      : _filteredBookmarks?[
                                                              index]
                                                          .gName,
                                                  des: currentLanguage ==
                                                              "en-US" ||
                                                          currentLanguage == ""
                                                      ? _filteredBookmarks![
                                                              index]
                                                          .description
                                                      : _filteredBookmarks?[
                                                              index]
                                                          .gDescription);

                                              setState(() {});
                                            },
                                            child: SvgPicture.asset(
                                                ImageConstant.addAffirmation,
                                                height: 20,
                                                width: 20,
                                                color: themeController
                                                        .isDarkMode.isTrue
                                                    ? ColorConstant.white
                                                    : ColorConstant.black),
                                          ),
                                          Dimens.d10.spaceWidth,
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(_filteredBookmarks![index].name,
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
                                                  title: currentLanguage ==
                                                              "en-US" ||
                                                          currentLanguage == ""
                                                      ? _filteredBookmarks![
                                                              index]
                                                          .name
                                                      : _filteredBookmarks?[
                                                              index]
                                                          .gName,
                                                  des: currentLanguage ==
                                                              "en-US" ||
                                                          currentLanguage == ""
                                                      ? _filteredBookmarks![
                                                              index]
                                                          .description
                                                      : _filteredBookmarks?[
                                                              index]
                                                          .gDescription);

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
                                  _filteredBookmarks![index].description ?? '',
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
              Dimens.d8.spaceHeight,
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
                      await getAffirmationYour(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()));

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



  Widget _buildCategoryDropDown(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40,
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
      await getAffirmationYourAll(affirmationDate: affirmationDate);
      setState(() {});
    }
  }

}
