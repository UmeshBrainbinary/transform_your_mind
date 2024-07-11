import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/no_data_available.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/divider.dart';


import 'lottie_icon_button.dart';
import 'ritual_tile.dart';

class FocusFilterBottomSheetChild extends StatefulWidget {
  const FocusFilterBottomSheetChild({
    Key? key,
    required this.listOfSelectFocusResponse,
    required this.onViewResults,
  }) : super(key: key);

  final List? listOfSelectFocusResponse;
  final Function(List, List) onViewResults;

  @override
  State<FocusFilterBottomSheetChild> createState() =>
      _FocusFilterBottomSheetChildState();
}

class _FocusFilterBottomSheetChildState
    extends State<FocusFilterBottomSheetChild> {
  List addedResult = [];
  List filtersList = [];

  @override
  void initState() {
    super.initState();
   /* for (var element in widget.listOfSelectFocusResponse!) {
      filtersList.add(FocusData.fromJson(element.toJson()));
    }
    filtersList.map((e) {
      if (e.isSelected) {
        addedResult.add(e);
      }
    }).toList();*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height - kBottomNavigationBarHeight * 2,
        child: LayoutContainer(
          horizontal: Dimens.d0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Dimens.d20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Refine Results",
                                style:
                                    Style.montserratRegular(fontSize: Dimens.d18),
                              ),
                              Dimens.d4.spaceHeight,
                              Text(
                                '${filtersList.length} items}',
                                style: Style.montserratRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.normal,
                                  color: ColorConstant.textGreyColor,
                                ),
                              ),
                            ],
                          ),
                          LottieIconButton(
                            icon: ImageConstant.lottieClose,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                    if (addedResult.isNotEmpty)
                      ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          Dimens.d20.spaceHeight,
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                            clipBehavior: Clip.none,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: addedResult.map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.all(Dimens.d5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorConstant.themeColor
                                            .withOpacity(.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(Dimens.d80)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: Dimens.d14),
                                            child: Text(e.focusName ?? ''),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              int removeIndex = filtersList
                                                  .indexWhere((element) {
                                                return element.focusName ==
                                                    e.focusName;
                                              });
                                              addedResult.remove(e);
                                              filtersList[removeIndex]
                                                  .isSelected = false;
                                              setState(() {});
                                            },
                                            splashColor: Colors.transparent,
                                            highlightColor:
                                                Colors.transparent,
                                            icon: const Icon(
                                              Icons.close,
                                              color: ColorConstant.themeColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Dimens.d20.spaceHeight,
                        ],
                      ),
                    GestureDetector(
                      onTap: () {
                        addedResult.clear();
                        for (int i = 0; i < filtersList.length; i++) {
                          filtersList[i].isSelected = false;
                        }
                        setState(() {});
                      },
                      child: (addedResult.isNotEmpty)
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20),
                              child: Text("ClearAll"),
                            )
                          : const Offstage(),
                    ),
                    Expanded(
                      flex: 5,
                      child: filtersList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                bottom: Dimens.d30,
                              ),
                              child: ListView.separated(
                                itemCount: filtersList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return RitualTile(
                                    onTap: () {
                                      filtersList[index].isSelected =
                                          !filtersList[index].isSelected;
                                      if (filtersList[index].isSelected) {
                                        addedResult.add(filtersList[index]);
                                      } else {
                                        addedResult.remove(filtersList[index]);
                                      }
                                      setState(() {});
                                    },
                                    title: filtersList[index].focusName ?? '',
                                    subTitle: '',
                                    image: /*filtersList[index].isSelected
                                        ? getAssetAccordingToTheme(
                                            shoorah: AppAssets
                                                .imgSelectedRitualShoorah,
                                            land:
                                                AppAssets.imgSelectedRitualLand,
                                            bloom: AppAssets
                                                .imgSelectedRitualBloom,
                                            sun: AppAssets.imgSelectedRitualSun,
                                            ocean: AppAssets
                                                .imgSelectedRitualOcean,
                                            desert: AppAssets
                                                .imgSelectedRitualDesert,
                                          )
                                        :*/ ImageConstant.imgAddRounded,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const DividerWidget();
                                },
                              ),
                            )
                          : const Center(
                              child: NoDataAvailable(),
                            ),
                    ),
                  ],
                ),
                filtersList.isNotEmpty
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.d20),
                          child: CommonElevatedButton(
                            title: "View Results",
                            onTap: () {
                              widget.onViewResults(addedResult, filtersList);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    : const Offstage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
