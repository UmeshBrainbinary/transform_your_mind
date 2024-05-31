
/*class CategoryDropDown extends StatelessWidget {
  final ValueNotifier<GroupedCategoryData?> selectedCategory;
  final VoidCallback onSelected;
  final List<GroupedCategoryData> categoryList;

  const CategoryDropDown({
    required this.onSelected,
    required this.selectedCategory,
    required this.categoryList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<GroupedCategoryData>(
      color: themeManager.colorThemed1,
      initialValue: selectedCategory.value,
      constraints: BoxConstraints(
        //minWidth: MediaQuery.of(context).size.width - 10,
        maxWidth: (MediaQuery.sizeOf(context).width / 2) - 20,
        maxHeight: 300,
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      onSelected: (GroupedCategoryData value) {
        bool isSelected = selectedCategory.value?.id == value.id;
        if (isSelected) {
          selectedCategory.value = null;
        } else {
          selectedCategory.value = value;
        }
        onSelected();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      itemBuilder: (BuildContext context) {
        return List<PopupMenuEntry<GroupedCategoryData>>.generate(
          categoryList.length,
          (int index) {
            final item = categoryList[index];
            bool isSelected = selectedCategory.value?.id == item.id;
            return PopupMenuItem(
              value: categoryList[index],
              padding: EdgeInsets.zero,
              child: AnimatedBuilder(
                animation: selectedCategory,
                builder: (BuildContext context, Widget? child) {
                  return child!;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20).r,
                  child: Text(
                    item.name ?? '',
                    style: Style.mockinacRegular(
                      fontSize: Dimens.d14,
                      color: AppColors.textGreyColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: ValueListenableBuilder(
        valueListenable: selectedCategory,
        builder: (BuildContext context, value, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey),
              borderRadius: BorderRadius.circular(30),
              color: themeManager.colorThemed5,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCategory.value?.name ?? i10n.selectCategory,
                  style: Style.mockinacRegular(
                    fontSize: Dimens.d14,
                    color: AppColors.white,
                  ),
                ),
                SvgPicture.asset(
                  AppAssets.icDownArrow,
                  height: 20.r,
                  color: AppColors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';

class CategoryDropDown extends StatelessWidget {
  final ValueNotifier selectedCategory;
  final VoidCallback onSelected;
  final List categoryList;

  const CategoryDropDown({
    required this.onSelected,
    required this.selectedCategory,
    required this.categoryList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstant.lightGrey),
        borderRadius: BorderRadius.circular(30),
        color: ColorConstant.themeColor,
      ),
      child: Theme(
        data: ThemeData(highlightColor: Colors.red,platform: TargetPlatform.iOS
          // Customize your theme properties here
        ),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            interactive: true,

            trackVisibility: MaterialStateProperty.all(true),
            thumbVisibility: MaterialStateProperty.all(true),
            thumbColor: MaterialStateProperty.all(ColorConstant.textGreyColor),
            // Customize thumb color
            radius:
                const Radius.circular(8), // Customize the scrollbar thumb radius
            // Add more properties as needed
          ),
          child: Scrollbar(
            trackVisibility: true,
            interactive: true,
            thickness: 3.0,
            thumbVisibility: true,
            controller: scrollController,
            child: DropdownButton(
              value: selectedCategory.value,
              borderRadius: BorderRadius.circular(30),
              onChanged: (value) {
                {
                  bool isSelected = selectedCategory.value?.id == value?.id;
                  if (isSelected) {
                    selectedCategory.value = null;
                  } else {
                    selectedCategory.value = value;
                  }
                  onSelected();
                }
              },
              selectedItemBuilder: (_) {
                return categoryList.map<Widget>(( item) {
                  bool isSelected = selectedCategory.value?.id == item.id;
                  return Padding(
                    padding: const EdgeInsets.only(left: 18, top: 17),
                    child: Text(
                      item.name ?? '',
                      style: Style.montserratRegular(
                        fontSize: Dimens.d14,
                        color: Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
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
              dropdownColor: ColorConstant.colorThemed1,
              items: categoryList.map<DropdownMenuItem>(
                  (item) {
                bool isSelected = selectedCategory.value?.id == item.id;
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
                        item.name ?? '',
                        style: Style.montserratRegular(
                          fontSize: Dimens.d14,
                          color: ColorConstant.textGreyColor,
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
        ),
      ),
    );
  }
}
