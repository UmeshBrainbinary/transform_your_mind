import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/custom_chip.dart';
import 'package:transform_your_mind/core/common_widget/select_focus_button.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_affirmation_focus_page.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class Tag {
  final String name;
  bool isSelected;

  Tag(this.name, this.isSelected);
}

class SelectYourFocusPage extends StatefulWidget {
  const SelectYourFocusPage({
    Key? key,
    required this.isFromMe,
  }) : super(key: key);
  static const selectFocus = '/selectFocus';

  final bool isFromMe;

  @override
  State<SelectYourFocusPage> createState() => _SelectYourFocusPageState();
}

class _SelectYourFocusPageState extends State<SelectYourFocusPage> {
  List<Tag> listOfTags = [
    Tag("Weight loss", false),
    Tag("Meditations", false),
    Tag("Find love", false),
    Tag("Relive past trauma", false),
    Tag("Business motivation", false),
    Tag("Sleep", false),
    Tag("Reduce Stress", false),
    Tag("Calm", false),
    Tag("Health", false),
    Tag("Relationship Breakup", false),
    Tag("Myself", false),
    Tag("Diet", false),
    Tag("Personal growth", false),
    Tag("Giving Back", false),
    Tag("Hobbies", false),
    Tag("Mental Health", false),
    Tag("Financial Stability", false),
    Tag("Spirituality", false),
    Tag("Leisure", false),
    Tag("Career", false),
    Tag("Education", false),
    Tag("Self Love", false),
    Tag("Self Acceptance", false),
    Tag("Friendship", false),
    Tag("Relationship", false),
    Tag("Go getting", false),
    Tag("Intuition", false),
    Tag("Addition", false),
    Tag("Grief", false),
    Tag("Birth", false),
    Tag("With Music", false),
  ];

  List<String> selectedTagNames = [];

  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
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
    return Scaffold(

      appBar: const CustomAppBar(
        title: "Select Your Focus",
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          !themeController.isDarkMode.value
          ? BackGroundContainer(
            image: ImageConstant.imgSelectFocus,
            isLeft: false,
            top: Dimens.d100.h,
            height: Dimens.d230.h,
          ) : SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: Column(
              children: [
                Dimens.d40.spaceHeight,
                Text(
                  "What areas in your life do you want to focus on and to receive daily doses of positivity? Select minimum 5",
                  style: Style.montserratRegular(
                      color: themeController.isDarkMode.value ? ColorConstant.white : ColorConstant.black,
                      fontSize: Dimens.d14,
                      fontWeight: FontWeight.w600),
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
                FocusSelectButton(
                  primaryBtnText: widget.isFromMe ? "Save" : "Next",
                  secondaryBtnText: widget.isFromMe ? '' : "Skip",
                  isLoading: false,
                  primaryBtnCallBack: () {
                    if (selectedTagNames.length >= 5) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return const SelectYourAffirmationFocusPage(isFromMe: false);
                      },));
                      // Implement your save or next functionality here
                    } else {
                      showSnackBarError(context, 'Please add more then 5  Focuses');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
