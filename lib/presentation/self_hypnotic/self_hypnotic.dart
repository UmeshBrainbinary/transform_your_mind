import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/home_screen/home_controller.dart';
import 'package:transform_your_mind/presentation/search_screen/s_controller.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class SelfHypnotic extends StatefulWidget {
  const SelfHypnotic({super.key});

  @override
  State<SelfHypnotic> createState() => _SelfHypnoticState();
}

class _SelfHypnoticState extends State<SelfHypnotic> {
  HomeController homeController = Get.find<HomeController>();
  SController sController = Get.put(SController());
  AudioContentController audioContentController =
  Get.put(AudioContentController());
  FocusNode searchFocusNode = FocusNode();
  late ScrollController scrollController = ScrollController();
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);
  ThemeController themeController = Get.find<ThemeController>();
  String currentLanguage = PrefService.getString(PrefKey.language);

  @override
  void initState() {
    checkInternet();
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
 getAudio() async {
   await homeController.getSelfHypnoticApi();

 }
  String _formatDuration(Duration? duration) {
    if (duration == null) return "00:00";
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
  checkInternet() async {
    if (await isConnected()) {
      getAudio();
    } else {
      showSnackBarError(Get.context!, "noInternet".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomInset > 0;
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.white,
      appBar: CustomAppBar(
        title: "selfHypnotic".tr,
        showBack: true,
      ),
      body: Stack(
        children: [
          isKeyboardOpen
              ? const SizedBox()
              : Align(
            alignment: const Alignment(1, 0),
            child: SvgPicture.asset(
                themeController.isDarkMode.isTrue
                    ? ImageConstant.profile1Dark
                    : ImageConstant.bgVector,
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

                        GetBuilder<HomeController>(
                          id: 'home',
                          builder: (controller) {
                            return Expanded(
                              child: controller.audioDataSelfHypnotic.isNotEmpty
                                  ?   (PrefService.getBool(PrefKey.isSubscribed) ==true && PrefService.getString(PrefKey.subId) =="transform_yearly")?
                              GridView.builder(
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
                                  itemCount: controller.audioDataSelfHypnotic.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {


                                          _onTileClick(index: index,
                                              audioContent: controller
                                                  .audioData[index],
                                              context: context,controller: controller);

                                      },
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Column(
                                            children: [
                                              Stack(
                                                alignment:
                                                Alignment.topRight,
                                                children: [
                                                  CommonLoadImage(
                                                    borderRadius: 10,
                                                    url: controller
                                                        .audioDataSelfHypnotic[
                                                    index]
                                                        .image ??
                                                        "",
                                                    width: Dimens.d170,
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
                                                      child:
                                                      SvgPicture.asset(
                                                          ImageConstant
                                                              .play),
                                                    ),
                                                  ),
                                                  Positioned( bottom: 6.0,
                                                    right: 6.0,
                                                    child: Container(padding:  EdgeInsets.only(  top:Platform.isIOS?0: 1),
                                                      height: 12,width: 30,decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                                                          borderRadius: BorderRadius.circular(13)),
                                                      child: Center(child: Text( controller.audioDataSelfHypnotic.length > index ? _formatDuration( controller.audioListDurationSelf[index]) : '8:00',style: Style.nunRegular(fontSize: 6,color: Colors.white),),) ,),
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
                                                      currentLanguage=="en-US"?controller
                                                          .audioDataSelfHypnotic[index]
                                                          .name
                                                          .toString():controller
                                                          .audioDataSelfHypnotic[index]
                                                          .gName
                                                          .toString(),
                                                      // "Motivational",
                                                      style:
                                                      Style.nunMedium(
                                                        fontSize:
                                                        Dimens.d14,
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
                                                        ImageConstant
                                                            .rating,
                                                        color: ColorConstant
                                                            .colorFFC700,
                                                        height: 10,
                                                        width: 10,
                                                      ),
                                                      Dimens.d3.spaceWidth,
                                                      Text(
                                                        "${controller.audioDataSelfHypnotic[index].rating.toString()}.0",
                                                        style:
                                                        Style.nunMedium(
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
                                                currentLanguage=="en-US"? controller.audioDataSelfHypnotic[index]
                                                    .description
                                                    .toString():controller.audioDataSelfHypnotic[index]
                                                    .gDescription
                                                    .toString(),
                                                maxLines: Dimens.d2.toInt(),
                                                style: Style.nunMedium(
                                                    fontSize: Dimens.d14),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),


                                        ],
                                      ),
                                    );
                                  })
                                  :GridView.builder(
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
                                  itemCount: controller.audioDataSelfHypnotic.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {

                                        if (controller
                                            .audioDataSelfHypnotic[index].isPaid!) {

                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return SubscriptionScreen(
                                                    skip: false,
                                                  );
                                                },
                                              ));
                                        } else {
                                          _onTileClick(index: index,
                                              audioContent: controller
                                                  .audioData[index],
                                              context: context,controller: controller);
                                        }
                                      },
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Column(
                                            children: [
                                              Stack(
                                                alignment:
                                                Alignment.topRight,
                                                children: [
                                                  CommonLoadImage(
                                                    borderRadius: 10,
                                                    url: controller
                                                        .audioDataSelfHypnotic[
                                                    index]
                                                        .image ??
                                                        "",
                                                    width: Dimens.d170,
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
                                                      child:
                                                      SvgPicture.asset(
                                                          ImageConstant
                                                              .play),
                                                    ),
                                                  ),
                                                  controller.audioListDurationSelf.length !=0?
                                                  Positioned( bottom: 6.0,
                                                    right: 6.0,
                                                    child: Container(padding:  EdgeInsets.only(  top:Platform.isIOS?0: 1),
                                                      height: 12,width: 30,decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                                                          borderRadius: BorderRadius.circular(13)),
                                                      child: Center(child: Text( controller.audioDataSelfHypnotic.length > index ? _formatDuration( controller.audioListDurationSelf[index]) : '8:00',style: Style.nunRegular(fontSize: 6,color: Colors.white),),) ,),
                                                  ):const SizedBox()
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
                                                      currentLanguage=="en-US"?controller
                                                          .audioDataSelfHypnotic[index]
                                                          .name
                                                          .toString():controller
                                                          .audioDataSelfHypnotic[index]
                                                          .gName
                                                          .toString(),
                                                      // "Motivational",
                                                      style:
                                                      Style.nunMedium(
                                                        fontSize:
                                                        Dimens.d14,
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
                                                        ImageConstant
                                                            .rating,
                                                        color: ColorConstant
                                                            .colorFFC700,
                                                        height: 10,
                                                        width: 10,
                                                      ),
                                                      Dimens.d3.spaceWidth,
                                                      Text(
                                                        "${controller.audioDataSelfHypnotic[index].rating.toString()}.0",
                                                        style:
                                                        Style.nunMedium(
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
                                                currentLanguage=="en-US"? controller.audioDataSelfHypnotic[index]
                                                    .description
                                                    .toString():controller.audioDataSelfHypnotic[index]
                                                    .gDescription
                                                    .toString(),
                                                maxLines: Dimens.d2.toInt(),
                                                style: Style.nunMedium(
                                                    fontSize: Dimens.d14),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          controller
                                              .audioDataSelfHypnotic[index].isPaid!
                                              ? Container(
                                            margin:
                                            const EdgeInsets.all(
                                                7.0),
                                            height: 14,
                                            width: 14,
                                            decoration:
                                            const BoxDecoration(
                                                color:
                                                Colors.black,
                                                shape: BoxShape
                                                    .circle),
                                            child: Center(
                                                child: Image.asset(
                                                  ImageConstant.lockHome,
                                                  height: 7,
                                                  width: 7,
                                                )),
                                          )
                                              : const SizedBox(),

                                        ],
                                      ),
                                    );
                                  })
                                  : Center(
                                    child: Padding(
                                      padding:  EdgeInsets.only(top: Get.height*0.2),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            themeController.isDarkMode.isTrue
                                                ? ImageConstant.darkData
                                                : ImageConstant.noData,
                                          ),
                                          Text(
                                            "dataNotFound".tr,
                                            style: Style.gothamMedium(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Dimens.d11.spaceHeight,

                                        ],
                                      ),
                                    ),
                                  ),
                            );
                          },
                        ),
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

  void _onTileClick({HomeController? controller,
    AudioData? audioContent,int? index,
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
          audioData: AudioData(
            id: controller!.audioDataSelfHypnotic[index!].id,
            isPaid: controller.audioDataSelfHypnotic[index].isPaid,
            image: controller.audioDataSelfHypnotic[index].image,
            rating: controller.audioDataSelfHypnotic[index].rating,
            description:
            controller.audioDataSelfHypnotic[index].description,
            name: controller.audioDataSelfHypnotic[index].name,
            isBookmarked:
            controller.audioDataSelfHypnotic[index].isBookmarked,
            isRated: controller.audioDataSelfHypnotic[index].isRated,
            category: controller.audioDataSelfHypnotic[index].category,
            createdAt: controller.audioDataSelfHypnotic[index].createdAt,
            podsBy: controller.audioDataSelfHypnotic[index].podsBy,
            expertName:
            controller.audioDataSelfHypnotic[index].expertName,
            audioFile: controller.audioDataSelfHypnotic[index].audioFile,
            isRecommended:
            controller.audioDataSelfHypnotic[index].isRecommended,
            status: controller.audioDataSelfHypnotic[index].status,
            createdBy: controller.audioDataSelfHypnotic[index].createdBy,
            updatedAt: controller.audioDataSelfHypnotic[index].updatedAt,
            v: controller.audioDataSelfHypnotic[index].v,
            download: false,
          ),
        );
      },
    );
  }
}
