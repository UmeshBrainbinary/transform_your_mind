import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/search_screen/s_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SController sController = Get.put(SController());
  AudioContentController audioContentController =
      Get.put(AudioContentController());
  FocusNode searchFocusNode = FocusNode();
  late ScrollController scrollController = ScrollController();
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);
  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {

    audioContentController.getPodsData();
    themeController.isDarkMode.isTrue
        ? SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: ColorConstant.darkBackground,
            // Status bar background color
            statusBarIconBrightness:
                Brightness.light, // Status bar icon/text color
          ))
        : SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.white, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    scrollController.addListener(() {
      double showOffset = 10.0;

      if (scrollController.offset > showOffset) {
        showScrollTop.value = true;
      } else {
        showScrollTop.value = false;
      }
    });
    audioContentController
        .searchController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
      appBar: CustomAppBar(
        title: "search".tr,
        showBack: true,
      ),
      body: Stack(
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
                                  audioContentController.audioData =
                                      audioContentController.filterList(value,
                                          audioContentController.audioData);
                                });
                              },
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(ImageConstant.search),
                              ),
                              suffixIcon: audioContentController
                                  .searchController.text.isEmpty
                                  ? const SizedBox()
                                  : Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: GestureDetector(
                                    onTap: () {
                                      audioContentController.searchFocusNode.unfocus();

                                      audioContentController
                                          .searchController
                                          .clear();
                                      setState(() {
                                        audioContentController
                                            .getPodApi();
                                      });
                                    },
                                    child: SvgPicture.asset(
                                        ImageConstant.close)),
                              ),
                              hintText: "search".tr,
                              textStyle:
                              Style.montserratRegular(fontSize: 12),
                              controller:
                              audioContentController.searchController,
                              focusNode:
                              audioContentController.searchFocusNode),
                        ),

                        // const TransFormRitualsButton(),
                        Dimens.d20.h.spaceHeight,
                        Expanded(
                            child: GetBuilder<AudioContentController>(
                          id: 'update',
                          builder: (controller) {
                            return Expanded(
                              child: controller.audioData.isNotEmpty
                                  ? GridView.builder(
                                      controller: scrollController,
                                      padding: const EdgeInsets.only(
                                          bottom: Dimens.d20),
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 0.78,
                                        crossAxisCount: 2,
                                        // Number of columns
                                        crossAxisSpacing: 20,
                                        // Spacing between columns
                                        mainAxisSpacing:
                                            20, // Spacing between rows
                                      ),
                                      itemCount: controller.audioData.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            controller.searchFocusNode.unfocus();
                                            _onTileClick(
                                              context: context,
                                              index: index,
                                              audioContent:
                                                  controller.audioData[index],
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  CommonLoadImage(
                                                    borderRadius: 10,
                                                    url: controller
                                                            .audioData[index]
                                                            .image ??
                                                        "",
                                                    width: Dimens.d156,
                                                    height: Dimens.d113,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 10,
                                                              top: 10),
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
                                                  SizedBox(
                                                    width: 90,
                                                    child: Text(
                                                      controller
                                                          .audioData[index]
                                                          .name
                                                          .toString(),
                                                      style: Style
                                                          .montserratMedium(
                                                        fontSize: Dimens.d12,
                                                      ),
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  const CircleAvatar(
                                                    radius: 2,
                                                    backgroundColor:
                                                        ColorConstant
                                                            .colorD9D9D9,
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
                                                        "${controller
                                                            .audioData[index].rating
                                                            .toString()}.0" ?? '',
                                                        style: Style
                                                            .montserratMedium(
                                                          fontSize:
                                                              Dimens.d12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                /*  controller.audioData[index]
                                                      .download ==
                                                      false
                                                      ? GestureDetector(
                                                    onTap: () async {

                                                    },
                                                    child: SvgPicture.asset(
                                                        ImageConstant
                                                            .downloadCircle,
                                                        height:
                                                        Dimens.d25,
                                                        width:
                                                        Dimens.d25),
                                                  )
                                                      : Container(
                                                    height: 22,
                                                    width: 22,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        border: Border.all(
                                                            color:  Colors.green,
                                                            width:
                                                            1.5)),
                                                    child: const Icon(
                                                      Icons.check,
                                                      color:
                                                      Colors.green,
                                                      size: 18,
                                                    ),
                                                  )*/
                                                ],
                                              ),
                                              Dimens.d7.spaceHeight,
                                              Text(
                                                controller.audioData[index]
                                                    .description
                                                    .toString(),
                                                maxLines: Dimens.d2.toInt(),
                                                style: Style.montserratMedium(
                                                    fontSize: Dimens.d14),
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                  : Padding(
                                padding: const EdgeInsets.only(bottom: Dimens.d130),
                                child: Image.asset(themeController.isDarkMode.isTrue?ImageConstant.searchDark:ImageConstant.searchNotFound,height: 245,width: 288,),
                              ),
                            );
                          },
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

  void _onTileClick({
    AudioData? audioContent,
    int? index,
    BuildContext? context,
  }) {
    showModalBottomSheet(
      context: context!,
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
          audioData: audioContent!,
        );
      },
    );
  }
}
