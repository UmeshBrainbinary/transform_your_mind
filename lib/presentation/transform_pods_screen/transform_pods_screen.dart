import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class TransformPodsScreen extends StatefulWidget {
  const TransformPodsScreen({super.key});

  @override
  State<TransformPodsScreen> createState() => _TransformPodsScreenState();
}

class _TransformPodsScreenState extends State<TransformPodsScreen>
    with TickerProviderStateMixin {
  bool ratingView = false;
  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  late AnimationController _controller;
  int ritualAddedCount = 0;
  late ScrollController scrollController = ScrollController();
  final AudioContentController audioContentController = Get.put(AudioContentController());
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  List? _filteredBookmarks;
  ValueNotifier selectedCategory = ValueNotifier(null);
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);
  ThemeController themeController = Get.find<ThemeController>();


  @override
  void initState() {
   searchController.clear();
   audioContentController.getPodsData();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    isTutorialVideoVisible.value = (ritualAddedCount < 3);
    if (isTutorialVideoVisible.value) {
      _controller.forward();
    }
   scrollController.addListener(() {
     double showOffset = 10.0;

     if (scrollController.offset > showOffset) {
       showScrollTop.value = true;
     } else {
       showScrollTop.value = false;
     }
   });
    super.initState();
  }


  searchBookmarks(String query, List bookmarks) {
    return bookmarks
        .where((bookmark) =>
            bookmark['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
        appBar: CustomAppBar(
          title: "transformPods".tr,
          showBack: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    suffixIcon: searchController.text.isEmpty?const SizedBox(): Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: GestureDetector(
                      onTap: () {
                        searchController.clear();
                        setState(() {
                          audioContentController.getPodApi();
                        });
                      },child: SvgPicture.asset(ImageConstant.close)),
                    ),
                    hintText: "search".tr,
                    textStyle:
                    Style.nunRegular(fontSize: 12),
                    controller: searchController,
                    focusNode: searchFocusNode),
              ),
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
                                  searchFocusNode.unfocus();
                                  if(!controller.audioData[index].isPaid!){
                                  }else{
                                    _onTileClick(
                                      context: context,
                                      index: index,
                                      audioContent:
                                      controller.audioData[index],
                                    );
                                  }
                                  },
                                child: Stack(
                                  children: [
                                    Column(
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
                                                // "Motivational",
                                                style: Style
                                                    .nunitoBold(
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
                                                Dimens.d5.spaceWidth,
                                                Text(
                                                  "${controller
                                                      .audioData[index].rating
                                                      .toString()}.0" ?? '',
                                                  style: Style
                                                      .nunMedium(
                                                    fontSize:
                                                    Dimens.d12,
                                                  ),
                                                ),
                                              ],
                                            ),

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
                                    !controller.audioData[index].isPaid!?Container(
                                      margin: const EdgeInsets.all(7.0),
                                      height: 14,width: 14,
                                      decoration: const BoxDecoration(color: Colors.black,shape: BoxShape.circle),
                                      child: Center(child: Image.asset(ImageConstant.lockHome,height: 7,width: 7,)),
                                    ):const SizedBox()
                                  ],
                                ),
                              );
                            })
                            : Padding(
                          padding: const EdgeInsets.only(top: Dimens.d50),
                          child: Column(
                            children: [
                              SvgPicture.asset(ImageConstant.noSearch,),
                              Text("dataNotFound".tr,style: Style.gothamMedium(
                                  fontSize: 24,fontWeight: FontWeight.w700),),
                              Dimens.d11.spaceHeight,
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35),
                                child: Text("noSearchAgain".tr,
                                  textAlign: TextAlign.center,
                                  style: Style.montserratRegular(fontSize: 14,fontWeight: FontWeight.w400),),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  )),

            ],
          ),
        ));
  }

  void _onTileClick({int? index, BuildContext? context, required AudioData audioContent}) {
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
        return NowPlayingScreen( audioData: audioContent,);
      },
    );
  }


}
