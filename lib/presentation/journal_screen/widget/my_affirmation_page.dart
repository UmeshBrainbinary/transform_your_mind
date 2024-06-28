import 'dart:convert';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
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
import 'package:transform_your_mind/model_class/affirmation_category_model.dart';
import 'package:transform_your_mind/model_class/affirmation_data_model.dart';
import 'package:transform_your_mind/model_class/affirmation_model.dart';
import 'package:transform_your_mind/model_class/alarm_model.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/affirmation_share_screen.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/audio_list.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/edit_affirmation_dialog_widget.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/app_confirmation_dialog.dart';
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

  //k-naveen
  bool _isLoading = false;
  int totalItemCountOfAffirmation = 0;
  int totalItemCountOfAffirmationDrafts = 0;
  TextEditingController searchController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  FocusNode searchFocus = FocusNode();

  int _currentTabIndex = 0;
  ValueNotifier<bool> isDraftAdded = ValueNotifier(false);
  List categoryList = [];
  List affirmationList = [];

  final TextEditingController _userAffirmationController =
      TextEditingController();
  final FocusNode _userAffirmationFocus = FocusNode();
  int perPageCount = 100;
  ValueNotifier selectedCategory = ValueNotifier(null);
  List<bool> like = [];
  List<bool> likeAffirmation = [];
  List? _filteredBookmarks;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround,
      statusBarIconBrightness: Brightness.dark,
    ));

    getData();

    super.initState();
  }

  getData() async {
    await getAffirmationData();
    await getAffirmation();

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
          await getAffirmation();
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
  AffirmationCategoryModel affirmationCategoryModel =
      AffirmationCategoryModel();
  AffirmationDataModel affirmationDataModel = AffirmationDataModel();
  bool loader = false;
  List<AffirmationData>? data;
  DateTime todayDate = DateTime.now();
  AlarmModel alarmModel = AlarmModel();
  PlayerController controller = PlayerController();                   // Initialise
  File  i = File("");

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

  getAffirmation() async {
    setState(() {
      loader = false;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.getYourAffirmation}${PrefService.getString(PrefKey.userId)}'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        showBack: true,
        title: "myAffirmation".tr,
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
                      child: SvgPicture.asset(ImageConstant.profile1),
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.d120),
                      child: SvgPicture.asset(ImageConstant.profile2),
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
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              getAffirmation();
                              setState(() {
                                _currentTabIndex = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d14),
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
                                  style: Style.montserratRegular(
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
                                  horizontal: Dimens.d34),
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
                                  style: Style.montserratRegular(
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
                          const Spacer(),
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
                child: SizedBox(
                  height: Get.height - 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        themeController.isDarkMode.isTrue?ImageConstant.darkData:ImageConstant
                            .noData,height: 158,width: 200,),
                      Text(
                        "dataNotFound".tr,
                        style: Style.montserratBold(fontSize: 24),
                      )
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("myAffirmation".tr,
                        style: Style.montserratRegular(
                          fontSize: Dimens.d18,
                        )),
                  ),
                  Dimens.d11.spaceHeight,
                  ListView.builder(
                    itemCount: affirmationModel.data?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return AffirmationShareScreen(
                                des:
                                    affirmationModel.data?[index].description ??
                                        "",
                                title: affirmationModel.data?[index].name ?? "",
                              );
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
                                      style: Style.montserratRegular(
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
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return AddAffirmationPage(
                                            index: index,
                                            id: affirmationModel
                                                    .data?[index].id ??
                                                "",
                                            isFromMyAffirmation: true,
                                            title: affirmationModel
                                                    .data?[index].name ??
                                                "",
                                            isEdit: true,
                                            des: affirmationModel
                                                    .data?[index].description ??
                                                "",
                                          );
                                        },
                                      )).then(
                                        (value) async {
                                          await getAffirmation();

                                          setState(() {});
                                        },
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      ImageConstant.editTools,
                                      height: 20,width: 20,
                                      color: themeController.isDarkMode.isTrue
                                          ? ColorConstant.white
                                          : ColorConstant.black,
                                    ),
                                  ),
                                  Dimens.d10.spaceWidth,
                                  GestureDetector(
                                    onTap: () {
                                      _showAlertDialogDelete(
                                          context,
                                          index,
                                          affirmationModel.data?[index].id ??
                                              "");
                                    },
                                    child: SvgPicture.asset(
                                      ImageConstant.delete,
                                      height: 20,width: 20,
                                      color: themeController.isDarkMode.isTrue
                                          ? ColorConstant.white
                                          : ColorConstant.black,
                                    ),
                                  ),
                                  Dimens.d10.spaceWidth,
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        like[index] = !like[index];
                                      });
                                      if (affirmationModel
                                          .data![index].isLiked!) {
                                        await updateLike(
                                            id: affirmationModel
                                                .data?[index].id,
                                            isLiked: false);
                                        await getAffirmation();
                                      } else {
                                        await updateLike(
                                            id: affirmationModel
                                                .data?[index].id,
                                            isLiked: true);
                                        await getAffirmation();
                                      }

                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(
                                      like[index]
                                          ? ImageConstant.likeRedTools
                                          : ImageConstant.likeTools,
                                      height: 20,width: 20,
                                      color: like[index]
                                          ? ColorConstant.deleteRed
                                          : themeController.isDarkMode.isTrue
                                              ? ColorConstant.white
                                              : ColorConstant.black,
                                    ),
                                  )
                                ],
                              ),
                              Dimens.d10.spaceHeight,
                              Text(
                                affirmationModel.data?[index].description ?? '',
                                style: Style.montserratRegular(
                                        height: Dimens.d2,
                                        fontSize: Dimens.d11,
                                        color: themeController.isDarkMode.isTrue
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
                  ),
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
            AutoSizeText(
              "transformYourMindAffirmation".tr,
              textAlign: TextAlign.center,
              style: Style.montserratRegular(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
            ),
            LayoutContainer(
              horizontal: 0,
              child: Row(
                children: [
                  _buildCategoryDropDown(context),
                  Dimens.d10.spaceWidth,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstant.colorBFD0D4.withOpacity(0.5),
                            blurRadius: 8.0,
                            spreadRadius: 0.5, // Spread the shadow slightly
                          ),
                        ],
                      ),
                      child: CommonTextField(
                        hintText: "search".tr,
                        controller: searchController,
                        focusNode: searchFocus,
                        prefixLottieIcon: ImageConstant.lottieSearch,
                        textInputAction: TextInputAction.done,
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
            ),
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
                                return AffirmationShareScreen(
                                  des: _filteredBookmarks?[index].description,
                                  title: _filteredBookmarks?[index].name,
                                );
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
                                        _filteredBookmarks?[index].name ?? '',
                                        style: Style.montserratRegular(
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
                                    GestureDetector(
                                      onTap: () async {
                                        var request = await http.get(Uri.parse("https://transformyourmind.s3.eu-north-1.amazonaws.com/1718799097841-1682952330-9588.mp3"));
                                        if (request.statusCode == 200) {
                                          String dir = (await getTemporaryDirectory()).path;
                                        File file = File('$dir/${DateTime.now().microsecondsSinceEpoch}.mp3');
                                        await file.writeAsBytes(request.bodyBytes);

                                        print(file.path);
                                        i = file;
                                        } else {

                                        }
                                        await controller.preparePlayer(
                                        path: i.path,
                                        shouldExtractWaveform: true,
                                        noOfSamples: 100,
                                        volume: 1.0,
                                        );
                                        await controller.startPlayer(finishMode: FinishMode.stop);          // Start audio player
                                        // Stop audio player
                                        await controller.setVolume(1.0);                                    // Set volume level
                                        await controller.seekTo(5000);                                 // Get duration of audio player
                                        controller.updateFrequency = UpdateFrequency.low;                   // Update reporting rate of current duration.
                                        controller.onPlayerStateChanged.listen((state) {});                 // Listening to player state changes
                                        controller.onCurrentDurationChanged.listen((duration) {});          // Listening to current duration changes
                                        controller.onCurrentExtractedWaveformData.listen((data) {});        // Listening to latest extraction data
                                        controller.onExtractionProgress.listen((progress) {});              // Listening to extraction progress
                                        controller.onCompletion.listen((_){});                              // Listening to audio completion

                                        _showAlertDialogPlayPause(context,
                                            mp3: _filteredBookmarks?[index]
                                                .audioFile,
                                            title:
                                                _filteredBookmarks?[index].name,
                                            des: _filteredBookmarks?[index]
                                                .description);
                                      },
                                      child: SvgPicture.asset(
                                        ImageConstant.playAffirmation,
                                        height: 20,
                                        width: 20,
                                        color: themeController.isDarkMode.isTrue
                                            ? ColorConstant.white
                                            : ColorConstant.black,
                                      ),
                                    ),
                                    Dimens.d10.spaceWidth,
                                    GestureDetector(
                                        onTap: () {
                                          _showAlertDialog(
                                              index: index,
                                              des: _filteredBookmarks?[index]
                                                  .description,
                                              context,
                                              title: _filteredBookmarks?[index]
                                                  .name,
                                              _filteredBookmarks?[index].id);
                                        },
                                        child: SvgPicture.asset(
                                          ImageConstant.alarm,height: 20,width: 20,
                                          color:
                                              themeController.isDarkMode.isTrue
                                                  ? ColorConstant.white
                                                  : ColorConstant.black,
                                        )),
                                    Dimens.d8.spaceWidth,
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          likeAffirmation[index] =
                                              !likeAffirmation[index];
                                        });
                                        if (_filteredBookmarks![index]
                                            .isLiked) {
                                          await updateAffirmationLike(
                                              id: _filteredBookmarks?[index].id,
                                              isLiked: false);
                                          await getAffirmationData();
                                        } else {
                                          await updateAffirmationLike(
                                              id: _filteredBookmarks?[index].id,
                                              isLiked: true);
                                          await getAffirmationData();
                                        }

                                        setState(() {});
                                      },
                                      child: SvgPicture.asset(
                                        likeAffirmation[index]
                                            ? ImageConstant.likeRedTools
                                            : ImageConstant.likeTools,
                                        height: 20,width: 20,
                                        color: likeAffirmation[index]
                                            ? ColorConstant.deleteRed
                                            : themeController.isDarkMode.isTrue
                                                ? ColorConstant.white
                                                : ColorConstant.black,
                                      ),
                                    )
                                  ],
                                ),
                                Dimens.d10.spaceHeight,
                                Text(
                                  _filteredBookmarks?[index].description ?? '',
                                  style: Style.montserratRegular(
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
                      child: SizedBox(
                        height: Get.height - 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              themeController.isDarkMode.isTrue?ImageConstant.darkData:ImageConstant
                                  .noData,height: 158,width: 200,),
                            Text(
                              "dataNotFound".tr,
                              style: Style.montserratBold(fontSize: 24),
                            )
                          ],
                        ),
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
              //backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              actions: <Widget>[
                Dimens.d18.spaceHeight,
                Row(
                  children: [
                    Text(
                      "newAlarms".tr,
                      style: Style.montserratRegular(fontSize: 20),
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
                                    style: Style.montserratRegular(
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
                                    style: Style.montserratRegular(
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
                      style: Style.montserratRegular(fontSize: 12),
                    ),
                    Text(
                      "minutes".tr,
                      style: Style.montserratRegular(fontSize: 12),
                    ),
                    Text(
                      "seconds".tr,
                      style: Style.montserratRegular(fontSize: 12),
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
                      textStyle: Style.montserratRegular(
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
                      textStyle: Style.montserratRegular(
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
                      textStyle: Style.montserratRegular(
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
                          style: Style.montserratRegular(fontSize: 14),
                        ),
                        const Spacer(),
                        Text(
                          "default".tr,
                          style: Style.montserratRegular(
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
                    textStyle: Style.montserratRegular(
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
                      color: themeController.isDarkMode.isTrue
                          ? ColorConstant.white
                          : ColorConstant.black,
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
                  "areYouSureDeleteAffirmation".tr,
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
                    Get.back();
                    await deleteAffirmation(id);
                    await getAffirmation();
                    setState(() {});
                  },
                ),
                GestureDetector( onTap: () {
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

  Widget numericSymbol() {
    return Text(":",
        style: Style.montserratBold(
            fontSize: 22, color: ColorConstant.themeColor));
  }

  void _showAlertDialogPlayPause(BuildContext context,
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
                          Container(
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstant.themeColor),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if(controller.playerState.isPlaying)
                                  {

                                    controller.pausePlayer();
                                  }
                                  else
                                  {
                                    controller.startPlayer();

                                  }
                                  setState(() {

                                  });

                                },
                                child: SvgPicture.asset(
                                  controller.playerState.isPlaying
                                      ? ImageConstant.pauseAudio
                                      : ImageConstant.play,
                                  height: 10,
                                  width: 10,
                                  color: ColorConstant.black,
                                ),
                              ),
                            ),
                          ),
                          /*  Dimens.d10.spaceWidth,
                          Text("0:32",style: Style.montserratRegular(fontSize: 11),),
                          Dimens.d10.spaceWidth,*/
                          /*VoiceMessageView(
                            size: 0.0,
                            controller: VoiceController(
                              audioSrc: mp3!,
                              onComplete: () {
                                /// do something on complete
                              },
                              onPause: () {
                                /// do something on pause
                              },
                              onPlaying: () {
                                /// do something on playing
                              },
                              maxDuration: const Duration(minutes: 5),
                              isFile: false,
                            ),
                            activeSliderColor: ColorConstant.themeColor,
                            innerPadding: 0.0,
                            cornerRadius: 0.0,
                            circlesColor: Colors.transparent,
                            circlesTextStyle: const TextStyle(fontSize: 0.0),
                            counterTextStyle: const TextStyle(fontSize: 0.0),
                          ),*/
                          Container(
                          height: 100,
                          width: 200,
                          color: Colors.red,
                          child:   AudioFileWaveforms(

                          size: Size(MediaQuery.of(context).size.width, 100.0),
                  playerController: controller,
                  enableSeekGesture: true,
                  waveformType: WaveformType.long,
                  waveformData: [],
                  playerWaveStyle: const PlayerWaveStyle(
                    fixedWaveColor: Colors.white54,
                    liveWaveColor: Colors.blueAccent,
                    spacing: 6,

                  ),

                ),
              ),
                          GestureDetector(
                              onTap: () {
                                setState.call(() {
                                  soundMute = !soundMute;
                                });
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
  }

  Widget _buildCategoryDropDown(BuildContext context) {
    return Expanded(
      child: Container(
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
              await getCategoryListAffirmation();
              setState(() {});
            }
          },
          selectedItemBuilder: (_) {
            return categoryList.map<Widget>((item) {
              bool isSelected =
                  selectedCategory.value?["title"] == item["title"];
              return Padding(
                padding: const EdgeInsets.only(left: 18, top: 17),
                child: Text(
                  item["title"] ?? '',
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




  void addUserAffirmation({bool isSave = true}) {
    if (_userAffirmationController.text.trim().isEmpty) {
      showSnackBarError(context, "pleaseEnterYourOwnAffirmation".tr);
      return;
    }

    _userAffirmationController.clear();
    _userAffirmationFocus.unfocus();
  }




}
