import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_widget/custom_chip.dart';
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
import 'package:transform_your_mind/model_class/focus_model.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_focus_page.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

import '../me_screen/screens/setting_screen/Page/notification_setting_screen/widget/reminder_time_utils.dart';
class SelectYourAffirmationFocusPage extends StatefulWidget {
  const SelectYourAffirmationFocusPage({
    Key? key,
    required this.isFromMe,
  }) : super(key: key);

  final bool isFromMe;

  @override
  State<SelectYourAffirmationFocusPage> createState() =>
      _SelectYourAffirmationFocusPageState();
}

class _SelectYourAffirmationFocusPageState
    extends State<SelectYourAffirmationFocusPage> {
  List<Tag> listOfTags = [
  ];

  List<String> selectedTagNames = [];
  ValueNotifier<String> selectedReminderTime = ValueNotifier('');
  ThemeController themeController = Get.find<ThemeController>();

  TextEditingController affirmationController = TextEditingController();

  ReminderTime? affirmationReminderTime;
  ReminderPeriod? affirmationReminderPeriod;
  FocusesModel focusesModel = FocusesModel();
  bool loader = false;

  getAffirmation() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.getFocus}6667e00b474a3621861060c0&type=1'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      focusesModel = focusesModelFromJson(responseBody);
      for (int i = 0; i < focusesModel.data!.length; i++) {
        listOfTags.add(Tag(focusesModel.data![i].name.toString(), false));
      }
      setState(() {});
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  setAffirmations() async {
    setState(() {
      loader = true;
    });
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'PUT',
          Uri.parse(
              '${EndPoints.baseUrl}${EndPoints.updateFocuses}6666e94525e35910c83f3b12'));
      request.body = json.encode({"affirmation": selectedTagNames});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await PrefService.setValue(PrefKey.affirmation, true);

        setState(() {
          loader = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const FreeTrialPage();
          },
        ));
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

  @override
  void initState() {
    getAffirmation();
    super.initState();
  }

  void _onTagTap(Tag tag) {
    setState(() {
      tag.isSelected = !tag.isSelected;
      if (tag.isSelected) {
        selectedTagNames.add(tag.name);
      } else {
        selectedTagNames.remove(tag.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "selectYourAffirmationFocus".tr,
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
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
              children: [
                Dimens.d40.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: AutoSizeText(
                    "chooseMinInterest".tr,
                    textAlign: TextAlign.center,
                    style: Style.montserratRegular(
                        color: themeController.isDarkMode.value
                            ? ColorConstant.white
                            : ColorConstant.black,
                        fontSize: Dimens.d14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Dimens.d24.spaceHeight,
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
                              label: tag.name,
                              isChipSelected: tag.isSelected,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                /*     ValueListenableBuilder(
                    valueListenable: selectedReminderTime,
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () {
                          showRemindersDialog(context, (value, reminderPeriod) {
                            affirmationController.text =
                                value.name + reminderPeriod.desc;
                            affirmationReminderTime = value;
                            affirmationReminderPeriod = reminderPeriod;
                          },
                              prevSelectedReminder: affirmationReminderTime,
                              prevSelectedReminderPeriod:
                                  affirmationReminderPeriod,
                              isAffirmations: true,
                              label: "affirmationsReminder".tr);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: Dimens.d24, right: Dimens.d24, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 4,
                                child: Text(
                                  "setReminders".tr,
                                  style: Style.montserratRegular(
                                      fontSize: Dimens.d16,
                                      color: themeController.isDarkMode.value
                                          ? ColorConstant.white
                                          : ColorConstant.black),
                                ),
                              ),
                              const Spacer(),
                              Dimens.d10.spaceWidth,
                              */ /*  if (state is! RemindersLoadingState)
                                Text(selectedReminderTime.value,
                                    style: Style.montserratRegular(
                                        fontSize: Dimens.d16,
                                        color: Colors.black)),*/ /*
                              SvgPicture.asset(ImageConstant.icDownArrow,
                                  height: 20),
                            ],
                          ),
                        ),
                      );
                    }),*/
                Dimens.d20.spaceHeight,
                FocusSelectButton(
                  primaryBtnText: widget.isFromMe ? "save".tr : "next".tr,
                  secondaryBtnText: widget.isFromMe ? '' : "skip".tr,
                  isLoading: false,
                  primaryBtnCallBack: () {
                    if (selectedTagNames.length >= 5) {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const FreeTrialPage();
                        },
                      ));
                    } else {
                      showSnackBarError(
                          context, 'Please choose more than 5 affirmation');
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
