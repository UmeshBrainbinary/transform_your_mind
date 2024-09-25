import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/custom_chip.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/free_trial_page.dart';
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
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
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
      Uri.parse(
          '${EndPoints.baseUrl}${EndPoints.getCategory}0&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'),
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
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) {
          //     return SelectYourAffirmationFocusPage(
          //       isFromMe: false,
          //       setting: false,
          //     );
          //   },
          // ));
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const FreeTrialPage();
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
        selectedTagNames
            .add(currentLanguage == "en-US" || currentLanguage == "" ? tag.englishName : tag.germanName);
      } else {
        selectedTagNames.remove(
            currentLanguage == "en-US" || currentLanguage == "" ? tag.englishName : tag.germanName);
      }
    });
  }
  final audioPlayerController = Get.put(NowPlayingController());
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
                                  label: currentLanguage == "en-US" || currentLanguage == ""
                                      ? tag.englishName
                                      : tag.germanName,
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
              Obx(() {
                if (!audioPlayerController.isVisible.value) {
                  return const SizedBox.shrink();
                }

                final currentPosition =
                    audioPlayerController.positionStream.value ??
                        Duration.zero;
                final duration =
                    audioPlayerController.durationStream.value ??
                        Duration.zero;
                final isPlaying = audioPlayerController.isPlaying.value;

                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            Dimens.d24,
                          ),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return NowPlayingScreen(
                          audioData: audioDataStore!,
                        );
                      },
                    );
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 72,
                      width: Get.width,
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8, right: 8),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 50),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              ColorConstant.colorB9CCD0,
                              ColorConstant.color86A6AE,
                              ColorConstant.color86A6AE,
                            ], // Your gradient colors
                            begin: Alignment.bottomLeft,
                            end: Alignment.bottomRight,
                          ),
                          color: ColorConstant.themeColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CommonLoadImage(
                                  borderRadius: 6.0,
                                  url: audioDataStore!.image!,
                                  width: 47,
                                  height: 47),
                              Dimens.d12.spaceWidth,
                              GestureDetector(
                                  onTap: () async {
                                    if (isPlaying) {
                                      await audioPlayerController
                                          .pause();
                                    } else {
                                      await audioPlayerController
                                          .play();
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    isPlaying
                                        ? ImageConstant.pause
                                        : ImageConstant.play,
                                    height: 17,
                                    width: 17,
                                  )),
                              Dimens.d10.spaceWidth,
                              Expanded(
                                child: Text(
                                  audioDataStore!.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Style.nunRegular(
                                      fontSize: 12,
                                      color: ColorConstant.white),
                                ),
                              ),
                              Dimens.d10.spaceWidth,
                              GestureDetector(
                                  onTap: () async {
                                    await audioPlayerController.reset();
                                  },
                                  child: SvgPicture.asset(
                                    ImageConstant.closePlayer,
                                    color: ColorConstant.white,
                                    height: 24,
                                    width: 24,
                                  )),
                              Dimens.d10.spaceWidth,
                            ],
                          ),
                          Dimens.d8.spaceHeight,
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor:
                              ColorConstant.white.withOpacity(0.2),
                              inactiveTrackColor:
                              ColorConstant.color6E949D,
                              trackHeight: 1.5,
                              thumbColor: ColorConstant.transparent,
                              thumbShape: SliderComponentShape.noThumb,
                              overlayColor: ColorConstant.backGround
                                  .withAlpha(32),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius:
                                  16.0), // Customize the overlay shape and size
                            ),
                            child: SizedBox(
                              height: 2,
                              child: Slider(
                                thumbColor: Colors.transparent,
                                activeColor: ColorConstant.backGround,
                                value: currentPosition.inMilliseconds
                                    .toDouble(),
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  audioPlayerController
                                      .seekForMeditationAudio(
                                      position: Duration(
                                          milliseconds:
                                          value.toInt()));
                                },
                              ),
                            ),
                          ),
                          Dimens.d5.spaceHeight,
                        ],
                      ),
                    ),
                  ),
                );
              }),

            ],
          ),
        ),
        loader == true ? commonLoader() : const SizedBox(),
      ],
    );
  }
}
