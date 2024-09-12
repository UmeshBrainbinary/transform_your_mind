import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/custom_chip.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/free_trial_page.dart';
import 'package:transform_your_mind/core/common_widget/select_focus_button.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/affirmation_model.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

import '../me_screen/screens/setting_screen/Page/notification_setting_screen/widget/reminder_time_utils.dart';

class Tag {
  final String nameEn;
  final String nameDe;
  bool isSelected;

  Tag(this.nameEn, this.nameDe, this.isSelected);
}

class SelectYourAffirmationFocusPage extends StatefulWidget {
  SelectYourAffirmationFocusPage({
    super.key,
    required this.isFromMe,
    this.setting,
  });

  final bool isFromMe;
  bool? setting;

  @override
  State<SelectYourAffirmationFocusPage> createState() =>
      _SelectYourAffirmationFocusPageState();
}

class _SelectYourAffirmationFocusPageState
    extends State<SelectYourAffirmationFocusPage> {
  List<Tag> listOfTags = [];
  List<String> tempData = [];
  String currentLanguage = PrefService.getString(PrefKey.language);

  List<String> selectedTagNames = [];
  ValueNotifier<String> selectedReminderTime = ValueNotifier('');
  ThemeController themeController = Get.find<ThemeController>();

  TextEditingController affirmationController = TextEditingController();

  ReminderTime? affirmationReminderTime;
  ReminderPeriod? affirmationReminderPeriod;
  AffirmationModel affirmationModel = AffirmationModel();
  bool loader = false;

  getAffirmation() async {
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

      affirmationModel = affirmationModelFromJson(responseBody);
      for (int i = 0; i < affirmationModel.data!.length; i++) {
        if (tempData.contains(affirmationModel.data![i].name)) {
          listOfTags.add(Tag(
              affirmationModel.data![i].name.toString(),
              affirmationModel.data![i].gName.toString(),
              true));
        } else {
          listOfTags.add(Tag(
              affirmationModel.data![i].name.toString(),
              affirmationModel.data![i].gName.toString(),
              false));
        }
      }
      for (int y = 0; y < listOfTags.length; y++) {
        if (listOfTags[y].isSelected == true) {
          selectedTagNames.add(listOfTags[y].nameEn);
        }
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

  GetUserModel getUserModel = GetUserModel();

  getUSer() async {
    setState(() {
      loader = true;
    });
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
        for (int i = 0; i < getUserModel.data!.affirmations!.length; i++) {
          tempData.add(getUserModel.data!.affirmations![i].toString());
        }
        await getAffirmation();
        setState(() {
          loader = false;
        });
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      debugPrint(e.toString());
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await getUSer();
    setState(() {});
  }

  void _onTagTap(Tag tag) {
    setState(() {
      tag.isSelected = !tag.isSelected;
      if (tag.isSelected) {
        selectedTagNames
            .add(currentLanguage == "en-US" || currentLanguage == "" ? tag.nameEn : tag.nameDe);
      } else {
        selectedTagNames
            .remove(currentLanguage == "en-US" || currentLanguage == ""? tag.nameEn : tag.nameDe);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.white,
      appBar: CustomAppBar(
        title: "selectYourAffirmationFocus".tr, // Set directly in English
      ),
      body: Stack(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
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
                children: [
                  Dimens.d30.spaceHeight,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AutoSizeText(
                      "chooseMinInterest".tr, // Set directly in English
                      textAlign: TextAlign.center,
                      style: Style.nunRegular(
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black,
                          fontSize: Dimens.d15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Dimens.d24.spaceHeight,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: listOfTags.map((tag) {
                              return GestureDetector(
                                onTap: () => _onTagTap(tag),
                                child: CustomChip(
                                  label: currentLanguage == "en-US" || currentLanguage == ""
                                      ? tag.nameEn
                                      : tag.nameDe, // Use English name
                                  isChipSelected: tag.isSelected,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Dimens.d20.spaceHeight,
                  FocusSelectButton(
                    primaryBtnText: widget.isFromMe
                        ? "Save" // Set directly in English
                        : widget.setting!
                            ? "Save" // Set directly in English
                            : "Next",
                    // Set directly in English
                    secondaryBtnText: widget.isFromMe ? '' : "Skip",
                    // Set directly in English
                    isLoading: false,
                    primaryBtnCallBack: () {
                      //getAffirmation();
                      if (selectedTagNames.isNotEmpty) {
                        setFocuses(widget.setting);
                      } else {
                        showSnackBarError(context,
                            'Please select at least 5 affirmations'); // Set directly in English
                      }
                    },
                  )
                ],
              ),
            ],
          ),
          loader == true ? commonLoader() : const SizedBox()
        ],
      ),
    );
  }

  CommonModel commonModel = CommonModel();

  setFocuses(bool? setting) async {
    setState(() {
      loader = true;
    });
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));
      request.fields.addAll({'affirmations': jsonEncode(selectedTagNames)});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await PrefService.setValue(PrefKey.affirmation, true);
        await getData();
        setState(() {
          loader = false;
        });
        if (setting == true) {
          showSnackBarSuccess(context,
              "yourAffirmationsSelected".tr); // Set directly in English
          Get.back();
        } else {
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) {
          //     return const FreeTrialPage();
          //   },
          // ));
        }
      } else {
        final responseBody = await response.stream.bytesToString();
        commonModel = commonModelFromJson(responseBody);
        setState(() {
          loader = false;
        });
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      debugPrint(e.toString());
    }
  }
}

