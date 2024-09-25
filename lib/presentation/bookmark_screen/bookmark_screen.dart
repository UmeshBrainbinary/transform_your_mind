import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/home_screen/home_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  HomeController homeController = Get.find<HomeController>();
  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    getData();
    super.initState();
  }
  getData() async {
    await homeController.getBookMarkedList();
    setState(() {
    });
  }
  String _formatDuration(Duration? duration) {
    if (duration == null) return "00:00";
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
  final audioPlayerController = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:Colors.white,
      appBar: CustomAppBar(
        title: "Bookmark".tr,
        showBack: true,
      ),
      body: Stack(
        children: [
          GetBuilder<HomeController>(
            id: 'update',
            builder: (controller) {
              return (controller.bookmarkedModel.data ?? []).isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: GridView.builder(
                          padding: const EdgeInsets.only(bottom: Dimens.d20),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.78,
                            crossAxisCount: 2,
                            // Number of columns
                            crossAxisSpacing: 20,
                            // Spacing between columns
                            mainAxisSpacing: 20, // Spacing between rows
                          ),
                          itemCount:
                              controller.bookmarkedModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (!controller
                                    .bookmarkedModel.data![index].isPaid!) {
                                } else {
                                  _onTileClick(
                                    context: context,
                                    index: index,
                                    audioContent: AudioData(
                                      id: controller
                                          .bookmarkedModel.data![index].id,
                                      isPaid: controller
                                          .bookmarkedModel.data![index].isPaid,
                                      image: controller
                                          .bookmarkedModel.data![index].image,
                                      rating: controller
                                          .bookmarkedModel.data![index].rating,
                                      description: controller.bookmarkedModel
                                          .data![index].description,
                                      name: controller
                                          .bookmarkedModel.data![index].name,
                                      isBookmarked: controller.bookmarkedModel
                                          .data![index].isBookmarked,
                                      isRated: controller
                                          .bookmarkedModel.data![index].isRated,
                                      category: controller.bookmarkedModel
                                          .data![index].category,
                                      createdAt: controller.bookmarkedModel
                                          .data![index].createdAt,
                                      podsBy: controller
                                          .bookmarkedModel.data![index].podsBy,
                                      expertName: controller.bookmarkedModel
                                          .data![index].expertName,
                                      audioFile: controller.bookmarkedModel
                                          .data![index].audioFile,
                                      isRecommended: controller.bookmarkedModel
                                          .data![index].isRecommended,
                                      status: controller
                                          .bookmarkedModel.data![index].status,
                                      createdBy: controller.bookmarkedModel
                                          .data![index].createdBy,
                                      updatedAt: controller.bookmarkedModel
                                          .data![index].updatedAt,
                                      v: controller
                                          .bookmarkedModel.data![index].v,
                                      download: false,
                                    ),
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
                                            url: controller.bookmarkedModel
                                                    .data![index].image ??
                                                "",
                                            width: Dimens.d170,
                                            height: Dimens.d113,
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10, top: 10),
                                              child: SvgPicture.asset(
                                                  ImageConstant.play),
                                            ),
                                          ),
                                          Positioned( bottom: 6.0,
                                            right: 6.0,
                                            child: Container(padding:  EdgeInsets.only(top: Platform.isIOS?0:1),
                                              height: 12,width: 30,decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(13)),
                                              child: Center(child: Text(controller.audioListDuration.length > index ? _formatDuration( controller.audioListDuration[index]) : 'Loading...',style: Style.nunRegular(fontSize: 6,color: Colors.white),),) ,),
                                          )
                                        ],
                                      ),
                                      Dimens.d10.spaceHeight,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: Text(
                                              controller.bookmarkedModel
                                                  .data![index].name
                                                  .toString(),
                                              // "Motivational",
                                              style: Style.nunMedium(
                                                fontSize: Dimens.d14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
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
                                                color:
                                                    ColorConstant.colorFFC700,
                                                height: 10,
                                                width: 10,
                                              ),
                                              Dimens.d3.spaceWidth,
                                              Text(
                                                "${controller.bookmarkedModel.data![index].rating.toString()}.0",
                                                style: Style.nunMedium(
                                                  fontSize: Dimens.d12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Dimens.d7.spaceHeight,
                                      Text(
                                        controller.bookmarkedModel.data![index]
                                            .description
                                            .toString(),
                                        maxLines: Dimens.d2.toInt(),
                                        style: Style.nunMedium(
                                            fontSize: Dimens.d14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  !controller
                                          .bookmarkedModel.data![index].isPaid!
                                      ? Container(
                                          margin: const EdgeInsets.all(7.0),
                                          height: 14,
                                          width: 14,
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Image.asset(
                                            ImageConstant.lockHome,
                                            height: 7,
                                            width: 7,
                                          )),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            );
                          }),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.d100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            ImageConstant.noData,
                          ),
                          Text(
                            "dataNotFound".tr,
                            style: Style.gothamMedium(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                          Dimens.d11.spaceHeight,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Text(
                              "noSearchAgain".tr,
                              textAlign: TextAlign.center,
                              style: Style.nunRegular(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
          homeController.loader.isTrue ? commonLoader() : const SizedBox(),
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
    );
  }

  void _onTileClick(
      {int? index, BuildContext? context, required AudioData audioContent}) {
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
          audioData: audioContent,
        );
      },
    ).then((value) {

      getData();
      setState(() {

      });
    },);
  }
}
