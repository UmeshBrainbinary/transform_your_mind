import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/custom_chip.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/select_focus_button.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/focus_model.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_affirmation_focus_page.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
class Tag {
  final String englishName;
  final String germanName;
  bool isSelected;

  Tag(this.englishName, this.germanName, this.isSelected);
}

class SelectYourFocusPage extends StatefulWidget {
  SelectYourFocusPage({super.key, required this.isFromMe, this.setting});
  static const selectFocus = '/selectFocus';

  final bool isFromMe;
  bool? setting;

  @override
  State<SelectYourFocusPage> createState() => _SelectYourFocusPageState();
}

class _SelectYourFocusPageState extends State<SelectYourFocusPage> {
  List<Tag> listOfTags = [];
  List<String> tempData = [];
  bool loader = false;

  List<String> selectedTagNames = [];

  ThemeController themeController = Get.find<ThemeController>();
  FocusesModel focusesModel = FocusesModel();
  String currentLanguage = PrefService.getString(PrefKey.language);

  getFocuses() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
      'GET',
      Uri.parse('${EndPoints.baseUrl}${EndPoints.getCategory}0'),
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      focusesModel = focusesModelFromJson(responseBody);

      for (int i = 0; i < focusesModel.data!.length; i++) {
        String englishName = focusesModel.data![i].name.toString();
        String germanName = focusesModel.data![i].gName.toString();
        bool isSelected = tempData.contains(englishName);
        listOfTags.add(Tag(englishName, germanName, isSelected));
      }

      for (int y = 0; y < listOfTags.length; y++) {
        if (listOfTags[y].isSelected == true) {
          selectedTagNames.add(listOfTags[y].englishName);
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

  setFocuses(setting) async {
    setState(() {
      loader = true;
    });
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.MultipartRequest('POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));
      request.fields.addAll({
        'focuses': jsonEncode(selectedTagNames)
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await PrefService.setValue(PrefKey.focuses, true);
        setState(() {
          loader = false;
        });
        if (setting == true) {
          showSnackBarSuccess(context, "yourFocusHasBeenSelected".tr);
          Get.back();
        } else {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return SelectYourAffirmationFocusPage(
                isFromMe: false,
                setting: false,
              );
            },
          ));
        }
      } else {
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
        Uri.parse("${EndPoints.getUser}${PrefService.getString(PrefKey.userId)}"),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getUserModel = getUserModelFromJson(responseBody);
        for (int i = 0; i < getUserModel.data!.focuses!.length; i++) {
          tempData.add(getUserModel.data!.focuses![i].toString());
        }
        debugPrint("selected past data from User $tempData");
        getFocuses();
        setState(() {
          loader = false;
        });
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
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
    if (await isConnected()) {
      await getUSer();
    } else {
      showSnackBarError(context, "noInternet".tr);
    }

    setState(() {});
  }

  void _onTagTap(Tag tag) {
    setState(() {
      tag.isSelected = !tag.isSelected;
      if (tag.isSelected) {
        selectedTagNames.add(tag.englishName);
      } else {
        selectedTagNames.remove(tag.englishName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.isTrue
              ? ColorConstant.darkBackground
              : ColorConstant.white,
          appBar: CustomAppBar(
            showBack: widget.setting,
            title: "selectYourFocus".tr,
            centerTitle: widget.setting! ? false : true,
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimens.d100),
                  child: SvgPicture.asset(themeController.isDarkMode.isTrue
                      ? ImageConstant.profile1Dark
                      : ImageConstant.profile1),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.d120),
                  child: SvgPicture.asset(themeController.isDarkMode.isTrue
                      ? ImageConstant.profile2Dark
                      : ImageConstant.profile2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                child: Column(
                  children: [
                    Dimens.d30.spaceHeight,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "chooseMinInterest".tr,
                        textAlign: TextAlign.center,
                        style: Style.nunRegular(
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black,
                          fontSize: Dimens.d16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Dimens.d30.spaceHeight,
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: listOfTags.map((tag) {
                              return GestureDetector(
                                onTap: () => _onTagTap(tag),
                                child: CustomChip(
                                  label: tag.germanName,
                                  isChipSelected: tag.isSelected,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    FocusSelectButton(
                      primaryBtnText: widget.isFromMe
                          ? "save".tr
                          : widget.setting! ? "save".tr : "next".tr,
                      secondaryBtnText: widget.isFromMe ? '' : "Skip",
                      isLoading: false,
                      primaryBtnCallBack: () {
                        if (selectedTagNames.isNotEmpty) {
                          setFocuses(widget.setting);
                        } else {
                          showSnackBarError(
                              context, 'Please5Focuses'.tr);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loader == true ? commonLoader() : const SizedBox(),
      ],
    );
  }
}