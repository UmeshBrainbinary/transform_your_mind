import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/explore_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/search_screen/s_controller.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/custom_image_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SController sController = Get.put(SController());
  TextEditingController searchController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "search".tr,showBack: true,),
      body:  Stack(
        children: [
          Align(
            alignment: const Alignment(1, 0),
            child: SvgPicture.asset(ImageConstant.bgVector,
                height: Dimens.d230.h),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return ConstrainedBox(
                  constraints:
                  BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [

                        Dimens.d30.h.spaceHeight,
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color:
                                ColorConstant.themeColor.withOpacity(0.1),
                                blurRadius: Dimens.d8,
                              )
                            ],
                          ),
                          child: CommonTextField(
                              onChanged: (value) {
                                setState(() {
                                  sController.filteredList =
                                      sController.filterList(value,
                                          sController.exploreList);
                                });
                              },
                              suffixIcon: SvgPicture.asset(
                                  ImageConstant.searchExplore,
                                  height: 40,
                                  width: 40),
                              hintText: "audioContent".tr,
                              controller: searchController,
                              focusNode: searchFocusNode),
                        ),
                        // const TransFormRitualsButton(),
                        Dimens.d20.h.spaceHeight,
                        Expanded(
                            child: Obx(
                                  () => sController.filteredList!=null
                                  ? GridView.builder(
                                  padding: const EdgeInsets.only(
                                      bottom: Dimens.d20),
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.71,
                                    crossAxisCount: 2,
                                    // Number of columns
                                    crossAxisSpacing: 20,
                                    // Spacing between columns
                                    mainAxisSpacing:
                                    20, // Spacing between rows
                                  ),
                                  itemCount:
                                  sController.filteredList?.length??0,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        searchFocusNode.unfocus();
                                        _onTileClick(index, context);
                                      },
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              CustomImageView(
                                                imagePath: sController
                                                    .filteredList![index]
                                                ['image'],
                                                height: Dimens.d135,
                                                radius:
                                                BorderRadius.circular(10),
                                                fit: BoxFit.cover,
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      right: 10, top: 10),
                                                  child: SvgPicture.asset(
                                                      ImageConstant.play),
                                                ),
                                              )
                                            ],
                                          ),
                                          Dimens.d10.spaceHeight,
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "Meditation",
                                                style: Style.montserratMedium(
                                                  fontSize: Dimens.d12,
                                                ),
                                              ),
                                              const CircleAvatar(
                                                radius: 2,
                                                backgroundColor:
                                                ColorConstant.colorD9D9D9,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    ImageConstant.rating,
                                                    color: ColorConstant
                                                        .colorFFC700,
                                                    height: 10,
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "4.0" ?? '',
                                                    style: Style
                                                        .montserratMedium(
                                                      fontSize: Dimens.d12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SvgPicture.asset(
                                                  ImageConstant
                                                      .downloadCircle,
                                                  height: Dimens.d25,
                                                  width: Dimens.d25)
                                            ],
                                          ),
                                          Dimens.d7.spaceHeight,
                                          Text(
                                            sController
                                                .filteredList![index]['title'],
                                            maxLines: Dimens.d2.toInt(),
                                            style: Style.montserratMedium(
                                                fontSize: Dimens.d14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  : GridView.builder(
                                  padding: const EdgeInsets.only(
                                      bottom: Dimens.d20),
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.71,
                                    crossAxisCount: 2,
                                    // Number of columns
                                    crossAxisSpacing: 20,
                                    // Spacing between columns
                                    mainAxisSpacing: 20, // Spacing between rows
                                  ),
                                  itemCount:
                                  sController.exploreList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        searchFocusNode.unfocus();

                                        _onTileClick(index, context);
                                      },
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              CustomImageView(
                                                imagePath: sController
                                                    .exploreList[index]
                                                ['image'],
                                                height: Dimens.d135,
                                                radius:
                                                BorderRadius.circular(10),
                                                fit: BoxFit.cover,
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      right: 10, top: 10),
                                                  child: SvgPicture.asset(
                                                      ImageConstant.play),
                                                ),
                                              )
                                            ],
                                          ),
                                          Dimens.d10.spaceHeight,
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "Meditation",
                                                style: Style.montserratMedium(
                                                  fontSize: Dimens.d12,
                                                ),
                                              ),
                                              const CircleAvatar(
                                                radius: 2,
                                                backgroundColor:
                                                ColorConstant.colorD9D9D9,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    ImageConstant.rating,
                                                    color: ColorConstant
                                                        .colorFFC700,
                                                    height: 10,
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "4.0" ?? '',
                                                    style: Style
                                                        .montserratMedium(
                                                      fontSize: Dimens.d12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SvgPicture.asset(
                                                  ImageConstant.downloadCircle,
                                                  height: Dimens.d25,
                                                  width: Dimens.d25)
                                            ],
                                          ),
                                          Dimens.d7.spaceHeight,
                                          Text(
                                            sController
                                                .exploreList[index]['title'],
                                            maxLines: Dimens.d2.toInt(),
                                            style: Style.montserratMedium(
                                                fontSize: Dimens.d14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  void _onTileClick(int index, BuildContext context) {
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
        return const NowPlayingScreen();
      },
    );
  }
}
