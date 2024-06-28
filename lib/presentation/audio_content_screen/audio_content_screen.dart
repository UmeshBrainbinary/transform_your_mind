import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/main.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/notification_screen/notification_screen.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';

class AudioContentScreen extends StatefulWidget {
  const AudioContentScreen({super.key});

  @override
  State<AudioContentScreen> createState() => _AudioContentScreenState();
}

class _AudioContentScreenState extends State<AudioContentScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final AudioContentController audioContentController =
      Get.put(AudioContentController());
  late final AnimationController _lottieBgController;
  late ScrollController scrollController = ScrollController();
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);
  TextEditingController ratingController = TextEditingController();
  FocusNode ratingFocusNode = FocusNode();

  ThemeController themeController = Get.find<ThemeController>();
  final nowPlayController = Get.put(NowPlayingController());

  @override
  void initState() {
    audioContentController.searchController.clear();
    _lottieBgController = AnimationController(vsync: this);

    scrollController.addListener(() {
      double showOffset = 10.0;

      if (scrollController.offset > showOffset) {
        showScrollTop.value = true;
      } else {
        showScrollTop.value = false;
      }
    });
    themeController.isDarkMode.isTrue?
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.darkBackground, // Status bar background color
      statusBarIconBrightness: Brightness.light, // Status bar icon/text color
    )):
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.white, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    audioContentController.getPodsData();
    super.initState();
  }

  @override
  void dispose() {
    _lottieBgController.dispose();
    super.dispose();
  }

  final audioPlayerController = Get.find<NowPlayingController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(backgroundColor:
          themeController.isDarkMode.isTrue?
          ColorConstant.darkBackground:ColorConstant.white,
            floatingActionButton: ValueListenableBuilder(
              valueListenable: showScrollTop,
              builder: (context, value, child) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 700), //show/hide animation
                  opacity: showScrollTop.value
                      ? 1.0
                      : 0.0, //set opacity to 1 on visible, or hide
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstant.colorBFD0D4,
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                        );
                      },
                      child: Container(
                        height: Dimens.d60,
                        width: Dimens.d60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstant.colorBFD0D4,
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorConstant.themeColor,
                          ),
                          child: Transform.scale(
                            scale: 0.35,
                            child: SvgPicture.asset(
                              ImageConstant.upArrow,
                              height: Dimens.d20.h,
                              color: ColorConstant.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
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
                              Row(
                                children: [
                                  Text(
                                    "audioContent".tr,
                                    style: Style.montserratRegular(fontSize: 18),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return const NotificationScreen();
                                        },
                                      ));
                                    },
                                    child: SvgPicture.asset(
                                        ImageConstant.notification,
                                        height: Dimens.d25,
                                        width: Dimens.d25),
                                  ),
                                ],
                              ),
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
                              GetBuilder<AudioContentController>(
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
                                                  audioContentController
                                                      .searchFocusNode
                                                      .unfocus();
                                                   if(controller.audioData[index].isPaid!){
                                                     _onTileClick(
                                                         audioContent: controller
                                                             .audioData[index],
                                                         context);
                                                   }else{
                                                     Navigator.push(context, MaterialPageRoute(
                                                       builder: (context) {
                                                         return SubscriptionScreen(
                                                           skip: false,
                                                         );
                                                       },
                                                     ));
                                                   }

                                                },
                                                child: Stack(alignment: Alignment.topRight,
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
                                                                  "${controller.audioData[index].rating.toString()}.0" ??
                                                                      '',
                                                                  style: Style
                                                                      .montserratMedium(
                                                                    fontSize:
                                                                        Dimens.d12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            controller.audioData[index]
                                                                        .download ==
                                                                    false
                                                                ? GestureDetector(
                                                                    onTap: () async {

                                                                      controller.setDownloadView(
                                                                        fileName: controller
                                                                            .audioData[
                                                                        index].name,
                                                                        index: index,
                                                                          context:
                                                                              context,
                                                                          url: controller
                                                                              .audioData[
                                                                                  index]
                                                                              .audioFile);
                                                                      setState(() {

                                                                      });
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
                                                                            color: Colors
                                                                                .green,
                                                                            width:
                                                                                1.5)),
                                                                    child: const Icon(
                                                                      Icons.check,
                                                                      color:
                                                                          Colors.green,
                                                                      size: 18,
                                                                    ),
                                                                  )
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
                                          padding: const EdgeInsets.only(bottom: Dimens.d130),
                                          child: Image.asset(themeController.isDarkMode.isTrue?ImageConstant.searchDark:ImageConstant.searchNotFound,height: 245,width: 288,),
                                        ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Obx(() {
                  if (!audioPlayerController.isVisible.value) {
                    return const SizedBox.shrink();
                  }
                  final currentPosition =
                      audioPlayerController.positionStream.value ?? Duration.zero;
                  final duration =
                      audioPlayerController.durationStream.value ?? Duration.zero;
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
                      ).then((value) {

                      },);
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 87,
                        width: Get.width,
                        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
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
                          children: [
                            Row(
                              children: [
                                CommonLoadImage(borderRadius: 6.0,
                                    url:audioDataStore!.image!,
                                    width: 47,
                                       height: 47),
                                Dimens.d12.spaceWidth,
                                GestureDetector(
                                    onTap: () async {
                                      if (isPlaying) {
                                        await audioPlayerController.pause();
                                      } else {
                                        await audioPlayerController.play();
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
                                    style: Style.montserratRegular(
                                        fontSize: 12, color: ColorConstant.white),
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
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                    ColorConstant.white.withOpacity(0.2),
                                inactiveTrackColor: ColorConstant.color6E949D,
                                trackHeight: 1.5,
                                thumbColor: ColorConstant.transparent,
                                // Color of the thumb
                                thumbShape: SliderComponentShape.noThumb,
                                // Customize the thumb shape and size
                                overlayColor:
                                    ColorConstant.backGround.withAlpha(32),
                                // Color when thumb is pressed
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius:
                                        16.0), // Customize the overlay shape and size
                              ),
                              child: Slider(
                                thumbColor: Colors.transparent,
                                activeColor: ColorConstant.backGround,
                                value: currentPosition.inMilliseconds.toDouble(),
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  audioPlayerController.seekForMeditationAudio(
                                      position:
                                          Duration(milliseconds: value.toInt()));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
       Obx(() =>   audioContentController.loaderD.isTrue?commonLoader():const SizedBox(),)
        ],
      ),
    );
  }

  void _onTileClick(BuildContext context, {AudioData? audioContent}) {
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
          audioData: audioContent,
        );
      },
    );
  }


}

